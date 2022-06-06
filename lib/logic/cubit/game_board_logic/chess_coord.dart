import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ChessCoord with EquatableMixin {
  const ChessCoord({
    required this.row,
    required this.column,
  });

  factory ChessCoord.fromString(String str) => ChessCoord(
        column: coordsToInt[str[0]]! - 1,
        row: 8 - int.parse(str[1]),
      );

  // [0 - 7]
  final int row;
  final int column;

  @override
  List<Object?> get props => [row, column];

  ChessCoord? operator +(ChessCoord ch) {
    final row = this.row + ch.row;
    final column = this.column + ch.column;

    if (row > 7 || column > 7 || row < 0 || column < 0) return null;
    return ChessCoord(row: row, column: column);
  }

  @override
  String toString() => intToCoords[column + 1]! + (8 - row).toString();
}

final Map<String, int> coordsToInt = {
  "a": 1,
  "b": 2,
  "c": 3,
  "d": 4,
  "e": 5,
  "f": 6,
  "g": 7,
  "h": 8,
};

final Map<int, String> intToCoords = {
  1: "a",
  2: "b",
  3: "c",
  4: "d",
  5: "e",
  6: "f",
  7: "g",
  8: "h",
};
