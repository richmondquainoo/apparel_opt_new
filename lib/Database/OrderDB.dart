import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/NewOrderModel.dart';

class OrderDB {
  var database;
//   Initialize the database

  Future<void> initialize() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'apparel-orders.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE Table orders("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "orderNo TEXT, "
              "orderLon TEXT, "
              "orderLat TEXT, "
              "orderAddress TEXT, "
              "orderBy TEXT, "
              "orderPhone TEXT, "
              "orderStatus TEXT, "
              "orderDate TEXT, "
              "orderEmail TEXT, "
              "orderDetail TEXT, "
              "orderAdditionalInfo TEXT, "
              "orderTotalAmount TEXT, "
              "orderQuantity TEXT, "
              "orderBranch TEXT, "
              "channel TEXT, "
              "dispatcher TEXT, "
              "dispatcherPhone TEXT, "
              "distance TEXT, "
              "eta TEXT, "
              "deliveryDate TEXT, "
              "acknowledgementDate TEXT, "
              "paymentAmount TEXT, "
              "orderTakenBy TEXT, "
              "paymentStatus TEXT, "
              "deliveryOption TEXT, "
              "organizationName TEXT, "
              "organizationCode TEXT, "
              "paymentMode TEXT, "
              "deliverySchedule TEXT, "
              "additionalNote TEXT, "
              "serviceCharge TEXT, "
              "deliveryCharge TEXT, "
              "orderItemCost TEXT "
              ")",
        );
      },
      version: 6,
    );
  }

  Future<bool> insertObject(NewOrderModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(NewOrderModel): $db');
      await db.insert(
        'orders',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Insertion Error(NewOrderModel): $e');
      return false;
    }
    return true;
  }

  Future<bool> updateObject(NewOrderModel model) async {
    try {
      final Database db = await database; // Get a reference to the database.
      print('Database(NewOrderModel): $db');
      await db.update(
        'orders ',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Update Error(NewOrderModel): $e');
      return false;
    }
    return true;
  }

  Future<List<NewOrderModel>> getAllOrders() async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.query('orders');
      print('List of items from getAllOrders query: $maps');

      return List.generate(
        maps.length,
            (i) {
          return NewOrderModel(
            orderNo: maps[i]['orderNo'],
            orderLon: maps[i]['orderLon'],
            orderLat: maps[i]['orderLat'],
            orderAddress: maps[i]['orderAddress'],
            orderBy: maps[i]['orderBy'],
            orderPhone: maps[i]['orderPhone'],
            orderEmail: maps[i]['orderEmail'],
            orderDetail: maps[i]['orderDetail'],
            orderAdditionalInfo: maps[i]['orderAdditionalInfo'],
            orderStatus: maps[i]['orderStatus'],
            orderTotalAmount: maps[i]['orderTotalAmount'],
            orderQuantity: maps[i]['orderQuantity'],
            orderBranch: maps[i]['orderBranch'],
            channel: maps[i]['channel'],
            dispatcher: maps[i]['dispatcher'],
            dispatcherPhone: maps[i]['dispatcherPhone'],
            distance: maps[i]['distance'],
            eta: maps[i]['eta'],
            deliveryDate: maps[i]['deliveryDate'],
            acknowledgementDate: maps[i]['acknowledgementDate'],
            paymentAmount: maps[i]['paymentAmount'],
            orderTakenBy: maps[i]['orderTakenBy'],
            paymentStatus: maps[i]['paymentStatus'],
            deliveryOption: maps[i]['deliveryOption'],
            organizationName: maps[i]['organizationName'],
            organizationCode: maps[i]['organizationCode'],
            paymentMode: maps[i]['paymentMode'],
            serviceCharge: maps[i]['paymentMode'],
            deliveryCharge: maps[i]['deliveryCharge'],
            orderItemCost: maps[i]['orderItemCost'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getAllOrders): $e');
      return null;
    }
  }

  Future<List<NewOrderModel>> getOrdersByPhone(String orderPhone) async {
    try {
      final Database db = await database;
      // Query the obj for all The Objects.
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'select * from orders where orderPhone = \'' + orderPhone + '\'');
      print('List of items from getOrdersByPhone query: $maps');

      return List.generate(
        maps.length,
            (i) {
          return NewOrderModel(
            orderNo: maps[i]['orderNo'],
            orderLon: maps[i]['orderLon'],
            orderLat: maps[i]['orderLat'],
            orderAddress: maps[i]['orderAddress'],
            orderBy: maps[i]['orderBy'],
            orderPhone: maps[i]['orderPhone'],
            orderEmail: maps[i]['orderEmail'],
            orderDetail: maps[i]['orderDetail'],
            orderAdditionalInfo: maps[i]['orderAdditionalInfo'],
            orderStatus: maps[i]['orderStatus'],
            orderTotalAmount: maps[i]['orderTotalAmount'],
            orderQuantity: maps[i]['orderQuantity'],
            orderBranch: maps[i]['orderBranch'],
            channel: maps[i]['channel'],
            dispatcher: maps[i]['dispatcher'],
            dispatcherPhone: maps[i]['dispatcherPhone'],
            distance: maps[i]['distance'],
            eta: maps[i]['eta'],
            deliveryDate: maps[i]['deliveryDate'],
            acknowledgementDate: maps[i]['acknowledgementDate'],
            paymentAmount: maps[i]['paymentAmount'],
            orderTakenBy: maps[i]['orderTakenBy'],
            paymentStatus: maps[i]['paymentStatus'],
            deliveryOption: maps[i]['deliveryOption'],
            organizationName: maps[i]['organizationName'],
            organizationCode: maps[i]['organizationCode'],
            paymentMode: maps[i]['paymentMode'],
            serviceCharge: maps[i]['paymentMode'],
            deliveryCharge: maps[i]['deliveryCharge'],
            orderItemCost: maps[i]['orderItemCost'],
          );
        },
      );
    } catch (e) {
      print('Fetch Error(getOrdersByPhone): $e');
      return null;
    }
  }

  Future<void> deleteOrder(int id) async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'orders',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    // Remove Object from the database.
    await db.delete(
      'orders',
    );
  }
}
