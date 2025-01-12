import 'package:flutter_template/model/local_data/infrastructure/database/migration_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  late Database _database;

  DatabaseHandler._internal();

  static DatabaseHandler get instance => _instance;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: MigrationManager.onCreate,
      onUpgrade: MigrationManager.onUpgrade,
    );
  }

  Database get database => _database;
}
