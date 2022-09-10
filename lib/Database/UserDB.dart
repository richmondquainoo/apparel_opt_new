import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/UserProfileModel.dart';

class UserDB {
  var database;

//  Initialize DB
  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-user.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table user("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name TEXT, "
              "password TEXT, "
              "phone TEXT, "
              "email TEXT "
              ")",
        );
      },
      version: 10,
    );
  }

  Future<bool> insertObject(UserProfileModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(UserProfileModel): $db');
      await db.insert(
        'user',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insertion Error(UserProfileModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(UserProfileModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(UserProfileModel): $db');
      await db.update(
        'user ',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(UserProfileModel): $e');
      return false;
    }
    return true;
  }

  Future<List<UserProfileModel>> getAllUsers() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('user');
      print('List of items from getAllUsers query: $maps');

      return List.generate(
        maps.length,
            (i) {
          return UserProfileModel(
            id: maps[i]['id'],
            name: maps[i]['name'],
            password: maps[i]['password'],
            phone: maps[i]['phone'],
            email: maps[i]['email'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllUsers): $e');
      return null;
    }
  }

  Future<UserProfileModel> authenticateUser(
      String email, String password) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from customerApp where email=\'$email\' and password=\'$password\'');
      if (maps.isNotEmpty) {
        return List.generate(
          maps.length,
              (i) {
            return UserProfileModel(
              id: maps[i]['id'],
              name: maps[i]['name'],
              password: maps[i]['password'],
              phone: maps[i]['phone'],
              email: maps[i]['email'],
            );
          },
        ).first;
      }
    } catch (e) {
      print('Fetch Error(authenticateUser): $e');
      return null;
    }
  }

  Future<UserProfileModel> getUserByEmail(String email) async {
    try {
      final Database db = await database;

      // Query the obj
      final List<Map<String, dynamic>> maps =
      await db.rawQuery('select * from customerApp where email=\'$email\'');
      return List.generate(
        maps.length,
            (i) {
          return UserProfileModel(
            id: maps[i]['id'],
            name: maps[i]['name'],
            password: maps[i]['password'],
            phone: maps[i]['phone'],
            email: maps[i]['email'],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getUserByEmail): $e');
      return null;
    }
  }

  Future<void> deleteByProfileName(String name) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'user',
      where: "name = ?",
      whereArgs: [name],
    );
  }

  Future<void> deleteObject(int id) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'user',
    );
  }
}
