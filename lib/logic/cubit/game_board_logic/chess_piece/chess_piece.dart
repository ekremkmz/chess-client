import '../chess_coord.dart';
import '../game_board_logic_cubit.dart';

abstract class ChessPiece {
  ChessPiece({
    required this.color,
    required this.coord,
  });

  final PieceColor color;

  ChessCoord coord;

  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
    ChessCoord? enPassant,
  );

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
