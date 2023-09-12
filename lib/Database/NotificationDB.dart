import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/NotificationModel.dart';

class NotificationDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-notification.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table notification("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "orderNumber TEXT, "
          "orderStatus TEXT, "
          "title TEXT, "
          "message TEXT, "
          "dateSent TEXT, "
          "email TEXT "
          ")",
        );
      },
      version: 6,
    );
  }

  Future<bool> insertObject(NotificationModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(notification): $db');
      await db.insert(
        'notification',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('notification has been inserted: ${model.toMap()}');
    } catch (e) {
      print('Insertion Error(notification): $e');
      return false;
    }
    return true;
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('notification');
      return List.generate(
        maps.length,
        (i) {
          return NotificationModel(
            orderNumber: maps[i]['orderNumber'],
            orderStatus: maps[i]['orderStatus'],
            title: maps[i]['title'],
            message: maps[i]['message'],
            dateSent: maps[i]['dateSent'],
            email: maps[i]['email'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllNotification): $e');
      return null!;
    }
  }

  Future<List<NotificationModel>> getNotificationByEmail(String email) async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from notification where email=\'$email\' order by id desc');
      return List.generate(
        maps.length,
        (i) {
          return NotificationModel(
            orderNumber: maps[i]['orderNumber'],
            orderStatus: maps[i]['orderStatus'],
            title: maps[i]['title'],
            message: maps[i]['message'],
            dateSent: maps[i]['dateSent'],
            email: maps[i]['email'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getNotificationByEmail): $e');
      return null!;
    }
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'notification',
    );
  }
}
