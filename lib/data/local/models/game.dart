import 'package:objectbox/objectbox.dart';

import 'board_state.dart';
import 'player_state.dart';

@Entity()
class Game {
  Game();

  @Id()
  int id = 0;

  @Index()
  @Unique(onConflict: ConflictStrategy.replace)
  late String uid;

  final white = ToOne<PlayerState>();

  final black = ToOne<PlayerState>();

  late int time;

  late int add;

  int? lastPlayed;

  int? started;

  // Undefined: 0, WaitsOpponent: 1, WaitsFirstMove: 2, Playing: 3, Ended: 4
  int gameState = 0;

  final boardState = ToOne<BoardState>();

  factory Game.fromJson(Map<String, dynamic> data) {
    final g = Game()
      ..uid = data["gameId"]
      ..time = data["timeControl"]
      ..add = data["adder"]
      ..gameState = data["state"];

    final bs = data["boardState"];

    final b = BoardState()
      ..turn = bs["activeColor"]
      ..castleSides = List.from(bs["castlingRights"]).join()
      ..halfMove = bs["halfMove"]
      ..fullMove = bs["fullMove"]
      ..board = bs["board"];

    g.boardState.target = b;

    if (data["black"] != null) {
      g.black.target = PlayerState.fromJson(data["black"]);
    }

    if (data["white"] != null) {
      g.white.target = PlayerState.fromJson(data["white"]);
    }

    if (data["lastPlayed"] != null) {
      g.lastPlayed = data["lastPlayed"];
    }

    if (data["started"] != null) {
      g.started = data["started"];
    }

    return g;
  }
}
