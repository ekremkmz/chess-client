import 'command.dart';

class CheckStatusCommand extends Command {
  CheckStatusCommand({
    required this.nick,
    super.successHandler,
  });

  final String nick;

  @override
  String get commandTag => "checkStatus";

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "nick": nick,
      }
    };
  }
}
