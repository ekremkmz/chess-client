import '../../../helper/fen_logic.dart';

import '../../../logic/cubit/game_board_logic/chess_piece/chess_piece.dart';
import '../../../logic/cubit/game_board_logic/game_board_logic_cubit.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class BoardState {
  @Id()
  int id = 0;

  late String board;

  late int turn;

  late String castleSides;

  late int halfMove;

  late int fullMove;

  String? enPassant;

  List<List<ChessPiece?>> toBoard() => charsToChessPieceList(board);

  void updateBoard(List<List<ChessPiece?>> board) =>
      this.board = chessPieceListToChars(board);

  Set<CastleSide> toCastleSideSet() =>
      castleSides.split("").map(stringToCastleSide).toSet();
}
