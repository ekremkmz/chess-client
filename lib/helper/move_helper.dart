import 'package:chess/logic/cubit/game_board_logic/castle_side.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_coord.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/bishop_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/chess_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/king_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/knight_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/pawn_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/queen_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/rook_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/piece_color.dart';

class MoveLogic {
  MoveLogic({
    this.promote,
    this.enPassant,
    required this.board,
    required this.target,
    required this.source,
    required this.castlingRights,
    required this.playerColor,
  });

  String? promote;
  ChessCoord? enPassant;
  List<List<ChessPiece?>> board;
  ChessCoord target;
  ChessCoord source;
  Set<CastleSide> castlingRights;
  PieceColor playerColor;

  void makeMove({bool simulate = false}) {
    final piece = board[source.row][source.column]!;
    final targetPiece = board[target.row][target.column];

    final isMoveEnPassant =
        enPassant != null && piece is PawnPiece && target == enPassant;

    CastleSide? castleSide;
    if (piece is KingPiece) {
      for (var cs in castlingRights) {
        if (cs.kingCoord == target) {
          castleSide = cs;
        }
      }
    }
    final isMoveCastling = castleSide != null;

    // Make move
    if (isMoveEnPassant) {
      _handleEnPassantMove();
    } else if (isMoveCastling) {
      _handleCastlingMove(castleSide);
    } else {
      _handleMove(target, source);
    }
    // End of move

    // If it's only for simulating the move we don't need other calculations
    if (simulate) return;

    enPassant = null;

    // Consequences of move
    final isPawnMove = piece is PawnPiece;
    final isSourceOrTargetRook = piece is RookPiece || targetPiece is RookPiece;
    if (isMoveCastling) {
      _castlingConsequences(piece);
    } else if (castlingRights.isNotEmpty && isSourceOrTargetRook) {
      _rookInteractionConsequences();
    } else if (isPawnMove) {
      _checkPossibleEnPassant();
      _checkPossiblePromote();
    }
  }

  void _checkPossiblePromote() {
    if ([0, 7].contains(target.row)) {
      final piece = board[target.row][target.column]!;
      switch (promote!) {
        case "r":
          board[target.row][target.column] = RookPiece(
            color: piece.color,
            coord: piece.coord,
          );
          break;
        case "b":
          board[target.row][target.column] = BishopPiece(
            color: piece.color,
            coord: piece.coord,
          );
          break;
        case "n":
          board[target.row][target.column] = KnightPiece(
            color: piece.color,
            coord: piece.coord,
          );
          break;
        case "q":
        default:
          board[target.row][target.column] = QueenPiece(
            color: piece.color,
            coord: piece.coord,
          );
          break;
      }
    }
  }

  void _checkPossibleEnPassant() {
    final rowDelta = source.row - target.row;
    if ([-2, 2].contains(rowDelta)) {
      enPassant = target + ChessCoord(row: rowDelta ~/ 2, column: 0);
    }
  }

  void _rookInteractionConsequences() {
    // If a rook is moving or captured, related castling right is
    // gonna be removed
    CastleSide? castleSide;
    for (var cs in castlingRights) {
      if ([source, target].contains(cs.rookCoord)) {
        castleSide = cs;
      }
    }
    if (castleSide != null) {
      castlingRights.remove(castleSide);
    }
  }

  void _castlingConsequences(ChessPiece piece) {
    // Removes castling rights for its color
    final willRemove = piece.color == PieceColor.white
        ? [CastleSide.whiteKingSide, CastleSide.whiteQueenSide]
        : [CastleSide.blackKingSide, CastleSide.blackQueenSide];
    castlingRights.removeAll(willRemove);
  }

  void _handleMove(ChessCoord target, ChessCoord source) {
    board[target.row][target.column] = board[source.row][source.column];
    board[source.row][source.column] = null;
    board[target.row][target.column]!.move(target);
  }

  void _handleCastlingMove(CastleSide castleSide) {
    // Move the king
    _handleMove(target, source);

    // Move the rook
    final rC = castleSide.rookCoord;
    final rACC = castleSide.rookAfterCastlingCoord;
    _handleMove(rACC, rC);
  }

  void _handleEnPassantMove() {
    final adder = playerColor == PieceColor.white ? 1 : -1;
    final pawnLocation = (enPassant! + ChessCoord(row: adder, column: 0))!;

    _handleMove(target, source);
    board[pawnLocation.row][pawnLocation.column] = null;
  }
}
