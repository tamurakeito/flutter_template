class Err {
  final String message;
  const Err({required this.message});
}

class ErrMessages {
  static const String notFound = "Data not found";
  static const String databaseError = "Database error occurred";
  static const String internalError = "Internal server error";
}

class HttpErr extends Err {
  const HttpErr({required super.message});
}

class HttpError {
  static const HttpErr notFound = HttpErr(message: ErrMessages.notFound);
  // static const HttpErr databaseError =
  //     HttpErr(message: ErrMessages.databaseError);
  static const HttpErr internalError =
      HttpErr(message: ErrMessages.internalError);
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
