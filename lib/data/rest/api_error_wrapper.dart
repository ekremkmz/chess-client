import '../../errors/failure.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

Future<Either<Failure, T>> apiErrorWrapper<T>(
  Future<Either<Failure, T>> Function() fn,
) async {
  try {
    return await fn();
  } on DioError catch (e) {
    if (e.type == DioErrorType.response) {
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
