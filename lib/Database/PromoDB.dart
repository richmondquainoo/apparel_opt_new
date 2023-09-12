import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/PromoModel.dart';

class PromoDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-promo.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table promo("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "category TEXT, "
          "imageUrl TEXT"
          ")",
        );
      },
      version: 1,
    );
  }

  Future<bool> insertObject(PromoModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(PromoModel): $db');
      await db.insert(
        'promo',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insertion Error(PromoModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(PromoModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(PromoModel): $db');
      await db.update(
        'promo ',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(PromoModel): $e');
      return false;
    }
    return true;
  }

  Future<List<PromoModel>> getAllPromos() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('promo');
      print('List of items from getAllPromos query: $maps');

      return List.generate(
        maps.length,
        (i) {
          return PromoModel(
            id: maps[i]['id'],
            imageUrl: maps[i]['imageUrl'],
            category: maps[i]['category'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllPromo): $e');
      return null!;
    }
  }

  Future<PromoModel> getCategoryByPromo(PromoModel promoModel) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from category where category=\'${promoModel.category}\'');
      return List.generate(
        maps.length,
        (i) {
          return PromoModel(
            id: maps[i]['id'],
            imageUrl: maps[i]['imageUrl'],
            category: maps[i]['category'],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getCategoryByPromo): $e');
      return null!;
    }
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'promo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'promo',
    );
  }
}
