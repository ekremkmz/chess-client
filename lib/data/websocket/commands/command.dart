import 'package:uuid/uuid.dart';

typedef SuccessHandlerCallback = void Function(Map<String, dynamic>? data);

abstract class Command {
  final String commandId = const Uuid().v1();

  SuccessHandlerCallback? get successHandler;

  String get commandTag;

  Map<String, dynamic> toMap();
}
