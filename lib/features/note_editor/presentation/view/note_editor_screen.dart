import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../widgets/note_editor_toolbar.dart';
import '../widgets/note_editor_header.dart';
import '../widgets/custom_modals.dart';
import '../table/table_embed_builder.dart';
import '../table/table_embed.dart';
import '../table/table_model.dart';
import '../table/table_delete_bus.dart';
import '../../data/repository/note_repository.dart';
import '../../data/models/note.dart';
import '../../../../core/theme/theme_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final FocusNode _focusNode = FocusNode();
  final QuillController _quillController = QuillController.basic();
  bool _isSaving = false;
  final DateTime _createdAt = DateTime.now();
  final NoteRepository _noteRepository = NoteRepository();

  // Table delete constants
  static const String _kObjectChar = '\u{FFFC}'; // Quill's embed placeholder

  // Text formatting state
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  String _currentHeading = 'body'; // 'title', 'heading', 'subheading', 'body'

  // Smart list state
  bool _applyingSmartRule = false;

  // Helper to unset attributes in flutter_quill 11.4.2
  Attribute _unset(Attribute a) {
    // In 11.x Attribute has a public constructor (key, scope, value)
    // Setting value=null unsets it
    return Attribute(a.key, a.scope, null);
  }

  // Insert a 2x2 table using proper FlutterQuill embed
  void _insertTable2x2() {
    final sel = _quillController.selection;
    final embed = TableBlockEmbed.initial2x2();

    // Figure out current line bounds
    final line = _currentLinePlain(); // (start, end, text)
    int at = sel.baseOffset;

    // If the caret isn't at an empty line start, break the line before inserting
    final needsLeadingNewline = at != line.start || line.text.isNotEmpty;
    if (needsLeadingNewline) {
      _quillController.replaceText(
        at, 0, '\n', TextSelection.collapsed(offset: at + 1),
      );
      at += 1;
    }

    // Insert the table embed (object replacement char)
    _quillController.replaceText(
      at, 0, embed, TextSelection.collapsed(offset: at + 1),
    );
    at += 1;

    // Ensure a newline after the table so caret can move below
    _quillController.replaceText(
      at, 0, '\n', TextSelection.collapsed(offset: at + 1),
    );

    // Place caret on the new empty line BELOW the table
    _quillController.updateSelection(
      TextSelection.collapsed(offset: at + 1),
      ChangeSource.local,
    );
  }

  // Returns (start, end, text) for the current line based on the plain text
  ({int start, int end, String text}) _currentLinePlain() {
    final sel = _quillController.selection;
    final full = _quillController.document.toPlainText();
    final i = sel.baseOffset.clamp(0, full.length);
    final start = i > 0 ? (full.lastIndexOf('\n', i - 1) + 1) : 0;
    final nextNewline = full.indexOf('\n', i);
    final end = nextNewline == -1 ? full.length : nextNewline;
    final text = full.substring(start, end);
    return (start: start, end: end, text: text);
  }

  bool _isChecklistAtSelection() {
    final attrs = _quillController.getSelectionStyle().attributes;
    final list = attrs[Attribute.list.key]?.value;
    return list == 'unchecked' || list == 'checked';
  }

  // Returns the plain text (object chars + newlines included)
  String get _plain => _quillController.document.toPlainText();

  String? _tableEmbedIdAtObjectIndex(int objIndex) {
    final delta = _quillController.document.toDelta();
    int pos = 0;
    for (final op in delta.toList()) {
      final d = op.data;
      if (d is Map && d.containsKey('embed')) {
        if (pos == objIndex) {
          final embed = d['embed'];
          if (embed is Map && embed[TableBlockEmbed.kType] is String) {
            final jsonStr = embed[TableBlockEmbed.kType] as String;
            try {
              final model = TableModel.fromJson(jsonDecode(jsonStr));
              return model.id;
            } catch (e) {
              return null;
            }
          }
          return null;
        }
        pos += 1;
      } else if (d is String) {
        pos += d.length;
      } else {
        pos += 1;
      }
    }
    return null;
  }

  bool _deleteTableById(String id) {
    final delta = _quillController.document.toDelta();
    int pos = 0;
    for (final op in delta.toList()) {
      final d = op.data;
      if (d is Map && d.containsKey('embed')) {
        final embed = d['embed'];
        if (embed is Map && embed[TableBlockEmbed.kType] is String) {
          final jsonStr = embed[TableBlockEmbed.kType] as String;
          try {
            final model = TableModel.fromJson(jsonDecode(jsonStr));
            if (model.id == id) {
              _quillController.replaceText(
                pos,
                1,
                '',
                TextSelection.collapsed(offset: pos),
              );
              return true;
            }
          } catch (e) {
            // Continue searching
          }
        }
        pos += 1;
      } else if (d is String) {
        pos += d.length;
      } else {
        pos += 1;
      }
    }
    return false;
  }

  // Handle Backspace on an empty checklist line at line start.
  // Return KeyEventResult.handled when we consume the key.
  KeyEventResult _handleBackspaceForEmptyChecklist(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }

    final sel = _quillController.selection;
    if (!sel.isValid || !sel.isCollapsed) return KeyEventResult.ignored;

    if (!_isChecklistAtSelection()) return KeyEventResult.ignored;

    final line = _currentLinePlain();
    final caretAtLineStart = sel.baseOffset == line.start;
    final lineIsEmpty = line.text.trim().isEmpty;

    if (caretAtLineStart && lineIsEmpty) {
      // Remove the checklist attribute — turns it into a normal empty paragraph.
      _quillController.formatSelection(_unset(Attribute.list));
      // Optionally: keep caret where it is.
      _quillController.updateSelection(
        TextSelection.collapsed(offset: sel.baseOffset),
        ChangeSource.local,
      );
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // Smart list helpers - Apple Notes style auto-conversion
  void _scheduleSmartListCheck() {
    if (_applyingSmartRule) return;
    // Run after the space character is inserted
    WidgetsBinding.instance.addPostFrameCallback((_) => _applySmartListRule());
  }

  void _applySmartListRule() {
    if (_applyingSmartRule) return;
    final sel = _quillController.selection;
    if (!sel.isValid || !sel.isCollapsed) return;

    final line = _currentLinePlain();
    // Text from line start up to caret (what the user has typed on this line)
    final prefixLen = sel.baseOffset - line.start;
    if (prefixLen <= 0) return;
    final prefix = line.text.substring(0, prefixLen);

    // Only trigger when we're still at the start of the line (no preceding text)
    final atLineStart = prefix.trimLeft().length == prefix.length;

    // Patterns like Apple Notes
    final bulletRe = RegExp(r'^\s*([\-*•])\s$'); // "-", "*", "•" + space
    final orderedRe = RegExp(r'^\s*(\d+)[\.\)]\s$'); // "1. " or "1) "
    final checklistRe = RegExp(r'^\s*\[\s\]\s$'); // "[ ] " (optional)

    Attribute? toApply;
    int removeCount = 0;

    if (atLineStart && bulletRe.hasMatch(prefix)) {
      toApply = Attribute.ul;
      removeCount = prefix.length;
    } else if (atLineStart && orderedRe.hasMatch(prefix)) {
      toApply = Attribute.ol;
      removeCount = prefix.length;
    } else if (atLineStart && checklistRe.hasMatch(prefix)) {
      // Optional: auto-checklist like Notes' "task" list
      toApply =
          Attribute(Attribute.list.key, Attribute.list.scope, 'unchecked');
      removeCount = prefix.length;
    }

    if (toApply == null) return;

    _applyingSmartRule = true;
    try {
      // 1) Remove the typed marker (e.g., "1. " or "- ")
      _quillController.replaceText(
        line.start,
        removeCount,
        '',
        TextSelection.collapsed(offset: line.start),
      );

      // 2) Apply list attribute to the (now empty) line
      _quillController.formatSelection(toApply);

      // Caret stays at line.start; the user can start typing the first item.
    } finally {
      _applyingSmartRule = false;
    }
  }

  // Main key event handler that combines all features
  KeyEventResult _onEditorKey(FocusNode node, KeyEvent event) {
    // Handle Backspace for empty checklist deletion first
    final checklistHandled = _handleBackspaceForEmptyChecklist(event);
    if (checklistHandled != KeyEventResult.ignored) return checklistHandled;

    // Handle table delete logic (Obsidian-style)
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      final sel = _quillController.selection;
      if (sel.isValid && sel.isCollapsed) {
        final line = _currentLinePlain();
        final atLineStart = sel.baseOffset == line.start;

        if (atLineStart && line.start >= 2) {
          final i = line.start;
          // Looking for "...[object][newline]|"
          if (_plain[i - 1] == '\n' && _plain[i - 2] == _kObjectChar) {
            final tableId = _tableEmbedIdAtObjectIndex(i - 2);
            if (tableId != null) {
              if (TableDeleteBus.armedId.value == tableId) {
                final ok = _deleteTableById(tableId);
                TableDeleteBus.clearAll();
                return ok ? KeyEventResult.handled : KeyEventResult.ignored;
              } else {
                TableDeleteBus.arm(
                    tableId); // first Backspace → arm (highlight only)
                return KeyEventResult.handled;
              }
            }
          }
        }
      }
      // any other backspace path → unarm
      TableDeleteBus.clearAll();
    } else if (event is KeyDownEvent) {
      // any other key press → unarm
      TableDeleteBus.clearAll();
    }

    // When user presses SPACE, schedule a smart-list check after insertion
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _scheduleSmartListCheck();
      return KeyEventResult.ignored; // let space be inserted
    }

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();

    // Listen to Quill changes to update button states
    _quillController.addListener(_onQuillChanged);

    _focusNode.addListener(() {
      setState(() {
        // Focus state handled by toolbar visibility
      });
    });

    // Set initial format to Title (H1) for first words
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
      _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 1));
      setState(() => _currentHeading = 'title');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _quillController.dispose();
    super.dispose();
  }

  // Quill change listener to update button states
  void _onQuillChanged() {
    // Clear armed table state when selection moves
    TableDeleteBus.clearAll();

    final style = _quillController.getSelectionStyle(); // Style
    final attrs = style.attributes;

    setState(() {
      _isBold = attrs.containsKey(Attribute.bold.key);
      _isItalic = attrs.containsKey(Attribute.italic.key);
      _isUnderline = attrs.containsKey(Attribute.underline.key);
      _isStrikethrough = attrs.containsKey(Attribute.strikeThrough.key);

      // Heading state (map 1→title, 2→heading, 3→subheading)
      if (attrs.containsKey(Attribute.header.key)) {
        final h = attrs[Attribute.header.key]!.value;
        _currentHeading = switch (h) {
          1 => 'title',
          2 => 'heading',
          3 => 'subheading',
          _ => 'body',
        };
        debugPrint('header attr: $h');
      } else {
        _currentHeading = 'body';
        debugPrint('header attr: null');
      }
      debugPrint('currentHeading: $_currentHeading');

      // Alignment state (optional UI sync)
      // Note: Alignment state removed as it's not used in UI
    });
  }

  // Proper formatting toggles for flutter_quill 11.4.2
  void _toggleBold() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.bold.key);

    _quillController
        .formatSelection(isOn ? _unset(Attribute.bold) : Attribute.bold);
  }

  void _toggleItalic() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.italic.key);

    _quillController
        .formatSelection(isOn ? _unset(Attribute.italic) : Attribute.italic);
  }

  void _toggleUnderline() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.underline.key);

    _quillController.formatSelection(
        isOn ? _unset(Attribute.underline) : Attribute.underline);
  }

  void _toggleStrikethrough() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.strikeThrough.key);

    try {
      _quillController.formatSelection(
          isOn ? _unset(Attribute.strikeThrough) : Attribute.strikeThrough);
    } catch (e) {
      // If strikeThrough is not supported, just toggle the button state
      setState(() {
        _isStrikethrough = !_isStrikethrough;
      });
    }
  }

  // Media insertion methods
  void _insertChecklist() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // If the document is empty, ensure there's a line to host the checklist.
    if (_quillController.document.length <= 1) {
      _quillController.document.insert(0, '\n');
      _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
    }

    // Apply Quill's checklist attribute to the current selection/line.
    // Values are 'unchecked' / 'checked'. We'll start with 'unchecked'.
    _quillController.formatSelection(
      Attribute(Attribute.list.key, Attribute.list.scope, 'unchecked'),
    );

    // Optional: move caret to the end of the current line to start typing immediately.
    final newSel = _quillController.selection;
    _quillController.updateSelection(
      TextSelection.collapsed(offset: newSel.extentOffset),
      ChangeSource.local,
    );
  }

  void _setTextAlign(TextAlign alignment) {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attr = switch (alignment) {
      TextAlign.center => Attribute.centerAlignment,
      TextAlign.right => Attribute.rightAlignment,
      TextAlign.justify => Attribute.justifyAlignment,
      _ => Attribute.leftAlignment,
    };
    _quillController.formatSelection(attr);
    setState(() {
      // Alignment applied to Quill controller
    });
  }

  void _setHeading(String headingType) {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    switch (headingType) {
      case 'title':
        _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 1),
        );
        break;
      case 'heading':
        _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 2),
        );
        break;
      case 'subheading':
        _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 3),
        );
        break;
      case 'body':
      default:
        _quillController.formatSelection(_unset(Attribute.header));
    }

    setState(() => _currentHeading = headingType);
  }

  // List formatting methods
  void _toggleBulletList() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    if (current == Attribute.ul) {
      _quillController.formatSelection(_unset(Attribute.list));
    } else {
      _quillController.formatSelection(Attribute.ul);
    }
  }

  void _toggleNumberedList() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    if (current == Attribute.ol) {
      _quillController.formatSelection(_unset(Attribute.list));
    } else {
      _quillController.formatSelection(Attribute.ol);
    }
  }

  void _toggleDashList() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    if (current == Attribute.ul) {
      _quillController.formatSelection(_unset(Attribute.list));
    } else {
      _quillController.formatSelection(Attribute.ul);
    }
  }

  // Indent methods
  void _setIndentLeft() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // TODO: Implement indent left functionality
  }

  void _setIndentRight() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // TODO: Implement indent right functionality
  }

  Future<void> _saveNote() async {
    // Get plain text content from Quill
    final quillContent = _quillController.document.toPlainText().trim();

    if (quillContent.isEmpty) {
      // Don't save empty notes
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Extract title from first line of content
      final lines = quillContent.split('\n');
      final title = lines.isNotEmpty ? lines.first.trim() : 'Untitled Note';

      final note = Note.create(
        title: title.isEmpty ? 'Untitled Note' : title,
        content: quillContent,
        userId: user.id,
      );

      await _noteRepository.createNote(note);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to home screen
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            NoteEditorHeader(
              onSave: _saveNote,
              isSaving: _isSaving,
            ),

            // Date only under header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _formatDateTime(_createdAt),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

            // Main content area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Note content area - now using QuillEditor for rich text
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final themeNotifier =
                                ref.read(themeProvider.notifier);
                            final textColor = themeNotifier.isDarkMode
                                ? Colors.white
                                : Colors.black;

                            return Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.copyWith(
                                      bodyLarge: TextStyle(color: textColor),
                                      bodyMedium: TextStyle(color: textColor),
                                      bodySmall: TextStyle(color: textColor),
                                    ),
                                listTileTheme: ListTileThemeData(
                                  textColor: textColor,
                                  iconColor: textColor,
                                ),
                                // Apple Notes-style circular checkboxes
                                checkboxTheme: CheckboxThemeData(
                                  shape:
                                      const CircleBorder(), // <-- round circles
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: WidgetStateBorderSide.resolveWith(
                                      (states) {
                                    final cs = Theme.of(context).colorScheme;
                                    return BorderSide(
                                      color:
                                          states.contains(WidgetState.selected)
                                              ? cs.primary
                                              : cs.outline,
                                      width: 2,
                                    );
                                  }),
                                  fillColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    return states.contains(WidgetState.selected)
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent;
                                  }),
                                  checkColor: WidgetStateProperty.all(
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                              child: Focus(
                                onKeyEvent: _onEditorKey,
                                child: QuillEditor.basic(
                                  controller: _quillController,
                                  focusNode: _focusNode,
                                  config: QuillEditorConfig(
                                    placeholder: '',
                                    padding: EdgeInsets.zero,
                                    minHeight: 100,
                                    maxHeight: double.infinity,
                                    enableInteractiveSelection: true,
                                    embedBuilders: [
                                      TableEmbedBuilder(),
                                    ],
                                    customStyles: DefaultStyles(
                                      paragraph: DefaultTextBlockStyle(
                                        TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w400,
                                          color: textColor,
                                          height: 1.2,
                                        ),
                                        const HorizontalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        null,
                                      ),
                                      h1: DefaultTextBlockStyle(
                                        TextStyle(
                                          fontSize: 28,
                                          fontFamily: 'SF Pro Display',
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                          height: 1.1,
                                        ),
                                        const HorizontalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        null,
                                      ),
                                      h2: DefaultTextBlockStyle(
                                        TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                          height: 1.2,
                                        ),
                                        const HorizontalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        null,
                                      ),
                                      h3: DefaultTextBlockStyle(
                                        TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                          height: 1.2,
                                        ),
                                        const HorizontalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        const VerticalSpacing(0, 0),
                                        null,
                                      ),
                                      lists: DefaultListBlockStyle(
                                        TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w400,
                                          color: textColor,
                                          height: 1.2,
                                        ),
                                        const HorizontalSpacing(18, 12),
                                        const VerticalSpacing(8, 8),
                                        const VerticalSpacing(8, 8),
                                        null,
                                        null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ); // <— close Theme return
                          },
                        ), // <— close Consumer
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Toolbar at the bottom - always show for now to fix the issue
            NoteEditorToolbar(
              onFormatTap: () => CustomModals.showFormatModal(
                context,
                onBold: _toggleBold,
                onItalic: _toggleItalic,
                onUnderline: _toggleUnderline,
                onStrikethrough: _toggleStrikethrough,
                onTextAlign: _setTextAlign,
                onHeading: _setHeading,
                onBulletList: _toggleBulletList,
                onNumberedList: _toggleNumberedList,
                onDashList: _toggleDashList,
                onIndentLeft: _setIndentLeft,
                onIndentRight: _setIndentRight,
                isBold: _isBold,
                isItalic: _isItalic,
                isUnderline: _isUnderline,
                isStrikethrough: _isStrikethrough,
                currentHeading: _currentHeading,
              ),
              onChecklistTap: () => CustomModals.showChecklistModal(
                context,
                onChecklistInsert: _insertChecklist,
              ),
              onTableTap: () {
                _insertTable2x2();
                CustomModals.showTableModal(context);
              },
              onMediaTap: () => CustomModals.showMediaModal(context),
              onCarouselTap: () => CustomModals.showCarouselModal(context),
              onStackTap: () => CustomModals.showStackModal(context),
              onCloseTap: () => FocusScope.of(context).unfocus(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? 'pm' : 'am';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$month $day${_getDaySuffix(day)}, $year at $hour12:${minute.toString().padLeft(2, '0')} $ampm';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
