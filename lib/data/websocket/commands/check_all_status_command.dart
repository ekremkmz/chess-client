import 'command.dart';

class CheckAllStatusCommand extends Command {
  CheckAllStatusCommand({
    required this.nicks,
    super.successHandler,
  });

  final List<String> nicks;

  @override
  String get commandTag => "checkAllStatus";

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "nicks": nicks,
      }
    };
  }
}
