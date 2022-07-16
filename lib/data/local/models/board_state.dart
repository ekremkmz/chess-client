import '../../../logic/cubit/game_board_logic/castle_side.dart';
import 'package:objectbox/objectbox.dart';

import '../../../helper/fen_logic.dart';
import '../../../logic/cubit/game_board_logic/chess_piece/chess_piece.dart';

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

  Set<CastleSide> toCastleSide() =>
      castleSides.split("").map(stringToCastleSide).toSet();

  void updateBoard(List<List<ChessPiece?>> board) =>
      this.board = chessPieceListToChars(board);

  void updateCastleSide(Set<CastleSide> castleSide) =>
      castleSides = castleSide.map(castleSideToString).join();
}
