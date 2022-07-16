import 'package:chess/data/local/shared_preferences.dart';

import '../data/runtime/game_requests_manager.dart';
import '../data/local/db_manager.dart';
import '../data/rest/dio_manager.dart';
import '../data/runtime/friend_status_manager.dart';
import '../data/websocket/socket_manager.dart';
import 'package:get_it/get_it.dart';

Future<void> setupServiceLocator() async {
  GetIt.I.registerSingletonAsync(() async => await DBManager().init());
  GetIt.I.registerSingletonAsync(() async => await SharedPreferences().init());
  GetIt.I.registerSingleton(DioManager().init());
  GetIt.I.registerLazySingleton(() => SocketManager());
  GetIt.I.registerLazySingleton(() => GameRequestsManager());
  GetIt.I.registerLazySingleton(() => PlayerStatusManager());

  await GetIt.I.allReady();
}
