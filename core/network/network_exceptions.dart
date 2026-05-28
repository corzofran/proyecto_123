class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class FetchDataException extends NetworkException {
  FetchDataException(String message) : super(message: message);
}

class BadRequestException extends NetworkException {
  BadRequestException(String message, int statusCode) : super(message: message, statusCode: statusCode);
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException(String message, int statusCode) : super(message: message, statusCode: statusCode);
}

class NotFoundException extends NetworkException {
  NotFoundException(String message, int statusCode) : super(message: message, statusCode: statusCode);
}
