import 'package:objectbox/objectbox.dart';

@Entity()
class PlayerState {
  PlayerState();
  @Id()
  int id = 0;

  late String nick;

  /// Milliseconds
  late int timeLeft;

  factory PlayerState.fromJson(data) {
    final p = PlayerState()
      ..nick = data["nick"]
      ..timeLeft = data["timeleft"];
    return p;
  }
}
