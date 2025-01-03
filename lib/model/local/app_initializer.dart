import 'package:flutter_template/model/local/infrastructure/database/database_handler.dart';

class AppInitializer {
  static Future<void> initialize() async {
    await DatabaseHandler.instance.initDatabase();
  }
}
