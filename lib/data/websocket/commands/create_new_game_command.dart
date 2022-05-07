import 'command.dart';

class CreateNewGameCommand extends Command {
  CreateNewGameCommand({
    required this.time,
    required this.add,
    this.color,
    this.successHandler,
  });

  int time;
  int add;
  String? color;

  @override
  SuccessHandlerCallback? successHandler;

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "time": time.toString(),
        "add": add.toString(),
        if (color != null) "color": color,
      },
    };
  }

  @override
  String get commandTag => "createNewGame";
}
