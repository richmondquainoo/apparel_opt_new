import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/RatingModel.dart';

class RatingDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-ratings.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table ratings("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "email TEXT, "
          "cumulativeRating TEXT"
          ")",
        );
      },
      version: 1,
    );
  }

  Future<bool> insertObject(RatingModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(RatingModel): $db');
      await db.insert(
        'ratings',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insertion Error(RatingModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(RatingModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(RatingModel): $db');
      await db.update(
        'ratings ',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(RatingsModel): $e');
      return false;
    }
    return true;
  }

  Future<List<RatingModel>> getAllRatings() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('ratings');
      print('List of items from getAllRatings query: $maps');

      return List.generate(
        maps.length,
        (i) {
          return RatingModel(
            id: maps[i]['id'],
            email: maps[i]['email'],
            cumulativeRating: maps[i]['cumulativeRating'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllRatings): $e');
      return null!;
    }
  }

  Future<void> deleteRating(int id) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'ratings',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'ratings',
    );
  }
}
