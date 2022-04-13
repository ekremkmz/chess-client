part of 'game_board_logic_cubit.dart';

@immutable
abstract class GameBoardLogicState {
  const GameBoardLogicState();
}

class GameBoardLogicInitial extends GameBoardLogicState {}

@CopyWith(copyWithNull: true, skipFields: true)
class GameBoardLogicGaming extends GameBoardLogicState {
  const GameBoardLogicGaming({
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

  final Duration whiteTime;

  final Duration blackTime;

  final List<List<bool>>? movableLocations;
}

enum CastleSide {
  whiteKingSide,
  whiteQueenSide,
  blackKingSide,
  blackQueenSide,
}

enum PieceColor {
  white,
  black,
}

@immutable
class ChessCoord with EquatableMixin {
  const ChessCoord({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  @override
  List<Object?> get props => [row, column];

  ChessCoord? operator +(ChessCoord ch) {
    final row = this.row + ch.row;
    final column = this.column + ch.column;

    if (row > 7 || column > 7 || row < 0 || column < 0) return null;
    return ChessCoord(row: row, column: column);
  }
}
