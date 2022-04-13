import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:chess/helper/fen_logic.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'chess_piece.dart';

part 'game_board_logic_state.dart';
part 'game_board_logic_state.g.dart';

class GameBoardLogicCubit extends Cubit<GameBoardLogicState> {
  GameBoardLogicCubit() : super(GameBoardLogicInitial());

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

  void newGame(Duration duration, [PieceColor? color]) {
    playerColor =
        color ?? (Random().nextBool() ? PieceColor.white : PieceColor.black);

    fromFEN("rnbqkbnr/ppp2ppp/8/3ppP2/4P3/8/PPPP2PP/RNBQKBNR w KQkq e6 0 4",
        duration);
  }

  void fromFEN(String fen, Duration duration) {
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
      whiteTime: duration,
      blackTime: duration,
      board: board,
      turn: turn,
      castleSide: castleSide,
      enPassant: enPassant,
      halfMove: halfMove,
      fullMove: fullMove,
    ));
  }
}

final Map<String, int> coordsToInt = {
  "a": 1,
  "b": 2,
  "c": 3,
  "d": 4,
  "e": 5,
  "f": 6,
  "g": 7,
  "h": 8,
};

final Map<int, String> intToCoords = {
  1: "a",
  2: "b",
  3: "c",
  4: "d",
  5: "e",
  6: "f",
  7: "g",
  8: "h",
};
