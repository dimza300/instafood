import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE content (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        description TEXT NOT NULL,
        file_image TEXT NOT NULL,
        rating INTEGER NOT NULL
      )
    ''');

    await db.insert('user', {'username': 'admin', 'password': 'admin'});

    await db.insert('content', {
      'title': 'Seblak Komplit',
      'subtitle': 'Jl. Baru ',
      'description':
          'seblak komplit , kerupuk, telor, sosis, baso, cuangki lidah, batagor kering, kwetiaw, sayuran',
      'file_image': '1.jpeg',
      'rating': 5
    });
    await db.insert('content', {
      'title': 'Seblak Ceker',
      'subtitle': 'Jl. Baru',
      'description': 'isian seperti seblak komplit ditambah ceker 3 biji',
      'file_image': '2.jpeg',
      'rating': 4
    });
    await db.insert('content', {
      'title': 'Seblak Seafood',
      'subtitle': 'Jl. Baru',
      'description':
          ' isian seperti seblak komplit ditambah seafood dumpling keju dan ayam, tofu, krab stik',
      'file_image': '3.jpeg',
      'rating': 3
    });
    await db.insert('content', {
      'title': 'Mie Setan',
      'subtitle': 'Jl. Baru',
      'description': 'mie goreng pedas dengan tambahan telor, batagor kering, dan tulang',
      'file_image': '4.jpeg',
      'rating': 4
    });
    await db.insert('content', {
      'title': 'Ceker Mercon',
      'subtitle': 'Jl. Baru',
      'description': 'isian ceker 10 biji dengan kuah pedas ditambah toping batagor kering',
      'file_image': '5.jpeg',
      'rating': 2
    });
    await db.insert('content', {
      'title': 'Baso Aci',
      'subtitle': 'Jl. Baru',
      'description':
          'isian baso aci besar 1, baso aci kecil 5, dengan kuah gurih ditambah cuangki lidah, batagor kering, dan pilus cikur',
      'file_image': '6.jpeg',
      'rating': 1
    });
  }

  Future<Map?> getUser(String username, String password) async {
    Database db = await database;
    List<Map> results = await db.query(
      'user',
      columns: ['id', 'username', 'password'],
      where: 'username = ? and password = ?',
      whereArgs: [username, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getContent() async {
    final db = await database;
    return await db.query('content');
  }

  Future<Map?> getUserActive() async {
    Database db = await database;
    List<Map> results = await db.query(
      'user',
      columns: ['id', 'username', 'password'],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final db = await database;
    List<Map> userData = await db.query(
      'user',
      columns: ['id', 'username', 'password'],
    );

    if (userData.isNotEmpty) {
      var dataUser = userData.first;
      String username = dataUser['username'];
      int count = await db.rawUpdate(
        'UPDATE user SET password = ? WHERE username = ?',
        [newPassword, username],
      );

      if (count == 0) {
        throw Exception('Password lama tidak sesuai');
      }
    }
  }
}
