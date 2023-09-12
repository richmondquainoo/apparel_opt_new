import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Config.dart';

class ConfigDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-configs.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table configs("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "branch TEXT, "
          "organization TEXT, "
          "assignmentMode TEXT, "
          // "orderTracker INTEGER, "
          "latitude REAL, "
          "longitude REAL, "
          "serviceCharge REAL "
          ")",
        );
      },
      version: 6,
    );
  }

  Future<bool> insertObject(Config model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(Config): $db');
      await db.insert(
        'configs',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('configs has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(Config): $e');
      return false;
    }
    return true;
  }

  Future<List<Config>> getConfigs() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('configs');
      return List.generate(
        maps.length,
        (i) {
          return Config(
            branch: maps[i]['branch'],
            organization: maps[i]['organization'],
            assignmentMode: maps[i]['assignmentMode'],
            // orderTracker: maps[i]['orderTracker'],
            latitude: maps[i]['latitude'],
            longitude: maps[i]['longitude'],
            serviceCharge: maps[i]['serviceCharge'],
            id: maps[i]['id'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllConfigs): $e');
      return null!;
    }
  }

  Future<Config> getConfigsByBranch(String branch) async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('select * from configs where branch=\'$branch\'');
      return List.generate(
        maps.length,
        (i) {
          return Config(
            branch: maps[i]['branch'],
            organization: maps[i]['organization'],
            assignmentMode: maps[i]['assignmentMode'],
            // orderTracker: maps[i]['orderTracker'],
            latitude: maps[i]['latitude'],
            longitude: maps[i]['longitude'],
            serviceCharge: maps[i]['serviceCharge'],
            id: maps[i]['id'],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getAllConfigs): $e');
      return null!;
    }
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'configs',
    );
  }
}
