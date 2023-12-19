import 'package:example_app/features/journal/domain/entities/download_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Downloads(id TEXT PRIMARY KEY, filePath TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> createItem(String fileId, String filePath) async {
    debugPrint("TTTTT create item");
    final Database db = await initializeDB();
    final id = await db.insert(
        'Downloads',
        {
          'id': fileId,
          'filePath': filePath,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<DownloadItem>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Downloads');
    return queryResult.map((e) => DownloadItem.fromJson(e)).toList();
  }
}
