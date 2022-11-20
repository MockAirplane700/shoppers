import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppers/objects/cart.dart';
import 'package:shoppers/persistence/db_helper.dart';

class CartProvider with ChangeNotifier{
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity=> _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  Future<List<Cart>> getData() async{
    cart = await dbHelper.getCartList();
    notifyListeners();
    return cart;
  }//end method

  void _setPrefsItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('cart_items', _counter);
    preferences.setInt('item_quantity', _quantity);
    preferences.setDouble('total_price', _totalPrice);
  }//end method

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }// end add counter

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }//end remove counter

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }//end get counter

  void addQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity.value +=1;
    _setPrefsItems();
    notifyListeners();
  }//end add quantity

  void deleteQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity.value;
    if (currentQuantity <= 1){
      currentQuantity == 1;
    }else{
      cart[index].quantity.value = currentQuantity - 1;
    }//end if-else

    _setPrefsItems();
    notifyListeners();
  }//end delete quantity

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id );
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }//end remove item

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }//end get quantity

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }//end add total price

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefsItems();
    notifyListeners();
  }//end remove total price

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }//end get total price
}//end class