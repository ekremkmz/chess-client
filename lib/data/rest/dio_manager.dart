import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart' as d;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:either_dart/either.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../errors/failure.dart';
import '../globals.dart';
import '../runtime/user_manager.dart';
import 'api_error_wrapper.dart';

class DioManager {
  DioManager();

  late d.Dio _dioInstance;

  DioManager init() {
    _dioInstance = d.Dio();
    _dioInstance.options.baseUrl = Globals.restUrl;
    final cookieManager = CookieManager(
      PersistCookieJar(
        storage: FileStorage('${Globals.appDir.path}/.cookies'),
      ),
    );
    _dioInstance.interceptors.add(cookieManager);
    return this;
  }

  Future<Either<Failure, void>> logout() async {
    final failure = await _checkStoragePermission();

    if (failure != null) {
      return Left(failure);
    }

    return apiErrorWrapper(() async {
      await _dioInstance.get('/auth/logout');
      return const Right(null);
    });
  }

  Future<Either<Failure, UserManager>> login(
      String username, String password) async {
    final failure = await _checkStoragePermission();

    if (failure != null) {
      return Left(failure);
    }

    return apiErrorWrapper<UserManager>(() async {
      final response = await _dioInstance.post('/auth/login', data: {
        'nick': username,
        'password': password,
      });

      if (response.data["success"]) {
        return Right(UserManager.fromJson(
          response.data["data"],
        ));
      } else {
        return Left(Failure(
          key: FailureKey.requestFailure,
          message: response.data["message"],
        ));
      }
    });
  }

  Future<Either<Failure, UserManager>> getProfile() async {
    final failure = await _checkStoragePermission();

    if (failure != null) {
      return Left(failure);
    }

    return apiErrorWrapper<UserManager>(() async {
      final response = await _dioInstance.get('/profile');

      if (response.data["success"]) {
        return Right(UserManager.fromJson(
          response.data["data"],
        ));
      } else {
        return Left(Failure(
          key: FailureKey.requestFailure,
          message: response.data["message"],
        ));
      }
    });
  }
}

Future<Failure?> _checkStoragePermission() async {
  if (!Globals.isStoragePermissionGranted) {
    final value = await Permission.storage.request();
    if (value.isGranted) {
      Globals.isStoragePermissionGranted = true;
    } else if (value.isDenied || value.isPermanentlyDenied) {
      return const Failure(
        key: FailureKey.storagePermissionDenied,
        message: 'Storage permission denied',
      );
    }
  }
  return null;
}
