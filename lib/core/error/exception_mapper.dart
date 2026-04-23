import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(AppException e) => switch (e) {
      AssetException() => Failure(type: ErrorType.asset, message: e.message),
      ParseException() => Failure(type: ErrorType.parse, message: e.message),
      _ => Failure(type: ErrorType.unknown, message: e.message),
    };
