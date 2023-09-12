import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/BranchModel.dart';

class BranchDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-branch.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table branch("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "branch TEXT "
          ")",
        );
      },
      version: 6,
    );
  }

  Future<bool> insertObject(BranchModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(branchModel): $db');
      await db.insert(
        'branch',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('branch has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(branchModel): $e');
      return false;
    }
    return true;
  }

  Future<BranchModel> getBranch() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('branch');
      return List.generate(
        maps.length,
        (i) {
          return BranchModel(branch: maps[i]['branch']);
        },
      ).first;
    } catch (e) {
      print('Fetch Error(getAllBranch): $e');
      return null!;
    }
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'branch',
    );
  }
}
