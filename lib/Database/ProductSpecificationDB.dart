

import 'package:apparel_options/Model/ProductSpecificationModel.dart';
import 'package:apparel_options/Model/ProductVariantModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductSpecificationDB{

  var database;

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-productSpecification.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table productSpecification("
              "id INTEGER PRIMARY KEY, "
              "organization TEXT, "
              "specification TEXT, "
              "value TEXT, "
              "createdBy TEXT, "
              "productId INTEGER "
              ")",
        );
      },
      version: 5,
    );
  }


  Future<bool> insertObject(ProductSpecificationModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(ProductSpecificationModel): $db');
      await db.insert(
        'productSpecification',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('Menu has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(ProductSpecificationModel): $e');
      return false;
    }
    return true;
  }

  Future<List<ProductSpecificationModel>> getProductSpecificationById(String productID) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<dynamic, dynamic>> maps = await db.rawQuery('select * from productSpecification where productId=${productID}');
      return List.generate(
        maps.length,
            (i) {
          return ProductSpecificationModel(
            // id: maps[i]['id'],
            // productId: maps[i]['productId'],
            organization: maps[i]['organization'] as String,
            value: maps[i]['value']as String,
            specification: maps[i]['specification'] as String,
            createdBy: maps[i]['createdBy'] as String,

          );
        },
      );
    } catch (e) {
      print('Fetch Error(getProductSpecificationById): $e');
      return null;
    }
  }

  Future<List<ProductSpecificationModel>> getAllProductSpecification() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<dynamic, dynamic>> maps = await db.query('productSpecification');

      return List.generate(
        maps.length,
            (i) {
          return ProductSpecificationModel(
            // id: maps[i]['id'],
            productId: maps[i]['productId'],
            organization: maps[i]['organization'] as String,
            value: maps[i]['value']as String,
            specification: maps[i]['specification'] as String,
            createdBy: maps[i]['createdBy'] as String,

          );

        },
      );
    } catch (e) {
      print('Fetch Error(getAllProductVariants): $e');
      return null;
    }
  }


  Future<bool> updateObject(ProductSpecificationModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(ProductSpecificationModel): $db');
      await db.update(
        'productSpecification',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(ProductSpecificationModel): $e');
      return false;
    }
    return true;
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'productSpecification',
    );
  }
}