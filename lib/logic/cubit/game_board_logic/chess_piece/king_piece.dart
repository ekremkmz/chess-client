import '../chess_coord.dart';
import '../game_board_logic_cubit.dart';
import 'chess_piece.dart';

class KingPiece extends ChessPiece {
  KingPiece({
    required PieceColor color,
    required ChessCoord coord,
  }) : super(color: color, coord: coord);

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
  String get char => 'k';

  @override
  String get name => "king";
}
