import '../data/globals.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkNeededPermissions() async {
  final value = await Permission.storage.request();
  if (value.isGranted) {
    Globals.isStoragePermissionGranted = true;
  }
}
