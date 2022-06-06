// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_board_logic_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameBoardLogicGamingCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameBoardLogicGaming(...).copyWith(id: 12, name: "My name")
  /// ````
  GameBoardLogicGaming call({
    String? blackNick,
    Duration? blackTime,
    List<List<ChessPiece?>>? board,
    Set<CastleSide>? castleSide,
    ChessCoord? enPassant,
    int? fullMove,
    int? gameState,
    int? halfMove,
    List<List<bool>>? movableLocations,
    PieceColor? turn,
    String? whiteNick,
    Duration? whiteTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameBoardLogicGaming.copyWith(...)`.
class _$GameBoardLogicGamingCWProxyImpl
    implements _$GameBoardLogicGamingCWProxy {
  final GameBoardLogicGaming _value;

  const _$GameBoardLogicGamingCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameBoardLogicGaming(...).copyWith(id: 12, name: "My name")
  /// ````
  GameBoardLogicGaming call({
    Object? blackNick = const $CopyWithPlaceholder(),
    Object? blackTime = const $CopyWithPlaceholder(),
    Object? board = const $CopyWithPlaceholder(),
    Object? castleSide = const $CopyWithPlaceholder(),
    Object? enPassant = const $CopyWithPlaceholder(),
    Object? fullMove = const $CopyWithPlaceholder(),
    Object? gameState = const $CopyWithPlaceholder(),
    Object? halfMove = const $CopyWithPlaceholder(),
    Object? movableLocations = const $CopyWithPlaceholder(),
    Object? turn = const $CopyWithPlaceholder(),
    Object? whiteNick = const $CopyWithPlaceholder(),
    Object? whiteTime = const $CopyWithPlaceholder(),
  }) {
    return GameBoardLogicGaming(
      blackNick: blackNick == const $CopyWithPlaceholder()
          ? _value.blackNick
          // ignore: cast_nullable_to_non_nullable
          : blackNick as String?,
      blackTime: blackTime == const $CopyWithPlaceholder()
          ? _value.blackTime
          // ignore: cast_nullable_to_non_nullable
          : blackTime as Duration?,
      board: board == const $CopyWithPlaceholder() || board == null
          ? _value.board
          // ignore: cast_nullable_to_non_nullable
          : board as List<List<ChessPiece?>>,
      castleSide:
          castleSide == const $CopyWithPlaceholder() || castleSide == null
              ? _value.castleSide
              // ignore: cast_nullable_to_non_nullable
              : castleSide as Set<CastleSide>,
      enPassant: enPassant == const $CopyWithPlaceholder()
          ? _value.enPassant
          // ignore: cast_nullable_to_non_nullable
          : enPassant as ChessCoord?,
      fullMove: fullMove == const $CopyWithPlaceholder() || fullMove == null
          ? _value.fullMove
          // ignore: cast_nullable_to_non_nullable
          : fullMove as int,
      gameState: gameState == const $CopyWithPlaceholder() || gameState == null
          ? _value.gameState
          // ignore: cast_nullable_to_non_nullable
          : gameState as int,
      halfMove: halfMove == const $CopyWithPlaceholder() || halfMove == null
          ? _value.halfMove
          // ignore: cast_nullable_to_non_nullable
          : halfMove as int,
      movableLocations: movableLocations == const $CopyWithPlaceholder()
          ? _value.movableLocations
          // ignore: cast_nullable_to_non_nullable
          : movableLocations as List<List<bool>>?,
      turn: turn == const $CopyWithPlaceholder() || turn == null
          ? _value.turn
          // ignore: cast_nullable_to_non_nullable
          : turn as PieceColor,
      whiteNick: whiteNick == const $CopyWithPlaceholder()
          ? _value.whiteNick
          // ignore: cast_nullable_to_non_nullable
          : whiteNick as String?,
      whiteTime: whiteTime == const $CopyWithPlaceholder()
          ? _value.whiteTime
          // ignore: cast_nullable_to_non_nullable
          : whiteTime as Duration?,
    );
  }
}

extension $GameBoardLogicGamingCopyWith on GameBoardLogicGaming {
  /// Returns a callable class that can be used as follows: `instanceOfclass GameBoardLogicGaming extends GameBoardLogicState.name.copyWith(...)`.
  _$GameBoardLogicGamingCWProxy get copyWith =>
      _$GameBoardLogicGamingCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)`.
  ///
  /// Usage
  /// ```dart
  /// GameBoardLogicGaming(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  GameBoardLogicGaming copyWithNull({
    bool blackNick = false,
    bool blackTime = false,
    bool enPassant = false,
    bool movableLocations = false,
    bool whiteNick = false,
    bool whiteTime = false,
  }) {
    return GameBoardLogicGaming(
      blackNick: blackNick == true ? null : this.blackNick,
      blackTime: blackTime == true ? null : this.blackTime,
      board: board,
      castleSide: castleSide,
      enPassant: enPassant == true ? null : this.enPassant,
      fullMove: fullMove,
      gameState: gameState,
      halfMove: halfMove,
      movableLocations: movableLocations == true ? null : this.movableLocations,
      turn: turn,
      whiteNick: whiteNick == true ? null : this.whiteNick,
      whiteTime: whiteTime == true ? null : this.whiteTime,
    );
  }
}
