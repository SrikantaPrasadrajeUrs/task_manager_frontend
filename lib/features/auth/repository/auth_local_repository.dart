import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/data/models/user_model.dart';

sealed class AuthLocalRepository{
  String tableName = "users";
  Database? _database;
  Future<Database> _initDb();
  Future<void> insertUser(UserModel user);
  Future<UserModel?> getUser();
  Future<Database> get database;
}

class AuthLocalRepositoryImpl extends AuthLocalRepository{

  @override
  Future<Database> get database async{
    if (_database != null){
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  @override
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "auth.db");
    return openDatabase(
      path,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('DROP TABLE IF EXISTS $tableName');
          await db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
        }
      },
      onConfigure: (db) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableName(
          id TEXT PRIMARY KEY,
          email TEXT NOT NULL,
          token TEXT NOT NULL,
          name TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');
      },
    );
  }


  @override
  Future<void> insertUser(UserModel user)async{
    final db = await database;
    db.insert(tableName, user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<UserModel?> getUser()async{
    final db = await database;
    final user = await db.query(tableName,limit: 1);
    if (user.isNotEmpty){
      return UserModel.fromMap(user.first);
    }
    return null;
  }
}