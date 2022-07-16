import 'package:uuid/uuid.dart';

typedef CommandResponseHandler = void Function(dynamic data);

abstract class Command {
  Command({
    this.successHandler,
    this.errorHandler,
  });

  final String commandId = const Uuid().v1();

  CommandResponseHandler? successHandler;

  CommandResponseHandler? errorHandler;

  String get commandTag;

  Map<String, dynamic> toMap();
}
