class Err {
  final String message;
  const Err({required this.message});
}

class RepositoryErr extends Err {
  const RepositoryErr({required super.message});
}

class UsecaseErr extends Err {
  const UsecaseErr({required super.message});
}

class ErrMessages {
  static const String notFound = "Data not found";
  static const String databaseError = "Database error occurred";
  static const String internalError = "Internal server error";
}

class RepositoryError {
  static const RepositoryErr notFound =
      RepositoryErr(message: ErrMessages.notFound);
  static const RepositoryErr databaseError =
      RepositoryErr(message: ErrMessages.databaseError);
}

class UsecaseError {
  static const UsecaseErr notFound = UsecaseErr(message: ErrMessages.notFound);
  static const UsecaseErr databaseError =
      UsecaseErr(message: ErrMessages.databaseError);
  static const UsecaseErr internalError =
      UsecaseErr(message: ErrMessages.internalError);
}
