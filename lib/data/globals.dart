import 'dart:io';

class Globals {
  Globals._();
  static String wsUrl = "ws://127.0.0.1:3000/ws";
  static String restUrl = "http://127.0.0.1:3000";
  static late Directory appDir;
  static bool isStoragePermissionGranted = false;
}
