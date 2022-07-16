import 'package:flutter/material.dart';

import '../../models/game_request.dart';

class GameRequestsManager {
  GameRequestsManager();

  final gameRequests = ValueNotifier(<GameRequest>[]);

  void addGameRequest(GameRequest request) {
    final value = gameRequests.value;
    gameRequests.value = List.from(value)..add(request);
  }
}
