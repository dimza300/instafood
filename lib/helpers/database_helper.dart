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
      'title': 'Title 1',
      'subtitle': 'Subtitle 1',
      'description': 'Description 1',
      'file_image': 'https://via.placeholder.com/150',
      'rating': 5
    });
    await db.insert('content', {
      'title': 'Title 2',
      'subtitle': 'Subtitle 2',
      'description': 'Description 2',
      'file_image': 'https://via.placeholder.com/150',
      'rating': 4
    });
    await db.insert('content', {
      'title': 'Title 3',
      'subtitle': 'Subtitle 3',
      'description': 'Description 3',
      'file_image': 'https://via.placeholder.com/150',
      'rating': 3
    });
    await db.insert('content', {
      'title': 'Title 4',
      'subtitle': 'Subtitle 4',
      'description': 'Description 4',
      'file_image': 'https://via.placeholder.com/150',
      'rating': 4
    });
    await db.insert('content', {
      'title': 'Title 5',
      'subtitle': 'Subtitle 5',
      'description': 'Description 5',
      'file_image': 'https://via.placeholder.com/150',
      'rating': 5
    });
    await db.insert('content', {
      'title': 'Title 6',
      'subtitle': 'Subtitle 6',
      'description': 'Description 6',
      'file_image': 'https://via.placeholder.com/150',
      'rating': 3
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
