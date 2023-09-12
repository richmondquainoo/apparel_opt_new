import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/BranchModel.dart';
import '../Model/MenuModel.dart';

class MenuDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-menu.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table menu("
          "id INTEGER PRIMARY KEY, "
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
          "organization TEXT, "
          "publish TEXT, "
          "quantity TEXT, "
          "product TEXT,"
          "brand TEXT,"
          "manufacturer TEXT,"
          "newArrival TEXT,"
          "productVariants TEXT  "
          ")",
        );
      },
      version: 9,
    );
  }

  Future<bool> insertObject(MenuModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(MenuModel): $db');
      await db.insert(
        'menu',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('Menu has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(MenuModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> insertBranch(BranchModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(MenuModel): $db');
      await db.insert(
        'menu',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('Menu branch has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(MenuModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(MenuModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(MenuModel): $db');
      await db.update(
        'menu',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(MenuModel): $e');
      return false;
    }
    return true;
  }

  Future<List<MenuModel>> getAllMenu() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('menu');
      print('List of items from getAllMenu query: $maps');

      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            brand: maps[i]["brand"],
            manufacturer: maps[i]["manufacturer"],
            newArrival: maps[i]["newArrival"],
            // productVariants: maps[i]["productVariants"]
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllMenu): $e');
      return null!;
    }
  }

  Future<MenuModel> getMenuById(MenuModel menuModel) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('select * from menu where id=${menuModel.id}');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            organization: maps[i]['organization'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            brand: maps[i]["brand"],
            manufacturer: maps[i]["manufacturer"],
            newArrival: maps[i]["newArrival"],
            // productVariants: maps[i]["productVariants"]
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getMenuById): $e');
      return null!;
    }
  }

  Future<MenuModel> getMenuByName(MenuModel menuModel) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db
          .rawQuery('select * from menu where menuItem=${menuModel.menuItem}');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            organization: maps[i]['organization'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            productVariants: maps[i]["productVariants"],
            brand: maps[i]["brand"],
            manufacturer: maps[i]["manufacturer"],
            newArrival: maps[i]["newArrival"],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getMenuByMenuItem): $e');
      return null!;
    }
  }

  Future<MenuModel> getMenuByIdOnly(int id) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('select * from menu where id=$id');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            organization: maps[i]['organization'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            brand: maps[i]["brand"],
            manufacturer: maps[i]["manufacturer"],
            newArrival: maps[i]["newArrival"],
            // productVariants: maps[i]["productVariants"]
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getMenuByIdOnly): $e');
      return null!;
    }
  }

  Future<List<MenuModel>> getAllPromos() async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from menu where publish=\'true\' and category=\'Promo\'');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            organization: maps[i]['organization'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            brand: maps[i]["brand"],
            manufacturer: maps[i]["manufacturer"],
            newArrival: maps[i]["newArrival"],
            // productVariants: maps[i]["productVariants"]
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getMenuById): $e');
      return null!;
    }
  }

  Future<List<MenuModel>> getAllCategories() async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select distinct category as category, imageUrl as imageUrl from menu where publish=\'true\' group by category ');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            imageUrl: maps[i]['imageUrl'],
            category: maps[i]['category'], productVariants: [],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getMenuById): $e');
      return null!;
    }
  }

  Future<List<MenuModel>> getByCategory(String category) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from menu where publish=\'true\' and category=\'$category\' ');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            organization: maps[i]['organization'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            brand: maps[i]["brand"],
            manufacturer: maps[i]["manufacturer"],
            newArrival: maps[i]["newArrival"],
            // productVariants: maps[i]["productVariants"]
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getMenuById): $e');
      return null!;
    }
  }

  Future<List<MenuModel>> getByNewArrival() async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from menu where newArrival=\'true\'');
      return List.generate(
        maps.length,
            (i) {
          return MenuModel(
              id: maps[i]['id'],
              type: maps[i]['type'],
              price: maps[i]['price'],
              size: maps[i]['size'],
              imageUrl: maps[i]['imageUrl'],
              tagName: maps[i]['tagName'],
              description: maps[i]['description'],
              branch: maps[i]['branch'],
              cumulativeRating: maps[i]['cumulativeRating'],
              ratingFrequency: maps[i]['ratingFrequency'],
              category: maps[i]['category'],
              menuItem: maps[i]['menuItem'],
              organization: maps[i]['organization'],
              publish: maps[i]['publish'],
              product: maps[i]["product"],
              brand: maps[i]["brand"],
              manufacturer: maps[i]["manufacturer"],
              newArrival: maps[i]["newArrival"],
              // productVariants: maps[i]["productVariants"]
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getByNewArrival): $e');
      return null!;
    }
  }

  Future<List<MenuModel>> getApplicableCategoryList(
      String category, String applicableCategory) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from menu where publish=\'true\' and category=\'$category\' and applicableCategory like \'%$applicableCategory%\'');
      return List.generate(
        maps.length,
        (i) {
          return MenuModel(
            id: maps[i]['id'],
            type: maps[i]['type'],
            price: maps[i]['price'],
            size: maps[i]['size'],
            imageUrl: maps[i]['imageUrl'],
            tagName: maps[i]['tagName'],
            description: maps[i]['description'],
            branch: maps[i]['branch'],
            cumulativeRating: maps[i]['cumulativeRating'],
            ratingFrequency: maps[i]['ratingFrequency'],
            category: maps[i]['category'],
            menuItem: maps[i]['menuItem'],
            organization: maps[i]['organization'],
            publish: maps[i]['publish'],
            product: maps[i]["product"],
            // productVariants: maps[i]["productVariants"]
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getMenuById): $e');
      return null!;
    }
  }




  Future<List<BranchModel>> getBranch() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('menu');
      // print('List of items from getBranch query: $maps');

      return List.generate(
        maps.length,
        (i) {
          return BranchModel(branch: maps[i]['branch']);
        },
      );
    } catch (e) {
      print('Fetch Error(getAllMenu): $e');
      return null!;
    }
  }

  Future<void> deleteOrder(int id) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'menu',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'menu',
    );
  }
}
