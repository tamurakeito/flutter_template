class AppDataQuery {
  static const String createTable = '''
    CREATE TABLE settings (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    );
  ''';
}
