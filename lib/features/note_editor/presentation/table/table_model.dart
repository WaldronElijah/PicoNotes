import 'dart:math';

class TableModel {
  final String id;
  final int rows;
  final int cols;
  final List<List<String>> cells;

  TableModel({
    required this.id,
    required this.rows,
    required this.cols,
    required this.cells,
  });

  factory TableModel.initial2x2() => TableModel(
        id: _newId(),
        rows: 2,
        cols: 2,
        cells: List.generate(2, (_) => List.generate(2, (_) => '')),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'rows': rows,
        'cols': cols,
        'cells': cells,
      };

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        id: (json['id'] as String?) ?? _newId(),
        rows: json['rows'] as int,
        cols: json['cols'] as int,
        cells: (json['cells'] as List?)
                ?.map((row) => (row as List).map((e) => e as String).toList())
                .toList() ??
            List.generate(
              json['rows'] as int,
              (_) => List.generate(json['cols'] as int, (_) => ''),
            ),
      );

  String cellText(int r, int c) {
    if (r >= 0 && r < rows && c >= 0 && c < cols) {
      return cells[r][c];
    }
    return '';
  }

  TableModel copyWithCell(int r, int c, String value) {
    if (r < 0 || r >= rows || c < 0 || c >= cols) return this;
    
    final newCells = List.generate(rows, (row) {
      return List.generate(cols, (col) {
        return (row == r && col == c) ? value : cells[row][col];
      });
    });
    
    return TableModel(
      id: id,
      rows: rows,
      cols: cols,
      cells: newCells,
    );
  }

  static String _newId() {
    final r = Random();
    return '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
           '${r.nextInt(1 << 32).toRadixString(36)}';
  }
}
