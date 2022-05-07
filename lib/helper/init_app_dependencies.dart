import '../data/local/db_manager.dart';
import '../data/rest/dio_manager.dart';
import '../data/globals.dart';
import 'package:path_provider/path_provider.dart';

import 'check_needed_permissions.dart';

Future<void> initAppDependencies() async {
  Globals.appDir = await getApplicationDocumentsDirectory();

  checkNeededPermissions();

  DioManager.init();

  await DBManager.init();
}
