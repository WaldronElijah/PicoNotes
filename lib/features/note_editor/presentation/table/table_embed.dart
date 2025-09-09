import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'table_model.dart';

class TableBlockEmbed extends CustomBlockEmbed {
  static const String kType = 'table';
  const TableBlockEmbed(String data) : super(kType, data);

  static TableBlockEmbed fromModel(TableModel m) =>
      TableBlockEmbed(jsonEncode(m.toJson()));

  static TableBlockEmbed initial2x2() =>
      fromModel(TableModel.initial2x2());
}
