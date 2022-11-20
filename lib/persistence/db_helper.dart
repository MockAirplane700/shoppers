import 'package:path_provider/path_provider.dart';
import 'package:shoppers/objects/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null){
      return _database!;
    }//end if

    _database = await initDatabase();
    return null;
  }//end method

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }//end method

  // creating a database table
  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)'
    );
  }//end on create

  // insert data into the table
  Future<Cart> insert(Cart cart) async{
    var dbClient = await database;
    await dbClient?.insert('cart', cart.toMap());
    return cart;
  }//end method

  // getting all items from the list from the database
  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }//end get cart list

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    return await dbClient!.update('cart', cart.toMap(), where: "productId=?",
    whereArgs: [cart.productId]);
  }//end update quantity

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete(
      'cart', where: 'id=?', whereArgs: [id]
    );
  }//end delete cart item
}//end class