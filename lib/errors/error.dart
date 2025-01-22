class Err {
  final String message;
  const Err({required this.message});
}

class ErrMessages {
  static const String badRequest = "Request was invalid";
  static const String unauthorized = "Not authorized to access";
  static const String forbidden = "Access to this resource is forbidden";
  static const String notFound = "Data not found";
  static const String conflict = "Resource conflict";
  static const String internalError = "Internal server error";
  static const String serviceUnavailabe = "Service temporarily unavailable";
  static const String networkUnavailable = "Network is unconnected";
  static const String timeout = "Connection is timeout";
  static const String invalidResponseFormat = "Unexpected response format";
  static const String databaseError = "Database error occurred";
  static const String unknownError = "Unknown error occurred";
}

class HttpErr extends Err {
  const HttpErr({required super.message});
}

class HttpError {
  static const HttpErr badRequest = HttpErr(message: ErrMessages.badRequest);
  static const HttpErr unauthorized =
      HttpErr(message: ErrMessages.unauthorized);
  static const HttpErr forbidden = HttpErr(message: ErrMessages.forbidden);
  static const HttpErr notFound = HttpErr(message: ErrMessages.notFound);
  static const HttpErr conflict = HttpErr(message: ErrMessages.conflict);
  static const HttpErr internalError =
      HttpErr(message: ErrMessages.internalError);
  static const HttpErr serviceUnavailabe =
      HttpErr(message: ErrMessages.serviceUnavailabe);
  static const HttpErr networkUnavailable =
      HttpErr(message: ErrMessages.networkUnavailable);
  static const HttpErr timeout = HttpErr(message: ErrMessages.timeout);
  static const HttpErr invalidResponseFormat =
      HttpErr(message: ErrMessages.invalidResponseFormat);
  static const HttpErr unknownError =
      HttpErr(message: ErrMessages.unknownError);
}

class LocalDataErr extends Err {
  const LocalDataErr({required super.message});
}

class LocalDataError {
  static const LocalDataErr notFound =
      LocalDataErr(message: ErrMessages.notFound);
  static const LocalDataErr databaseError =
      LocalDataErr(message: ErrMessages.databaseError);
  static const LocalDataErr internalError =
      LocalDataErr(message: ErrMessages.internalError);
}
