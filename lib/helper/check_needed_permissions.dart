import '../data/globals.dart';
import 'package:permission_handler/permission_handler.dart';

void checkNeededPermissions() {
  Permission.storage.request().then((value) {
    if (value.isGranted) {
      Globals.isStoragePermissionGranted = true;
    }
  });
}
