import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../objectbox.g.dart';
import '../globals.dart';
import 'models/board_state.dart';
import 'models/game.dart';
import 'models/player_state.dart';

class DBManager {
  DBManager();

  Future<DBManager> init() async {
    _store = await openStore(directory: "${Globals.appDir.path}/objectbox");
    _gameBox = _store.box<Game>();
    _playerStateBox = _store.box<PlayerState>();
    _boardStateBox = _store.box<BoardState>();
    return this;
  }

  late Store _store;
  late Box<Game> _gameBox;
  late Box<PlayerState> _playerStateBox;
  late Box<BoardState> _boardStateBox;

  Game? getGame(String uid) {
    final qb = _gameBox.query(Game_.uid.equals(uid));
    return qb.build().findFirst();
  }

  int putGame(Game game) {
    return _gameBox.put(game);
  }

  int putPlayerState(PlayerState ps) {
    return _playerStateBox.put(ps);
  }

  List<int> putManyPlayerState(List<PlayerState> ps) {
    return _playerStateBox.putMany(ps);
  }

  int putBoardState(BoardState bs) {
    return _boardStateBox.put(bs);
  }

  Stream<Game?> getGameAsStream(String uid, {bool triggerImmediately = false}) {
    final qb = _gameBox.query(Game_.uid.equals(uid));
    return qb
        .watch(triggerImmediately: triggerImmediately)
        .asBroadcastStream()
        .map((event) => event.findFirst());
  }

  Stream<List<Game>> getAllGamesStream() {
    final qb = _gameBox.query()..order(Game_.id, flags: Order.descending);
    return qb
        .watch(triggerImmediately: true)
        .asBroadcastStream()
        .map((event) => event.find());
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

  Stream<int> getPlayableGamesCountStream() {
    return _gameBox
        .query(Game_.notify.equals(true))
        .watch(triggerImmediately: true)
        .asBroadcastStream()
        .map((event) => event.count());
  }
}
