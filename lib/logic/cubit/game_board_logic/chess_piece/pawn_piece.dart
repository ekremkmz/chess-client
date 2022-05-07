import '../chess_coord.dart';
import '../game_board_logic_cubit.dart';
import 'chess_piece.dart';

class PawnPiece extends ChessPiece {
  PawnPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super(color: color, coord: coord);

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
