class AuthQuery {
  static const String createTable = '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY,
      user_id TEXT NOT NULL,
      password TEXT NOT NULL,
      name TEXT NOT NULL,
      token TEXT NOT NULL
    );
  ''';
}
