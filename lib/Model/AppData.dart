import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FullCartModel.dart';
import 'ProductModel.dart';
import 'UserProfileModel.dart';

class AppData extends ChangeNotifier {
  UserProfileModel userData;
  int appNotificationCount = 0;
  String branch;
  String actualLocation;
  String draggedLocation;
  // List<FullCartModel> cartItem = [];
  List<ProductModel> cartItemNew = [];



  // void addCartItem(FullCartModel model) {
  //   cartItem.add(model);
  //   notifyListeners();
  // }

  void addCartItem(ProductModel model) {
    cartItemNew.add(model);
    notifyListeners();
  }

  void updateCartItem(ProductModel model) {
    cartItemNew.remove(model);
    cartItemNew.add(model);
    notifyListeners();
  }

  void removeCartItem(ProductModel model) {
    cartItemNew.remove(model);
    notifyListeners();
  }

  void updateUserData(UserProfileModel model) {
    userData = model;
    notifyListeners();
  }

  void removeAppNotificationCount() {
    appNotificationCount = 0;
    notifyListeners();
  }

  int _counter = 0;
  int get counter => _counter;

  int _newCounter = 1;
  // int get newCounter => _newCounter;

  void newCounter(int newValue) {
    _newCounter = newValue;
    notifyListeners();
  }

  double _totalPrice = 0.0;
  int _quantityPrice = 0;
  int get quantityPrice => _quantityPrice;
  double get totalPrice => _totalPrice;
  bool branchIsSelected = false;
  String locationName;

  void getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    actualLocation = prefs.toString();
    notifyListeners();
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    prefs.setInt('quantity', _quantityPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    _quantityPrice = prefs.getInt('quantity') ?? 0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void setQuantity(int clickCounter) {
    _quantityPrice;
    _setPrefItems();
    notifyListeners();
  }

  int getQuantity() {
    _getPrefItems();
    return _quantityPrice;
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItems();
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  Future<List<ProductModel>> getCartItems() async {
    return cartItemNew;
  }

  double getCartTotal() {
    double total = 0;
    if (cartItemNew.isNotEmpty) {
      for (ProductModel item in cartItemNew) {
        total += item.total;
      }
    }
    return total;
  }



  int removerCounter() {
    _counter--;
    if (_counter < 1) {
      return 0;
    }
    _setPrefItems();
    notifyListeners();
  }

  void updateActualLocationName(String location) {
    locationName = location;
    notifyListeners();
  }

  void updateLocation(String locationName) {
    draggedLocation = locationName;
    notifyListeners();
  }

  int getCartCount() {
    return cartItemNew.length;
  }



  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;

  Position searchPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);

  void updateActualLocation(String locationName) {
    actualLocation = locationName;
    notifyListeners();
  }


  void updateActualCoordinates(Position position) {
    searchPosition = Position(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      heading: 1,
      accuracy: 1,
      altitude: 1,
      speedAccuracy: 1,
      speed: 1,
    );
    notifyListeners();
  }

}
