import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  Player._();
  late String nick;
  late String _status;

  set status(String status) {
    _status = status;
    notifyListeners();
  }

  String get status => _status;

  factory Player({
    required nick,
    required status,
  }) {
    return Player._()
      ..nick = nick
      .._status = status;
  }
}
