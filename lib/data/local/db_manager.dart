import 'dart:io';

import 'package:chess/data/local/models/board_state.dart';
import 'package:chess/data/local/models/player_state.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import 'models/game.dart';
import '../../objectbox.g.dart';

class DBManager {
  DBManager._();

  static DBManager? _instance;

  static DBManager get instance => _instance ??= DBManager._();

  static Future<void> init() async {
    instance._store =
        await openStore(directory: "${Globals.appDir.path}/objectbox");
    instance._gameBox = instance._store.box<Game>();
    instance._playerStateBox = instance._store.box<PlayerState>();
    instance._boardStateBox = instance._store.box<BoardState>();
  }

  late Store _store;
  late Box<Game> _gameBox;
  late Box<PlayerState> _playerStateBox;
  late Box<BoardState> _boardStateBox;

  Game? getGame(String uid) {
    final qb = _gameBox.query(Game_.uid.equals(uid));
    return qb.build().findFirst();
  }

  void putGame(Game game) {
    _gameBox.put(game);
  }

  void putPlayerState(PlayerState ps) {
    _playerStateBox.put(ps);
  }

  void putBoardState(BoardState bs) {
    _boardStateBox.put(bs);
  }

  Stream<Game?> getGameAsStream(String uid, {bool triggerImmediately = false}) {
    final qb = _gameBox.query(Game_.uid.equals(uid));
    return qb
        .watch(triggerImmediately: triggerImmediately)
        .asBroadcastStream()
        .asyncMap((event) => event.findFirst());
  }

  Stream<List<Game>> getAllGamesStream() {
    return _gameBox
        .query()
        .watch(triggerImmediately: true)
        .asBroadcastStream()
        .asyncMap<List<Game>>((event) => event.find());
  }

  void clearDatabase() {
    Directory(_store.directoryPath).delete(recursive: true).then((value) {
      debugPrint("Deleted all database");
    });
  }

  bool deleteGame(int id) {
    return _gameBox.remove(id);
  }

  List<Game> getAllNotEndedGames() {
    return _gameBox.query(Game_.gameState.lessThan(4)).build().find();
  }
}
