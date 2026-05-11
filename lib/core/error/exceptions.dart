abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class AssetException extends AppException {
  const AssetException(super.message);
}

class ParseException extends AppException {
  const ParseException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}
