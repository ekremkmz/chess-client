import '../logic/cubit/game_board_logic/piece_color.dart';
import '../logic/cubit/game_board_logic/castle_side.dart';
import '../logic/cubit/game_board_logic/chess_coord.dart';
import '../logic/cubit/game_board_logic/chess_piece/bishop_piece.dart';
import '../logic/cubit/game_board_logic/chess_piece/chess_piece.dart';
import '../logic/cubit/game_board_logic/chess_piece/king_piece.dart';
import '../logic/cubit/game_board_logic/chess_piece/knight_piece.dart';
import '../logic/cubit/game_board_logic/chess_piece/pawn_piece.dart';
import '../logic/cubit/game_board_logic/chess_piece/queen_piece.dart';
import '../logic/cubit/game_board_logic/chess_piece/rook_piece.dart';

Set<CastleSide> charsToCastleSide(String str) {
  return str.split("").map(stringToCastleSide).toSet();
}

List<List<ChessPiece?>> charsToChessPieceList(String chars) {
  final data = chars.split("/");
  final lists = <List<ChessPiece?>>[];

  for (var row = 0; row < data.length; row++) {
    final selectedRow = data[row];

    final list = <ChessPiece?>[];

    for (int column = 0; column < selectedRow.length; column++) {
      final number = int.tryParse(selectedRow[column]);

      if (number == null) {
        final char = selectedRow[column];
        final coord = ChessCoord(row: row, column: list.length);
        final color =
            char == char.toUpperCase() ? PieceColor.white : PieceColor.black;

        switch (char.toUpperCase()) {
          case "R":
            list.add(RookPiece(
              color: color,
              coord: coord,
            ));
            break;
          case "N":
            list.add(KnightPiece(
              color: color,
              coord: coord,
            ));
            break;
          case "B":
            list.add(BishopPiece(
              color: color,
              coord: coord,
            ));
            break;
          case "Q":
            list.add(QueenPiece(
              color: color,
              coord: coord,
            ));
            break;
          case "K":
            list.add(KingPiece(
              color: color,
              coord: coord,
            ));
            break;
          case "P":
          default:
            list.add(PawnPiece(
              color: color,
              coord: coord,
            ));
            break;
        }
      } else {
        list.addAll(List.filled(number, null));
      }
    }
    lists.add(list);
  }
  return lists;
}

String chessPieceListToChars(List<List<ChessPiece?>> lists) {
  final chars = <String>[];

  for (var list in lists) {
    final selectedRow = <String>[];

    var nullCounter = 0;

    for (var chessPiece in list) {
      if (chessPiece != null) {
        if (nullCounter != 0) {
          selectedRow.add("$nullCounter");
          nullCounter = 0;
        }
        selectedRow.add(chessPiece.toChar());
      } else {
        nullCounter++;
      }
    }

    if (nullCounter != 0) {
      selectedRow.add("$nullCounter");
      nullCounter = 0;
    }

    chars.add(selectedRow.join(""));
  }
  return chars.join("/");
}
