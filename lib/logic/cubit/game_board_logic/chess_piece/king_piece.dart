import '../castle_side.dart';
import '../chess_coord.dart';
import 'chess_piece.dart';

class KingPiece extends ChessPiece {
  KingPiece({
    required super.color,
    required super.coord,
  });

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
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

  void calculateCastlableLocations(
    List<List<ChessPiece?>> board,
    List<List<bool>> ml,
    Set<CastleSide> castlingRights,
  ) {
    for (var element in castlingRights) {
      switch (element) {
        case CastleSide.whiteKingSide:
          if (ml[7][5] && board[7][6] == null) {
            ml[7][6] = true;
          }
          break;
        case CastleSide.whiteQueenSide:
          if (ml[7][3] && board[7][2] == null && board[7][1] == null) {
            ml[7][2] = true;
          }
          break;
        case CastleSide.blackKingSide:
          if (ml[0][5] && board[0][6] == null) {
            ml[0][6] = true;
          }
          break;
        case CastleSide.blackQueenSide:
          if (ml[0][3] && board[0][2] == null && board[0][1] == null) {
            ml[0][2] = true;
          }
          break;
      }
    }
  }

  @override
  String get char => 'k';

  @override
  String get name => "king";
}
