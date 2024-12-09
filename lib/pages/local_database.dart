import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import this
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fit_quest/pages/user_run.dart'; // Adjust path accordingly

class LocalDatabaseHelper {
  static final LocalDatabaseHelper instance = LocalDatabaseHelper._init();
  static Database? _database;

  LocalDatabaseHelper._init();

  // Initialize the databaseFactory for FFI use
  static void init() {
    databaseFactory = databaseFactoryFfi;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('user_run.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_runs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            workout_level TEXT,
            workout_time INTEGER,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUserRun(UserRun userRun) async {
    final db = await instance.database;
    try {
      final id = await db.insert('user_runs', userRun.toMap());
      return id;
    } catch (e) {
      print("Error inserting into SQLite: $e");
      rethrow;
    }
  }
}
