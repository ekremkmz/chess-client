import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../models/friend.dart';
import '../websocket/commands/check_status_command.dart';
import '../websocket/socket_manager.dart';

class PlayerStatusManager {
  PlayerStatusManager();

  Map<String, Player> _playerStatusMap = {};

  final onlineCounter = ValueNotifier(0);

  Player getPlayerStatus(String nick) {
    if (_playerStatusMap[nick] == null) {
      _playerStatusMap[nick] = Player(nick: nick, status: "offline");
      GetIt.I<SocketManager>().sendCommand(CheckStatusCommand(nick: nick));
    }
    return _playerStatusMap[nick]!;
  }

  void setPlayers(List<Player> friends) {
    // That way we are updating the status of the friends and we are letting
    // garbage collector to clear the object that are not needed if there is any
    final newFriendStatusMap = <String, Player>{};
    var counter = 0;
    for (var friend in friends) {
      final fr = _playerStatusMap[friend.nick] ??
          Player(nick: friend.nick, status: "offline");
      fr.status = friend.status;
      newFriendStatusMap[friend.nick] = fr;
      fr.status == "online" ? counter++ : null;
    }
    _playerStatusMap = newFriendStatusMap;
    onlineCounter.value = counter;
  }

  void clearData() {
    _playerStatusMap.forEach((key, value) => value.status = "offline");
    onlineCounter.value = 0;
  }
}
