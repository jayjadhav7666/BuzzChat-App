class ApiException implements Exception {
  final String message;
  ApiException({required this.message});

  @override
  String toString() {
    return message;
  }
}

class InternetException extends ApiException {
  InternetException(String message) : super(message: message);
}

class RequestTimeoutException extends ApiException {
  RequestTimeoutException(String message) : super(message: message);
}

class FetchDataException extends ApiException {
  FetchDataException(String message) : super(message: message);
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message: message);
}

class InvalidUrlException extends ApiException {
  InvalidUrlException(String message) : super(message: message);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message: message);
}

class RequestTimeOut extends ApiException {
  RequestTimeOut(String message) : super(message: message);
}
