import '../chess_coord.dart';
import '../piece_color.dart';
import 'chess_piece.dart';

class PawnPiece extends ChessPiece {
  PawnPiece({
    required super.color,
    required super.coord,
  });

  bool get _isFirstMove {
    if (color == PieceColor.black && coord.row == 1) return true;
    if (color == PieceColor.white && coord.row == 6) return true;
    return false;
  }

  int get _adder => color == PieceColor.black ? 1 : -1;

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
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

    return ml;
  }

  void calculateEnPassantLocations(
    List<List<bool>> movableLocations,
    ChessCoord? enPassant,
  ) {
    if (enPassant == null) return;

    final cc2 = coord + ChessCoord(row: _adder, column: 1);
    final cc3 = coord + ChessCoord(row: _adder, column: -1);

    for (var cc in [cc2, cc3]) {
      if (cc != null && cc == enPassant) {
        movableLocations[cc.row][cc.column] = true;
      }
    }
  }

  @override
  String get char => 'p';

  @override
  String get name => "pawn";
}
