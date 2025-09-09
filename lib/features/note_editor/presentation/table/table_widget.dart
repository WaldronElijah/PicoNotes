import 'package:flutter/material.dart';
import 'table_model.dart';
import 'table_delete_bus.dart';

class QuillTableFrame extends StatelessWidget {
  final TableModel model;
  const QuillTableFrame({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withValues(alpha: 0.16);

    // ~5-character cell width using body text assumptions
    const padX = 12.0, padY = 10.0, rowH = 44.0;
    const minCellW = 5 * 9.0 + padX * 2; // ~9px per char ≈ iOS body text

    final table = Table(
      border: TableBorder(
        top: BorderSide(color: outline, width: 1),
        bottom: BorderSide(color: outline, width: 1),
        left: BorderSide(color: outline, width: 1),
        right: BorderSide(color: outline, width: 1),
        horizontalInside: BorderSide(color: outline, width: 1),
        verticalInside: BorderSide(color: outline, width: 1),
      ),
      columnWidths: {
        for (int c = 0; c < model.cols; c++) c: FixedColumnWidth(minCellW),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(model.rows, (_) {
        return TableRow(
          children: List.generate(model.cols, (_) {
            return SizedBox(height: rowH, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: padX, vertical: padY),
              child: const SizedBox.shrink(), // content later
            ));
          }),
        );
      }),
    );

    return ValueListenableBuilder<String?>(
      valueListenable: TableDeleteBus.armedId,
      builder: (_, armedId, __) {
        final armed = armedId == model.id;
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
            child: table,
          ),
        );
      },
    );
  }
}
