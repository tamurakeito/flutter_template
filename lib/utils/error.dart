class Err {
  final String message;
  const Err({required this.message});
}

class LocalDatabaseErr extends Err {
  const LocalDatabaseErr({required super.message});
}

class ErrMessages {
  static const String notFound = "Data not found";
  static const String databaseError = "Database error occurred";
  static const String internalError = "Internal server error";
}

class LocalDatabaseError {
  static const LocalDatabaseErr notFound =
      LocalDatabaseErr(message: ErrMessages.notFound);
  static const LocalDatabaseErr databaseError =
      LocalDatabaseErr(message: ErrMessages.databaseError);
  static const LocalDatabaseErr internalError =
      LocalDatabaseErr(message: ErrMessages.internalError);
}
