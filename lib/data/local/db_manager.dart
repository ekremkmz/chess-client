import 'dart:io';

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
  }

  late Store _store;
  late Box<Game> _gameBox;

  Game? getGame(String uid) {
    final qb = _gameBox.query(Game_.uid.equals(uid));
    return qb.build().findFirst();
  }

  void putGame(Game game) {
    _gameBox.put(game);
  }

  Stream<Game> getGameAsStream(String uid) {
    final qb = _gameBox.query(Game_.uid.equals(uid));
    return qb
        .watch(triggerImmediately: true)
        .asBroadcastStream()
        .asyncMap((event) => event.findFirst()!);
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
}
