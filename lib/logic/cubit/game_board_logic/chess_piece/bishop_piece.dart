import '../chess_coord.dart';
import 'chess_piece.dart';

class BishopPiece extends ChessPiece {
  BishopPiece({
    required super.color,
    required super.coord,
  });

  @override
  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
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

  @override
  String get char => 'b';
}
