import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart' as d;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:either_dart/either.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../errors/failure.dart';
import '../globals.dart';
import '../local/models/user.dart';

class DioManager {
  const DioManager._();

  static DioManager? _instance;
  static DioManager get instance => _instance ??= const DioManager._();

  static late d.Dio _dioInstance;

  static void init() {
    _dioInstance = d.Dio();
    _dioInstance.options.baseUrl = Globals.restUrl;
    final cookieManager = CookieManager(
      PersistCookieJar(
        storage: FileStorage('${Globals.appDir.path}/.cookies'),
      ),
    );
    _dioInstance.interceptors.add(cookieManager);
  }

  Future<Either<Failure, void>> logout() async {
    final failure = await _checkStoragePermission();

    if (failure != null) {
      return Left(failure);
    }

    return _apiErrorWrapper(() async {
      await _dioInstance.get('/auth/logout');
      return const Right(null);
    });
  }

  Future<Either<Failure, User>> login(String username, String password) async {
    final failure = await _checkStoragePermission();

    if (failure != null) {
      return Left(failure);
    }

    return _apiErrorWrapper<User>(() async {
      final response = await _dioInstance.post('/auth/login', data: {
        'nick': username,
        'password': password,
      });

      if (response.data["success"]) {
        return Right(User.fromJson(
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

  Future<Either<Failure, User>> getProfile() async {
    final failure = await _checkStoragePermission();

    if (failure != null) {
      return Left(failure);
    }

    return _apiErrorWrapper<User>(() async {
      final response = await _dioInstance.get('/profile');

      if (response.data["success"]) {
        return Right(User.fromJson(
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

Future<Either<Failure, T>> _apiErrorWrapper<T>(
  Future<Either<Failure, T>> Function() fn,
) async {
  try {
    return await fn();
  } on d.DioError catch (e) {
    if (e.type == d.DioErrorType.response) {
      return Left(Failure(
        key: FailureKey.requestFailure,
        message: e.response!.data["message"],
      ));
    }
    return const Left(Failure(
      key: FailureKey.unknown,
      message: 'Unknown error',
    ));
  } on Exception {
    return const Left(Failure(
      key: FailureKey.unknown,
      message: 'Unknown error',
    ));
  }
}
