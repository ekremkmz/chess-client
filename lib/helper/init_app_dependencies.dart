import 'setup_service_locator.dart';

import '../data/globals.dart';
import 'package:path_provider/path_provider.dart';

import 'request_needed_permissions.dart';

Future<void> initAppDependencies() async {
  Globals.appDir = await getApplicationDocumentsDirectory();
  await requestNeededPermissions();
  await setupServiceLocator();
}
