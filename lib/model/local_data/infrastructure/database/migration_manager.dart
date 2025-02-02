import 'package:flutter_template/model/local_data/infrastructure/database/query/app_data_query.dart';
import 'package:flutter_template/model/local_data/infrastructure/database/query/auth_query.dart';
import 'package:flutter_template/model/local_data/infrastructure/database/query/example_query.dart';
import 'package:sqflite/sqflite.dart';

class MigrationManager {
  static Future<void> onCreate(Database db, int version) async {
    // クエリを使用してテーブルを作成
    await db.execute(AppDataQuery.createTable);
    await db.execute(HelloWorldQuery.createTable);
    await db.execute(HelloWorldQuery.insert);
    await db.execute(AuthQuery.createTable);
  }

  static Future<void> onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // 必要に応じてアップグレード用クエリをここに追加
  }
}
