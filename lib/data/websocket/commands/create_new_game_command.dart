import 'command.dart';

class CreateNewGameCommand extends Command {
  CreateNewGameCommand({
    required this.time,
    required this.add,
    this.color,
    this.friend,
    super.successHandler,
  });

  int time;
  int add;
  String? color;
  String? friend;

  @override
  String get commandTag => "createNewGame";

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "time": time,
        "add": add,
        if (color != null) "color": color,
        if (friend != null) "friend": friend,
      },
    };
  }
}
