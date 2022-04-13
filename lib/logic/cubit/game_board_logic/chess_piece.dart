import 'game_board_logic_cubit.dart';

abstract class ChessPiece {
  ChessPiece._({
    required this.color,
    required this.coord,
  });

  final PieceColor color;

  ChessCoord coord;

  List<List<bool>> calculateMovableLocations(
      List<List<ChessPiece?>> board, ChessCoord? enPassant);

  String get name;

  void canMoveSetTrue(
    List<List<ChessPiece?>> board,
    ChessCoord cc,
    List<List<bool>> ml, {
    bool move = true,
    bool capture = true,
  }) {
    if (board[cc.row][cc.column] == null) {
      if (move) {
        ml[cc.row][cc.column] = true;
      }
    } else if (capture && board[cc.row][cc.column]!.color != color) {
      ml[cc.row][cc.column] = true;
    }
  }

  void move(ChessCoord cc) {
    coord = cc;
  }

  @override
  String toString() {
    return "${color.name}_$name";
  }
}

class RookPiece extends ChessPiece {
  RookPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super._(color: color, coord: coord);

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  ) {
    final ml = List.generate(8, (i) => List.generate(8, (i) => false));
    final list = <ChessCoord>[];

    const adders = [
      ChessCoord(row: 0, column: 1),
      ChessCoord(row: 0, column: -1),
      ChessCoord(row: 1, column: 0),
      ChessCoord(row: -1, column: 0),
    ];

    for (var adder in adders) {
      ChessCoord? lastLoc = coord;
      bool run = true;
      while (run) {
        lastLoc = lastLoc! + adder;
        if (lastLoc != null) {
          if (board[lastLoc.row][lastLoc.column] != null) {
            run = false;
          }
          list.add(lastLoc);
        } else {
          run = false;
        }
      }
    }

    for (var item in list) {
      canMoveSetTrue(board, item, ml);
    }

    return ml;
  }

  @override
  String get name => "rook";
}

class KnightPiece extends ChessPiece {
  KnightPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super._(color: color, coord: coord);

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  ) {
    final ml = List.generate(8, (i) => List.generate(8, (i) => false));
    const moves = [
      ChessCoord(row: -2, column: -1),
      ChessCoord(row: -2, column: 1),
      ChessCoord(row: 2, column: -1),
      ChessCoord(row: 2, column: 1),
      ChessCoord(row: -1, column: 2),
      ChessCoord(row: 1, column: 2),
      ChessCoord(row: -1, column: -2),
      ChessCoord(row: 1, column: -2),
    ];

    for (var move in moves) {
      final cc = coord + move;

      if (cc != null) {
        canMoveSetTrue(board, cc, ml);
      }
    }

    return ml;
  }

  @override
  String get name => "knight";
}

class BishopPiece extends ChessPiece {
  BishopPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super._(color: color, coord: coord);

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  ) {
    final ml = List.generate(8, (i) => List.generate(8, (i) => false));
    final list = <ChessCoord>[];

    const adders = [
      ChessCoord(row: 1, column: 1),
      ChessCoord(row: 1, column: -1),
      ChessCoord(row: -1, column: 1),
      ChessCoord(row: -1, column: -1),
    ];

    for (var adder in adders) {
      ChessCoord? lastLoc = coord;
      bool run = true;
      while (run) {
        lastLoc = lastLoc! + adder;
        if (lastLoc != null) {
          if (board[lastLoc.row][lastLoc.column] != null) {
            run = false;
          }
          list.add(lastLoc);
        } else {
          run = false;
        }
      }
    }

    for (var item in list) {
      canMoveSetTrue(board, item, ml);
    }
    return ml;
  }

  @override
  String get name => "bishop";
}

class QueenPiece extends ChessPiece {
  QueenPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super._(color: color, coord: coord);

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  ) {
    final ml = List.generate(8, (i) => List.generate(8, (i) => false));
    final list = <ChessCoord>[];

    const adders = [
      ChessCoord(row: 1, column: 1),
      ChessCoord(row: 1, column: 0),
      ChessCoord(row: 1, column: -1),
      ChessCoord(row: 0, column: 1),
      ChessCoord(row: 0, column: -1),
      ChessCoord(row: -1, column: 1),
      ChessCoord(row: -1, column: 0),
      ChessCoord(row: -1, column: -1),
    ];

    for (var adder in adders) {
      ChessCoord? lastLoc = coord;
      bool run = true;
      while (run) {
        lastLoc = lastLoc! + adder;
        if (lastLoc != null) {
          if (board[lastLoc.row][lastLoc.column] != null) {
            run = false;
          }
          list.add(lastLoc);
        } else {
          run = false;
        }
      }
    }

    for (var item in list) {
      canMoveSetTrue(board, item, ml);
    }
    return ml;
  }

  @override
  String get name => "queen";
}

class KingPiece extends ChessPiece {
  KingPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super._(color: color, coord: coord);

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  ) {
    final ml = List.generate(8, (i) => List.generate(8, (i) => false));
    const moves = [
      ChessCoord(row: -1, column: -1),
      ChessCoord(row: -1, column: 0),
      ChessCoord(row: -1, column: 1),
      ChessCoord(row: 0, column: -1),
      ChessCoord(row: 0, column: 0),
      ChessCoord(row: 0, column: 1),
      ChessCoord(row: 1, column: -1),
      ChessCoord(row: 1, column: 0),
      ChessCoord(row: 1, column: 1),
    ];

    for (var move in moves) {
      final cc = coord + move;

      if (cc != null) {
        canMoveSetTrue(board, cc, ml);
      }
    }

    return ml;
  }

  @override
  String get name => "king";
}

class PawnPiece extends ChessPiece {
  PawnPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super._(color: color, coord: coord);

  bool get _isFirstMove {
    if (color == PieceColor.black && coord.row == 1) return true;
    if (color == PieceColor.white && coord.row == 6) return true;
    return false;
  }

  int get _adder => color == PieceColor.black ? 1 : -1;

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  ) {
    final ml = List.generate(8, (i) => List.generate(8, (i) => false));

    // Double
    if (_isFirstMove) {
      final cc = (coord + ChessCoord(row: _adder * 2, column: 0))!;
      canMoveSetTrue(board, cc, ml, capture: false);
    }

    // Regular
    final cc = coord + ChessCoord(row: _adder, column: 0);

    if (cc != null) {
      canMoveSetTrue(board, cc, ml, capture: false);
    }

    // Take
    final cc2 = coord + ChessCoord(row: _adder, column: 1);
    final cc3 = coord + ChessCoord(row: _adder, column: -1);

    if (cc2 != null) {
      canMoveSetTrue(board, cc2, ml, move: false);
    }

    if (cc3 != null) {
      canMoveSetTrue(board, cc3, ml, move: false);
    }

    // En passant
    if (enPassant != null) {
      if (coord.row == enPassant.row &&
          (coord.column == enPassant.column + 1 ||
              coord.column == enPassant.column - 1)) {
        canMoveSetTrue(board, enPassant, ml);
      }
    }

    return ml;
  }

  @override
  String get name => "pawn";
}
