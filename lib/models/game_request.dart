class GameRequest {
  GameRequest._({
    required this.gameId,
    required this.senderCommandId,
    required this.nick,
    required this.color,
    required this.time,
    required this.add,
  });

  final String gameId;
  final String senderCommandId;
  final String nick;
  final String color;
  final int time;
  final int add;

  factory GameRequest.fromJson(Map<String, dynamic> json) {
    return GameRequest._(
      gameId: json["gameId"],
      senderCommandId: json["senderCommandId"],
      nick: json["nick"],
      color: json["color"],
      time: json["time"],
      add: json["add"],
    );
  }
}
