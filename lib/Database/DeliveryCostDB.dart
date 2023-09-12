import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/DeliveryCost.dart';

class DeliveryCostDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-del-cost.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table delcost("
          "id INTEGER PRIMARY KEY, "
          "branch TEXT, "
          "organization TEXT, "
          "minDistance REAL, "
          "maxDistance REAL, "
          "cost REAL "
          ")",
        );
      },
      version: 6,
    );
  }

  Future<bool> insertObject(DeliveryCost model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(DeliveryCost): $db');
      await db.insert(
        'delcost',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('delcost has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(DeliveryCost): $e');
      return false;
    }
    return true;
  }

  Future<List<DeliveryCost>> getDeliveryCost() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('delcost');
      return List.generate(
        maps.length,
        (i) {
          return DeliveryCost(
            branch: maps[i]['branch'],
            organization: maps[i]['organization'],
            maxDistance: maps[i]['maxDistance'],
            minDistance: maps[i]['minDistance'],
            cost: maps[i]['cost'],
            id: maps[i]['id'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAlldelcost): $e');
      return null!;
    }
  }

  Future<DeliveryCost> getDeliveryCostByBranch(String branch) async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('select * from delcost where branch=\'$branch\'');
      return List.generate(
        maps.length,
        (i) {
          return DeliveryCost(
            branch: maps[i]['branch'],
            organization: maps[i]['organization'],
            maxDistance: maps[i]['maxDistance'],
            minDistance: maps[i]['minDistance'],
            cost: maps[i]['cost'],
            id: maps[i]['id'],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getAlldelcost): $e');
      return null!;
    }
  }

  Future<DeliveryCost> getDeliveryCostByBranchAndDistance(
      String branch, double distance) async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('select * from delcost where branch=\'$branch\' '
              'and minDistance >= $distance and maxDistance <= $distance');
      return List.generate(
        maps.length,
        (i) {
          return DeliveryCost(
            branch: maps[i]['branch'],
            organization: maps[i]['organization'],
            maxDistance: maps[i]['maxDistance'],
            minDistance: maps[i]['minDistance'],
            cost: maps[i]['cost'],
            id: maps[i]['id'],
          );
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getAlldelcost): $e');
      return null!;
    }
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'delcost',
    );
  }
}
