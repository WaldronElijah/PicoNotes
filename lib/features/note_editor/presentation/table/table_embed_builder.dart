import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'table_model.dart';
import 'table_embed.dart';
import 'quill_table_widget.dart';

class TableEmbedBuilder extends EmbedBuilder {
  @override
  String get key => TableBlockEmbed.kType; // "table"

  // IMPORTANT: block-level, takes a whole line (no typing left/right)
  @override
  bool get expanded => true;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final node = embedContext.node;
    final raw = node.value.data as String;
    final model = TableModel.fromJson(jsonDecode(raw));
    return QuillTableWidget(
      controller: embedContext.controller,
      node: node,
      model: model,
      readOnly: embedContext.readOnly,
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget);
  }

  @override
  String toPlainText(Embed node) => 'Table';
}
