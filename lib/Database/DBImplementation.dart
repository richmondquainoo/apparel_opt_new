import 'package:flutter/material.dart';

import '../Model/UserProfileModel.dart';
import 'UserDB.dart';

class DBImplementation {
  final BuildContext? context;
  DBImplementation({this.context});

  UserDB userDB = UserDB();

  Future<void> initializeDB() async {
    try {
      await userDB.initialize();
    } catch (e) {
      print('initializeDB error: $e');
    }
  }

  Future<bool> saveUser(UserProfileModel model) async {
    try {
      await initializeDB();
      await userDB.deleteAll();
      return userDB.insertObject(model);
    } catch (e) {
      print('saveUser error: $e');
      return false;
    }
  }

  Future<Future<UserProfileModel?>?> authenticateAgainstLocalDB(
      String email, String password) async {
    try {
      await initializeDB();
      return userDB.authenticateUser(email, password);
    } catch (e) {
      print('authenticateAgainstLocalDB error: $e');
      return null;
    }
  }

  Future<UserProfileModel> getUser() async {
    try {
      await initializeDB();
      List<UserProfileModel> users = await userDB.getAllUsers();
      if (users.isNotEmpty) {
        return users.first;
      }
    } catch (e) {
      print('getUser error: $e');
      return null!;
    }
    return null!;
  }

  Future<void> deleteAll() async {
    try {
      await initializeDB();
      return userDB.deleteAll();
    } catch (e) {
      print('authenticateAgainstLocalDB error: $e');
      return null;
    }
  }
}
