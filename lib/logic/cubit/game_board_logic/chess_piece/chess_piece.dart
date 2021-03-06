import '../chess_coord.dart';
import '../piece_color.dart';

abstract class ChessPiece {
  ChessPiece({
    required this.color,
    required this.coord,
  });

  final PieceColor color;

  ChessCoord coord;

  List<List<bool>> calculateMovableLocations(
    List<List<ChessPiece?>> board,
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

  String get char;

  String toChar() {
    return color == PieceColor.white ? char.toUpperCase() : char;
  }

  @override
  String toString() {
    return "${color.name}_$name";
  }
}
