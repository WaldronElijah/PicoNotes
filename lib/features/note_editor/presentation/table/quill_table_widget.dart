import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'table_model.dart';
import 'table_embed.dart';
import 'table_delete_bus.dart';

class QuillTableWidget extends StatefulWidget {
  final QuillController controller;
  final Embed node;
  final TableModel model;
  final bool readOnly;

  const QuillTableWidget({
    super.key,
    required this.controller,
    required this.node,
    required this.model,
    required this.readOnly,
  });

  @override
  State<QuillTableWidget> createState() => _QuillTableWidgetState();
}

class _QuillTableWidgetState extends State<QuillTableWidget> {
  late TableModel _model;
  late List<List<TextEditingController>> _controllers;
  late List<List<FocusNode>> _fns;

  static const double _padX = 12, _padY = 10, _rowH = 44;
  static const double _minCellW = 5 * 9.0 + _padX * 2; // ~5 chars default

  bool get _anyCellFocused =>
      _fns.any((row) => row.any((fn) => fn.hasFocus));

  /// Find our embed's offset in the document (by stable id)
  int _embedOffsetById(String id) {
    final delta = widget.controller.document.toDelta();
    int offset = 0;
    for (final op in delta.toList()) {
      final d = op.data;
      if (d is Map && d.containsKey('embed')) {
        final e = d['embed'];
        if (e is Map && e.containsKey(TableBlockEmbed.kType)) {
          final raw = e[TableBlockEmbed.kType];
          if (raw is String) {
            final map = jsonDecode(raw) as Map<String, dynamic>;
            if (map['id'] == id) return offset; // this object char
          }
        }
        offset += 1; // each embed == 1 char in doc
      } else if (d is String) {
        offset += d.length;
      } else {
        offset += 1;
      }
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    _model = widget.model;

    _controllers = List.generate(_model.rows, (r) {
      return List.generate(_model.cols, (c) {
        return TextEditingController(text: _model.cellText(r, c));
      });
    });

    _fns = List.generate(_model.rows, (r) {
      return List.generate(_model.cols, (c) {
        final fn = FocusNode();
        fn.addListener(() {
          // If any cell is focused, make SURE it is primary focus (so Quill caret disappears)
          if (fn.hasFocus) {
            // Make this the primary focus in this subtree
            FocusScope.of(context).requestFocus(fn);

            // Optional: move Quill selection just after our embed so it's never drawn at left
            final off = _embedOffsetById(_model.id);
            if (off >= 0) {
              // place the editor selection AFTER the embed + newline (safe spot)
              // if there's no newline yet, off+1 is still okay
              widget.controller.updateSelection(
                TextSelection.collapsed(offset: off + 1),
                ChangeSource.local,
              );
            }

            TableDeleteBus.clearAll();
          } else {
            // If no cells remain focused, clear any indicators
            if (!_anyCellFocused) {
              TableDeleteBus.clearAll();
              // Remove any lingering handles
              FocusScope.of(context).unfocus();
            }
          }
          setState(() {});
        });
        return fn;
      });
    });
  }

  @override
  void dispose() {
    for (final row in _controllers) {
      for (final c in row) {
        c.dispose();
      }
    }
    for (final row in _fns) {
      for (final f in row) {
        f.dispose();
      }
    }
    super.dispose();
  }

  // Safer replace keeping editor selection stable if the caret is not on our embed
  void _persist() {
    final targetId = _model.id;
    final delta = widget.controller.document.toDelta();
    int offset = 0;

    for (final op in delta.toList()) {
      final d = op.data;
      if (d is Map && d.containsKey('embed')) {
        final e = d['embed'];
        if (e is Map && e.containsKey(TableBlockEmbed.kType)) {
          final raw = e[TableBlockEmbed.kType];
          if (raw is String) {
            final map = jsonDecode(raw) as Map<String, dynamic>;
            if (map['id'] == targetId) {
              final newJsonStr = jsonEncode(_model.toJson());
              final newEmbed = TableBlockEmbed(newJsonStr);

              final sel = widget.controller.selection;
              // Keep selection unless it's sitting exactly on this embed char
              final newSel = (sel.baseOffset == offset)
                  ? TextSelection.collapsed(offset: offset + 1)
                  : sel;

              widget.controller.replaceText(
                offset,
                1,
                newEmbed,
                newSel,
              );
              return;
            }
          }
        }
        offset += 1;
      } else if (d is String) {
        offset += d.length;
      } else {
        offset += 1;
      }
    }
  }

  Widget _cell(int r, int c) {
    return SizedBox(
      height: _rowH,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _minCellW),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _padX, vertical: _padY),
          child: TextField(
            controller: _controllers[r][c],
            focusNode: _fns[r][c],
            readOnly: widget.readOnly,
            enableInteractiveSelection: false,   // ← no sticky blue handles
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(isDense: true, border: InputBorder.none),
            onTap: () {
              TableDeleteBus.clearAll();
              // Ensure this cell is primary focus (blurs Quill's caret if it was visible)
              FocusScope.of(context).requestFocus(_fns[r][c]);
            },
            onTapOutside: (_) {
              // Leaving the table by tapping outside → clear everything cleanly
              for (final row in _fns) {
                for (final f in row) {
                  f.unfocus();
                }
              }
              TableDeleteBus.clearAll();
            },
            onChanged: (v) {
              _model = _model.copyWithCell(r, c, v);
              _persist();                // live-sync back into the embed
              TableDeleteBus.clearAll(); // editing cancels "armed" delete
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withValues(alpha: 0.16);

    final tbl = Table(
      border: TableBorder(
        top: BorderSide(color: outline, width: 1),
        bottom: BorderSide(color: outline, width: 1),
        left: BorderSide(color: outline, width: 1),
        right: BorderSide(color: outline, width: 1),
        horizontalInside: BorderSide(color: outline, width: 1),
        verticalInside: BorderSide(color: outline, width: 1),
      ),
      columnWidths: {
        for (int c = 0; c < _model.cols; c++) c: const FixedColumnWidth(_minCellW),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(_model.rows, (r) {
        return TableRow(
          children: List.generate(_model.cols, (c) => _cell(r, c)),
        );
      }),
    );

    return ValueListenableBuilder<String?>(
      valueListenable: TableDeleteBus.armedId,
      builder: (_, armedId, __) {
        final armed = armedId == _model.id;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            boxShadow: armed
                ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.25), blurRadius: 8)]
                : const [],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // future growth
            child: tbl,
          ),
        );
      },
    );
  }
}
