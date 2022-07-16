import 'dart:async';

import 'package:chess/data/websocket/commands/send_response_to_draw_offer.dart';
import 'package:chess/data/websocket/commands/offer_draw_command.dart';
import 'package:chess/data/websocket/commands/resign_command.dart';
import 'package:chess/helper/fen_logic.dart';
import 'package:chess/helper/move_helper.dart';
import 'package:get_it/get_it.dart';

import '../../../data/local/models/player_state.dart';
import '../../../data/websocket/commands/connect_to_game_command.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/websocket/commands/play_move_command.dart';
import '../../../data/websocket/socket_manager.dart';
import '../../../data/local/db_manager.dart';
import '../../../data/local/models/game.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

import 'castle_side.dart';
import 'chess_coord.dart';
import 'chess_piece/chess_piece.dart';
import 'chess_piece/king_piece.dart';
import 'chess_piece/pawn_piece.dart';
import 'piece_color.dart';

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

  void move(ChessCoord source, ChessCoord target, String? promote) {
    final state = this.state as GameBoardLogicGaming;

    final board = state.board;
    final castlingRights = state.castleSide;
    final enPassant = state.enPassant;

    final move = MoveLogic(
      promote: promote,
      enPassant: enPassant,
      board: board,
      target: target,
      source: source,
      castlingRights: castlingRights,
      playerColor: playerColor!,
    )..makeMove(simulate: true);

    // Not persistent on the local DB yet just visual. The consequences
    // of this move are going to be set on the success handler
    emit(state.copyWith(board: move.board));

    GetIt.I<SocketManager>().sendCommand(PlayMoveCommand(
      promote: promote,
      source: source,
      target: target,
      gameId: gameId,
      successHandler: playMoveHandler,
    ));
  }

  void showMovableLocations(ChessCoord source) {
    final state = this.state as GameBoardLogicGaming;

    final piece = state.board[source.row][source.column];

    final movableLocations = piece!.calculateMovableLocations(state.board);
    if (piece is KingPiece) {
      piece.calculateCastlableLocations(
        state.board,
        movableLocations,
        state.castleSide,
      );
    } else if (piece is PawnPiece) {
      piece.calculateEnPassantLocations(
        movableLocations,
        state.enPassant,
      );
    }

    emit(state.copyWith(movableLocations: movableLocations));
  }

  void hideMovableLocations() {
    final state = this.state as GameBoardLogicGaming;

    emit(state.copyWith(movableLocations: null));
  }

  void offerDraw() {
    GetIt.I<SocketManager>().sendCommand(DrawOfferCommand(
      gameId: gameId,
      successHandler: drawOfferHandler,
    ));
  }

  void acceptDrawOffer() {
    GetIt.I<SocketManager>().sendCommand(SendResponseToDrawOfferCommand(
      gameId: gameId,
      response: true,
      successHandler: sendResponseToDrawOfferHandler,
    ));
  }

  void declineDrawOffer() {
    GetIt.I<SocketManager>().sendCommand(SendResponseToDrawOfferCommand(
      gameId: gameId,
      response: false,
      successHandler: sendResponseToDrawOfferHandler,
    ));
  }

  void resign() {
    GetIt.I<SocketManager>().sendCommand(ResignCommand(
      gameId: gameId,
      successHandler: resignHandler,
    ));
  }

  // Checks if your king is a target after the move
  bool canMove(ChessCoord source, ChessCoord target) {
    final state = this.state as GameBoardLogicGaming;

    // Deep copying because we dont want to make modification on state
    final board = charsToChessPieceList(chessPieceListToChars(state.board));
    final castlingRights = state.castleSide.toSet();
    final enPassant = state.enPassant;

    MoveLogic(
      enPassant: enPassant,
      board: board,
      target: target,
      source: source,
      castlingRights: castlingRights,
      playerColor: playerColor!,
    ).makeMove(simulate: true);

    // Find your king
    late ChessCoord kc;
    for (int i = 0; i < board.length; i++) {
      var row = board[i];
      for (int j = 0; j < row.length; j++) {
        var piece = row[j];
        if (piece is KingPiece && piece.color == playerColor) {
          kc = piece.coord;
        }
      }
    }

    // Check if your king is capturable
    for (var row in board) {
      for (var piece in row) {
        if (piece != null && piece.color != playerColor) {
          final ml = piece.calculateMovableLocations(board);
          if (ml[kc.row][kc.column]) return false;
        }
      }
    }
    return true;
  }

  void _initGame(String gameId) {
    streamSub = GetIt.I<DBManager>().getGameAsStream(gameId).listen((game) {
      if (game == null) return;

      playerColor ??=
          game.playerColor == 0 ? PieceColor.white : PieceColor.black;

      this.game = game;

      emit(GameBoardLogicGaming.fromGame(game));
    });

    // When connecting to others game
    if (game == null) {
      GetIt.I<SocketManager>().sendCommand(
        ConnectToGameCommand(
          gameId: gameId,
          successHandler: (data) {
            final game = Game.fromJson(data!);
            GetIt.I<DBManager>().putGame(game);
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
    if (game != null) {
      game!.notify = false;
      GetIt.I<DBManager>().putGame(game!);
    }
    await streamSub.cancel();
    await super.close();
  }
}
