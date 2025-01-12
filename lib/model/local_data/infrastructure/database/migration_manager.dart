import 'package:flutter_template/model/local_data/infrastructure/database/query/hello_world_query.dart';
import 'package:sqflite/sqflite.dart';

class MigrationManager {
  static Future<void> onCreate(Database db, int version) async {
    // クエリを使用してテーブルを作成
    await db.execute(HelloWorldQuery.createTable);
    await db.execute(HelloWorldQuery.insert);
  }

  static Future<void> onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // 必要に応じてアップグレード用クエリをここに追加
  }
}
