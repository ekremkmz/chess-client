import 'package:objectbox/objectbox.dart';

@Entity()
class PlayerState {
  PlayerState();
  @Id()
  int id = 0;

  @Unique(onConflict: ConflictStrategy.replace)
  late String nick;

  // Milliseconds
  late int timeLeft;

  factory PlayerState.fromJson(data) {
    final p = PlayerState()
      ..nick = data["nick"]
      ..timeLeft = data["timeLeft"];
    return p;
  }
}
