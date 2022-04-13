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
    Duration? blackTime,
    List<List<ChessPiece?>>? board,
    Set<CastleSide>? castleSide,
    ChessCoord? enPassant,
    int? fullMove,
    int? halfMove,
    List<List<bool>>? movableLocations,
    PieceColor? turn,
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
    Object? blackTime = const $CopyWithPlaceholder(),
    Object? board = const $CopyWithPlaceholder(),
    Object? castleSide = const $CopyWithPlaceholder(),
    Object? enPassant = const $CopyWithPlaceholder(),
    Object? fullMove = const $CopyWithPlaceholder(),
    Object? halfMove = const $CopyWithPlaceholder(),
    Object? movableLocations = const $CopyWithPlaceholder(),
    Object? turn = const $CopyWithPlaceholder(),
    Object? whiteTime = const $CopyWithPlaceholder(),
  }) {
    return GameBoardLogicGaming(
      blackTime: blackTime == const $CopyWithPlaceholder() || blackTime == null
          ? _value.blackTime
          // ignore: cast_nullable_to_non_nullable
          : blackTime as Duration,
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
      whiteTime: whiteTime == const $CopyWithPlaceholder() || whiteTime == null
          ? _value.whiteTime
          // ignore: cast_nullable_to_non_nullable
          : whiteTime as Duration,
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
    bool enPassant = false,
    bool movableLocations = false,
  }) {
    return GameBoardLogicGaming(
      blackTime: blackTime,
      board: board,
      castleSide: castleSide,
      enPassant: enPassant == true ? null : this.enPassant,
      fullMove: fullMove,
      halfMove: halfMove,
      movableLocations: movableLocations == true ? null : this.movableLocations,
      turn: turn,
      whiteTime: whiteTime,
    );
  }
}
