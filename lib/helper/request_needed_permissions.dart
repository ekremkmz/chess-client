import 'package:permission_handler/permission_handler.dart';

import '../data/globals.dart';

Future<void> requestNeededPermissions() async {
  final value = await Permission.storage.request();
  if (value.isGranted) {
    Globals.isStoragePermissionGranted = true;
  }
}
