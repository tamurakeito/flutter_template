import 'package:flutter_template/model/local_db/infrastructure/database/database_handler.dart';

class LocalDatabaseInitializer {
  static Future<void> initialize() async {
    await DatabaseHandler.instance.initDatabase();
  }
}
