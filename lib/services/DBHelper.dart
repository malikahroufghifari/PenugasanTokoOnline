import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:penugasan_tokoonline/models/cart_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY,
        barang_id VARCHAR,
        title TEXT,
        quantity INTEGER,
        harga_beli REAL,
        image TEXT
      )
    ''');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    if (dbClient != null) {
      await dbClient.insert(
        'cart',
        cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return cart;
    } else {
      return cart;
    }
  }

  Future<List<Cart>> getCartList() async {
    try {
      var dbClient = await database;
      final List<Map<String, Object?>> queryResult = await dbClient!.query(
        'cart',
      );
      return queryResult.map((result) => Cart.fromMap(result)).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future getCartListDetail(id) async {
    try {
      var dbClient = await database;
      final queryResult = await dbClient!.query(
        'cart',
        where: 'id = ?',
        whereArgs: [id],
      );
      return queryResult.map((result) => Cart.fromMap(result)).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<int> updateQuantity(id, qty) async {
    var dbClient = await database;
    return await dbClient!.update(
      'cart',
      {"quantity": qty},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearCart() async {
    var dbClient = await database;
    return await dbClient!.delete('cart');
  }
}
