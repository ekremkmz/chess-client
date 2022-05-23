part of 'game_board_logic_cubit.dart';

@immutable
abstract class GameBoardLogicState {
  const GameBoardLogicState();
}

class GameBoardLogicInitial extends GameBoardLogicState {
  const GameBoardLogicInitial({required this.gameId}) : super();
  final String gameId;
}

@CopyWith(copyWithNull: true, skipFields: true)
class GameBoardLogicGaming extends GameBoardLogicState {
  const GameBoardLogicGaming({
    required this.whiteNick,
    required this.blackNick,
    required this.whiteTime,
    required this.blackTime,
    required this.board,
    required this.turn,
    required this.castleSide,
    required this.enPassant,
    required this.halfMove,
    required this.fullMove,
    this.movableLocations,
  });

  final List<List<ChessPiece?>> board;

  final PieceColor turn;

  final Set<CastleSide> castleSide;

  final ChessCoord? enPassant;

  final int halfMove;

  final int fullMove;

  final String? whiteNick;

  final Duration? whiteTime;

  final String? blackNick;

  final Duration? blackTime;

  final List<List<bool>>? movableLocations;

  factory GameBoardLogicGaming.fromGame(Game game) {
    final bs = game.boardState.target!;
    final white = game.white.target;
    final black = game.black.target;

    return GameBoardLogicGaming(
      whiteTime: white == null ? null : Duration(milliseconds: white.timeLeft),
      blackTime: black == null ? null : Duration(milliseconds: black.timeLeft),
      board: bs.toBoard(),
      turn: bs.turn == 0 ? PieceColor.white : PieceColor.black,
      castleSide: bs.toCastleSideSet(),
      enPassant:
          bs.enPassant == null ? null : ChessCoord.fromString(bs.enPassant!),
      halfMove: 0,
      fullMove: 0,
      whiteNick: white?.nick,
      blackNick: black?.nick,
    );
  }
}

enum CastleSide {
  whiteKingSide,
  whiteQueenSide,
  blackKingSide,
  blackQueenSide,
}

CastleSide stringToCastleSide(String castleSide) {
  switch (castleSide) {
    case "K":
      return CastleSide.whiteKingSide;
    case "Q":
      return CastleSide.whiteQueenSide;
    case "k":
      return CastleSide.blackKingSide;
    case "q":
      return CastleSide.blackQueenSide;
    default:
      throw ArgumentError("Invalid castle side: $castleSide");
  }
}

enum PieceColor {
  white,
  black,
}
