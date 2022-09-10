import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/MenuModel.dart';
import '../Model/NewMenuModel.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE Table cart("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "type TEXT, "
      "imageUrl TEXT, "
      "price TEXT, "
      "size TEXT, "
      "description TEXT, "
      "branch TEXT, "
      "cumulativeRating TEXT, "
      "ratingFrequency TEXT, "
      "category TEXT, "
      "tagName TEXT, "
      "menuItem TEXT, "
      "likes TEXT, "
      "minOptions TEXT, "
      "maxOptions TEXT, "
      "minSides TEXT, "
      "maxSides TEXT, "
      "minProteins TEXT, "
      "maxProteins TEXT, "
      "minDrinks TEXT, "
      "maxDrinks TEXT, "
      "minSauces TEXT, "
      "maxSauces TEXT "
      ")",
    );
  }

  Future<NewMenuModel> insert(NewMenuModel menuModel) async {
    print(menuModel.toMap());
    var dbClient = await db;
    await dbClient.insert('cart', menuModel.toMap());
    print("Added to Cart: $menuModel");
    return menuModel;
  }

  Future<List<MenuModel>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object>> queryResult = await dbClient.query('cart');
    return queryResult.map((e) => MenuModel.fromMap(e)).toList();
  }

  // Future<List<CartModel>> getCartSummary() async {
  //   var dbClient = await db;
  //   final List<Map<String, Object>> queryResult = await dbClient.query('cart');
  //   return queryResult.map((e) => CartModel.fromMap(e)).toList();
  // }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(MenuModel menuModel) async {
    var dbClient = await db;
    return await dbClient.update('cart', menuModel.toMap(),
        where: 'id = ?', whereArgs: [menuModel.id]);
  }

  Future<void> deleteAllCartItems() async {
    var dbClient = await db;
    // Remove Object from the database.
    return await dbClient.delete("cart");
  }
}
