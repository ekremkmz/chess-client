import 'dart:async';

import '../../../data/local/models/player_state.dart';
import '../../../data/websocket/commands/connect_to_game_command.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/websocket/commands/play_move_command.dart';
import '../../../data/websocket/socket_manager.dart';
import '../../../data/local/db_manager.dart';
import '../../../data/local/models/game.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

import 'chess_coord.dart';
import 'chess_piece/chess_piece.dart';
import 'chess_piece/king_piece.dart';

part 'game_board_logic_state.dart';
part 'game_board_logic_state.g.dart';

class GameBoardLogicCubit extends Cubit<GameBoardLogicState> {
  GameBoardLogicCubit({
    this.game,
    required this.gameId,
    required this.userNick,
  }) : super(GameBoardLogicInitial(gameId: gameId)) {
    _initGame(gameId);
  }

  Game? game;

  final String gameId;

  final String userNick;

  late StreamSubscription<Game?> streamSub;

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

    // Not persistent on the local DB yet
    emit(state.copyWith(board: board));

    SocketManager.instance.sendCommand(PlayMoveCommand(
      source: source,
      target: target,
      gameId: gameId,
      successHandler: playMoveHandler,
    ));
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

  // Checks if your king is a target after the move
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
    streamSub = DBManager.instance.getGameAsStream(gameId).listen((game) {
      if (game == null) return;

      // For connecting to others game
      if (playerColor == null) {
        if (game.black.target?.nick == userNick) {
          playerColor = PieceColor.black;
        } else if (game.white.target?.nick == userNick) {
          playerColor = PieceColor.white;
        }
      }

      this.game = game;

      emit(GameBoardLogicGaming.fromGame(game));
    });

    // When connecting to others game
    if (game == null) {
      SocketManager.instance.sendCommand(
        ConnectToGameCommand(
          gameId: gameId,
          successHandler: (data) {
            final game = Game.fromJson(data!);
            DBManager.instance.putGame(game);
          },
        ),
      );
      return;
    }

    if (game!.black.target?.nick == userNick) {
      playerColor = PieceColor.black;
    } else if (game!.white.target?.nick == userNick) {
      playerColor = PieceColor.white;
    }

    emit(GameBoardLogicGaming.fromGame(game!));
  }

  PlayerState? get you {
    switch (playerColor) {
      case PieceColor.white:
        return game!.white.target;
      case PieceColor.black:
        return game!.black.target;
      default:
        return null;
    }
  }

  PlayerState? get opponent {
    switch (playerColor) {
      case PieceColor.white:
        return game!.black.target;
      case PieceColor.black:
        return game!.white.target;
      default:
        return null;
    }
  }

  @override
  Future<void> close() async {
    await streamSub.cancel();
    await super.close();
  }
}
