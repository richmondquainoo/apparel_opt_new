import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/CategoryModel.dart';

class CategoryDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-category.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table category("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "category TEXT, "
          "imageUrl TEXT"
          ")",
        );
      },
      version: 1,
    );
  }

  Future<bool> insertObject(CategoryModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(CategoryModel): $db');
      await db.insert(
        'category',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insertion Error(CategoryModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(CategoryModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(CategoryModel): $db');
      await db.update(
        'category ',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(CategoryModel): $e');
      return false;
    }
    return true;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('category');
      print('List of items from getAllCategories query: $maps');

      return List.generate(
        maps.length,
        (i) {
          return CategoryModel(
            id: maps[i]['id'],
            imageUrl: maps[i]['imageUrl'],
            category: maps[i]['category'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllCategories): $e');
      return null!;
    }
  }

  Future<CategoryModel> getCategoryByPromo(CategoryModel categoryModel) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from category where category=\'${categoryModel.category}\'');
      return List.generate(
        maps.length,
        (i) {
          return CategoryModel(
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
      'category',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'category',
    );
  }
}
