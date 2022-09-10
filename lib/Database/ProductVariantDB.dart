

import 'package:apparel_options/Model/ProductVariantModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Model/NewMenuModel.dart';
class ProductVariantDB{

  var database;

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-productVariant.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table productVariant("
              "id INTEGER PRIMARY KEY, "
              "productId INTEGER, "
              "imageUrl TEXT, "
              "color TEXT, "
              "colorCode TEXT, "
              "quantity INTEGER, "
              "sizes TEXT "
              ")",
        );
      },
      version: 11,
    );
  }


  Future<bool> insertObject(ProductVariantModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(ProductVariantModel): $db');
      await db.insert(
        'productVariant',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('Menu has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(productVariantModel): $e');
      return false;
    }
    return true;
  }

  Future<List<ProductVariantModel>> getProductVariantById(String productID) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<dynamic, dynamic>> maps = await db.rawQuery('select * from productVariant where productId=${productID}');
      return List.generate(
        maps.length,
            (i) {
              return ProductVariantModel(
                id: maps[i]['id'],
                productId: maps[i]['productId'],
                color: maps[i]['color'] as String,
                colorCode: maps[i]['colorCode']as String,
                imageUrl: maps[i]['imageUrl'] as String,
                sizes: maps[i]['sizes'] as String,
                quantity: maps[i]['quantity'],
              );
        },
      );
    } catch (e) {
      print('Fetch Error(getProductVariantById): $e');
      return null;
    }
  }

  Future<List<ProductVariantModel>> getAllProductVariant() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<dynamic, dynamic>> maps = await db.query('productVariant');

      return List.generate(
        maps.length,
            (i) {
          return ProductVariantModel(
              id: maps[i]['id'],
              productId: maps[i]['productId'],
              color: maps[i]['color'] as String,
              colorCode: maps[i]['colorCode']as String,
              imageUrl: maps[i]['imageUrl'] as String,
              quantity: maps[i]['quantity'],
              sizes: maps[i]['sizes'] as String,
          );

        },
      );
    } catch (e) {
      print('Fetch Error(getAllProductVariants): $e');
      return null;
    }
  }

  Future<List<ProductVariantModel>> getAllVariants() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('productVariant');
      // print('List of items from getAllMenu query: $maps');

      return List.generate(
        maps.length,
            (i) {
          return ProductVariantModel(
            id: maps[i]['id'],
            productId:  maps[i]['productId'],
            color: maps[i]['color'] as String,
            colorCode: maps[i]['colorCode']as String,
            imageUrl: maps[i]['imageUrl'] as String,
            quantity: maps[i]['quantity'],
            sizes: maps[i]['sizes'] as String,
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllVariants): $e');
      return null;
    }
  }


  Future<bool> updateObject(ProductVariantModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(ProductVariantModel): $db');
      await db.update(
        'productVariant',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(ProductVariantModel): $e');
      return false;
    }
    return true;
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'productVariant',
    );
  }
}