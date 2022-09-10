

import 'package:apparel_options/Model/ProductSpecificationModel.dart';
import 'package:apparel_options/Model/ProductVariantModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Model/NewMenuModel.dart';
import '../Model/ProductDetailsModel.dart';
class ProductDetailsDB{

  var database;

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-productDetails.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table productDetails("
              "id INTEGER PRIMARY KEY, "
              "organization TEXT, "
              "header TEXT, "
              "details TEXT, "
              "createdBy TEXT, "
              "productId INTEGER "
              ")",
        );
      },
      version: 1,
    );
  }


  Future<bool> insertObject(ProductDetailsModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(ProductDetailsModel): $db');
      await db.insert(
        'productDetails',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('Menu has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(ProductDetailsModel): $e');
      return false;
    }
    return true;
  }

  Future<List<ProductDetailsModel>> getProductDetailsById(String productID) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<dynamic, dynamic>> maps = await db.rawQuery('select * from productDetails where productId=${productID}');
      return List.generate(
        maps.length,
            (i) {
          return ProductDetailsModel(
            id: maps[i]['id'],
            productId: maps[i]['productId'],
            organization: maps[i]['organization'] as String,
            header: maps[i]['header'] as String,
            createdBy: maps[i]['createdBy'] as String,
            details: maps[i]['details'] as String

          );
        },
      );
    } catch (e) {
      print('Fetch Error(getProductDetailsById): $e');
      return null;
    }
  }


  Future<List<String>> getProductDetailHeaders(int productID) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<dynamic, dynamic>> maps = await db.rawQuery('select distinct header from productDetails where productId=${productID}');
      return List.generate(
        maps.length,
            (i) {
          return maps[i]['header'] as String;
        },
      );
    } catch (e) {
      print('Fetch Error(getProductDetailHeaders): $e');
      return null;
    }
  }

  // Future<List<String>> getProductDetailsByHeader(int productID, String header) async {
  //   try {
  //     final Database db = await database;
  //
  //     // Query the obj
  //     final List<Map<dynamic, dynamic>> maps = await db.rawQuery('select details from productDetails where productId=${productID} and header=\'${header}\'');
  //     return List.generate(
  //       maps.length,
  //           (i) {
  //         return maps[i]['details'] as String;
  //       },
  //     );
  //   } catch (e) {
  //     print('Fetch Error(getProductDetailsByHeader): $e');
  //     return null;
  //   }
  // }

  Future<List<ProductDetailsModel>> getProductDetailsByHeader(int productID, String header) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<dynamic, dynamic>> maps = await db.rawQuery('select details from productDetails where productId=${productID} and header=\'${header}\'');
      return List.generate(
        maps.length,
            (i) {
          return ProductDetailsModel(
              id: maps[i]['id'],
              productId: maps[i]['productId'],
              organization: maps[i]['organization'] as String,
              header: maps[i]['header'] as String,
              createdBy: maps[i]['createdBy'] as String,
              details: maps[i]['details'] as String

          );
        },
      );
    } catch (e) {
      print('Fetch Error(getProductDetailsByHeader): $e');
      return null;
    }
  }


  Future<List<ProductDetailsModel>> getAllProductDetails() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<dynamic, dynamic>> maps = await db.query('productDetails');

      return List.generate(
        maps.length,
            (i) {
          return ProductDetailsModel(
            id: maps[i]['id'],
            productId: maps[i]['productId'],
            organization: maps[i]['organization'] as String,
            header: maps[i]['header'] as String,
            createdBy: maps[i]['createdBy'] as String,
            details: maps[i]['details'] as String

          );

        },
      );
    } catch (e) {
      print('Fetch Error(getAllProductDetails): $e');
      return null;
    }
  }


  Future<bool> updateObject(ProductDetailsModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(ProductDetailsModel): $db');
      await db.update(
        'productDetails',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(ProductDetailsModel): $e');
      return false;
    }
    return true;
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'productDetails',
    );
  }
}