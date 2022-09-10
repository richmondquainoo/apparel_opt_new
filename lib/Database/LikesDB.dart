import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/LikeModel.dart';

class LikesDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-likes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table likes("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "organization TEXT, "
          "branch TEXT, "
          "email TEXT, "
          "likes INTEGER,"
          "menuId INTEGER"
          ")",
        );
      },
      version: 1,
    );
  }

  Future<bool> insertObject(LikeModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(LikeModel): $db');
      await db.insert(
        'likes',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insertion Error(LikeModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(LikeModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(LikeModel): $db');
      await db.update(
        'likes ',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(LikeModel): $e');
      return false;
    }
    return true;
  }

  Future<List<LikeModel>> getAllLikes() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('likes');
      print('List of items from getAllCategories query: $maps');

      return List.generate(
        maps.length,
        (i) {
          return LikeModel(
            id: maps[i]['id'],
            email: maps[i]['email'],
            likes: maps[i]['likes'],
            menuId: maps[i]['menuId'],
            organization: maps[i]['organization'],
            branch: maps[i]['branch'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllLikes): $e');
      return null;
    }
  }

  Future<LikeModel> getLikesById(LikeModel likeModel) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('select * from likes where id=${likeModel.id}');
      return List.generate(
        maps.length,
        (i) {
          return LikeModel(
            id: maps[i]['id'],
            email: maps[i]['email'],
            likes: maps[i]['likes'],
            menuId: maps[i]['menuId'],
            organization: maps[i]['organization'],
            branch: maps[i]['branch'],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getLikesById): $e');
      return null;
    }
  }

  Future<void> deleteLikes(int id) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'likes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'likes',
    );
  }
}
