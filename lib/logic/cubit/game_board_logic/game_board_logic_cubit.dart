import 'package:bloc/bloc.dart';
import 'package:chess/data/websocket/commands/play_move_command.dart';
import 'package:chess/data/websocket/socket_manager.dart';
import '../../../data/local/db_manager.dart';
import '../../../data/local/models/game.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'chess_coord.dart';
import 'chess_piece/chess_piece.dart';
import 'chess_piece/king_piece.dart';

part 'game_board_logic_state.dart';
part 'game_board_logic_state.g.dart';

class GameBoardLogicCubit extends Cubit<GameBoardLogicState> {
  GameBoardLogicCubit(String gameId)
      : super(
          GameBoardLogicInitial(gameId: gameId),
        ) {
    _initGame(gameId);
  }

  late Game game;

  PieceColor? playerColor;

  void move(ChessCoord source, ChessCoord target) {
    final state = this.state as GameBoardLogicGaming;

    // Make a copy for immutability
    final board = state.board
        .map((e) => e.toList(growable: false))
        .toList(growable: false);

    board[target.row][target.column] = board[source.row][source.column];
    board[source.row][source.column] = null;
    board[target.row][target.column]!.move(target);

    emit(state.copyWith(board: board));

    SocketManager.instance.sendCommand(PlayMoveCommand(
      source: source,
      target: target,
      successHandler: (data) {
        int timeleft = data!['timeleft'];
        String nick = data['nick'];
        if (game.white.target!.nick == nick) {
          game.white.target!.timeLeft = timeleft;
          emit(state.copyWith(
            whiteTime: Duration(milliseconds: timeleft),
          ));
        } else if (game.black.target!.nick == nick) {
          game.black.target!.timeLeft = timeleft;
          emit(state.copyWith(
            blackTime: Duration(milliseconds: timeleft),
          ));
        }
        _saveGame();
      },
    ));
    _saveGame();
  }

  void showMovableLocations(ChessCoord source) {
    final state = this.state as GameBoardLogicGaming;

    final piece = state.board[source.row][source.column];

    final movableLocations =
        piece!.calculateMovableLocations(state.board, state.enPassant);

    emit(state.copyWith(movableLocations: movableLocations));
  }

  void hideMovableLocations() {
    final state = this.state as GameBoardLogicGaming;

    emit(state.copyWith(movableLocations: null));
  }

  bool canMove(ChessCoord source, ChessCoord target) {
    final state = this.state as GameBoardLogicGaming;
    // Deep copy board
    final board = state.board
        .map((e) => e.toList(growable: false))
        .toList(growable: false);

    board[target.row][target.column] = board[source.row][source.column];
    board[source.row][source.column] = null;

    // Find your king
    late ChessCoord kc;
    for (int i = 0; i < board.length; i++) {
      var row = board[i];
      for (int j = 0; j < row.length; j++) {
        var piece = row[j];
        if (piece is KingPiece && piece.color == playerColor) {
          kc = ChessCoord(row: i, column: j);
        }
      }
    }

    // Check if your king is capturable
    for (var row in board) {
      for (var piece in row) {
        if (piece != null) {
          final ml = piece.calculateMovableLocations(board, null);
          if (ml[kc.row][kc.column]) return false;
        }
      }
    }
    return true;
  }

  /*
  void newGame(Duration timeControl, Duration adder, [PieceColor? color]) {
    playerColor =
        color ?? (Random().nextBool() ? PieceColor.white : PieceColor.black);

    fromFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        timeControl, adder);
  }

  void fromFEN(String fen, Duration timeControl, Duration adder) {
    final list = fen.split(" ");

    final board = charsToChessPieceList(list[0]);

    final turn = list[1] == "b" ? PieceColor.black : PieceColor.white;

    final castleSide = charsToCastleSide(list[2]);

    final enPassant = list[3] == "-"
        ? null
        : ChessCoord(
            row: coordsToInt[list[3][0]]!,
            column: int.parse(list[3][1]),
          );

    final halfMove = int.parse(list[4]);

    final fullMove = int.parse(list[5]);

    emit(GameBoardLogicGaming(
      whiteTime: timeControl,
      blackTime: timeControl,
      board: board,
      turn: turn,
      castleSide: castleSide,
      enPassant: enPassant,
      halfMove: halfMove,
      fullMove: fullMove,
    ));
  }
  */

  void _initGame(String gameId) {
    game = DBManager.instance.getGame(gameId)!;

    emit(GameBoardLogicGaming.fromGame(game));
  }

  void _saveGame() {
    DBManager.instance.putGame(game);
  }
}
