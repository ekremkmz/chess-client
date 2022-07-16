import 'package:chess/data/runtime/user_manager.dart';
import 'package:get_it/get_it.dart';
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

  int? createdAt;

  /// Undefined: 0, WaitsOpponent: 1, WaitsFirstMove: 2, Playing: 3, Ended: 4
  int gameState = 0;

  bool notify = false;

  /// White: 0, Black: 1, Observer: 2
  late int playerColor;

  /// Special messages on game
  /// ["checkmate","stealmate","check","x resigned","cancelled","draw", null]
  String? special;

  /// White: 0, Black: 1, Draw: 2
  int? winner;

  /// Player nick name
  String? drawRequestFrom;

  final boardState = ToOne<BoardState>();

  factory Game.fromJson(Map<String, dynamic> data) {
    final g = Game()
      ..uid = data["gameId"]
      ..time = data["timeControl"]
      ..add = data["adder"]
      ..gameState = data["state"]
      ..notify = true;

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

    if (data["createdAt"] != null) {
      g.createdAt = data["createdAt"];
    }

    // yeaaah this is bad :/
    final userNick = GetIt.I<UserManager>().nick;
    if (g.black.target?.nick == userNick) {
      g.playerColor = 1;
    } else if (g.white.target?.nick == userNick) {
      g.playerColor = 0;
    } else {
      g.playerColor = 2;
    }

    return g;
  }
}
