class HelloWorldQuery {
  static const String createTable = '''
    CREATE TABLE hello_world (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      tag INTEGER NOT NULL
    );
  ''';
  static const String insert = '''
    INSERT INTO hello_world (name, tag) VALUES
    ('hello, world!', 1),
    ('こんにちは！', 0),
    ('안녕하세요!', 0)
  ''';
}
