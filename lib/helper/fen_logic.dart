import 'package:chess/logic/cubit/game_board_logic/chess_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/game_board_logic_cubit.dart';

Set<CastleSide> charsToCastleSide(String str) {
  final castleSide = <CastleSide>{};

  if (str.contains("Q")) {
    castleSide.add(CastleSide.whiteQueenSide);
  }
  if (str.contains("K")) {
    castleSide.add(CastleSide.whiteKingSide);
  }
  if (str.contains("q")) {
    castleSide.add(CastleSide.blackQueenSide);
  }
  if (str.contains("k")) {
    castleSide.add(CastleSide.blackKingSide);
  }
  return castleSide;
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
        final coord = ChessCoord(row: row, column: list.length);

        switch (selectedRow[column]) {
          case "r":
            list.add(RookPiece(
              color: PieceColor.black,
              coord: coord,
            ));
            break;
          case "n":
            list.add(KnightPiece(
              color: PieceColor.black,
              coord: coord,
            ));
            break;
          case "b":
            list.add(BishopPiece(
              color: PieceColor.black,
              coord: coord,
            ));
            break;
          case "q":
            list.add(QueenPiece(
              color: PieceColor.black,
              coord: coord,
            ));
            break;
          case "k":
            list.add(KingPiece(
              color: PieceColor.black,
              coord: coord,
            ));
            break;
          case "p":
            list.add(PawnPiece(
              color: PieceColor.black,
              coord: coord,
            ));
            break;
          case "R":
            list.add(RookPiece(
              color: PieceColor.white,
              coord: coord,
            ));
            break;
          case "N":
            list.add(KnightPiece(
              color: PieceColor.white,
              coord: coord,
            ));
            break;
          case "B":
            list.add(BishopPiece(
              color: PieceColor.white,
              coord: coord,
            ));
            break;
          case "Q":
            list.add(QueenPiece(
              color: PieceColor.white,
              coord: coord,
            ));
            break;
          case "K":
            list.add(KingPiece(
              color: PieceColor.white,
              coord: coord,
            ));
            break;
          case "P":
          default:
            list.add(PawnPiece(
              color: PieceColor.white,
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
