import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/data/models/task_model.dart';

sealed class TaskLocalRepository{
  String tableName = "tasks";
  Database? _database;
  Future<Database> _initDb();
  Future<void> insertTask(TaskModel task);
  Future<void> insertTasks(List<TaskModel> tasks);
  Future<List<TaskModel>?> getTasks();
  Future<bool> deleteTask(String taskId);
  Future<List<Map<String,dynamic>>> getUnSyncedTasks();
  Future<void> updateIsSynced(List<String> taskIds, {int value = 1});
  Future<Database> get database;
}

class TaskLocalRepositoryImpl extends TaskLocalRepository{

  @override
  Future<Database> get database async{
    if (_database != null){
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  @override
  Future<Database> _initDb()async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,"tasks.db");
    return openDatabase(path,version: 1,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            await db.execute(
              'DROP TABLE IF EXISTS $tableName',
            );
            db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            hexColor TEXT NOT NULL,
            uid TEXT NOT NULL,
            dueAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
         ''');
          }
        }, onConfigure: (db){
          return db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            hex_color TEXT NOT NULL,
            uid TEXT NOT NULL,
            dueAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
      ''');
        });
  }

  @override
  Future<void> insertTask(TaskModel task)async{
    final db = await database;
    await db.insert(tableName, task.toMap(requireCreatedAt: true,requireUpdatedAt: true,requireSynced: true), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> insertTasks(List<TaskModel> tasks)async{
    final db = await database;
    final batch = db.batch();
    for(TaskModel task in tasks){
      batch.insert(tableName, task.toMap(requireUpdatedAt: true,requireCreatedAt: true,requireSynced: true), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(noResult: true);
  }

  @override
  Future<List<TaskModel>?> getTasks()async{
    final db = await database;
    final tasks = await db.query(tableName);
    if(tasks.isNotEmpty){
      return tasks.map((task) => TaskModel.fromMap(task)).toList();
    }
    return null;
  }

  @override
  Future<bool> deleteTask(String taskId) async{
    final db = await database;
    final count = await db.delete(tableName, where: 'id=?', whereArgs: [taskId]);
    return count>0;
  }

  @override
  Future<List<Map<String,dynamic>>> getUnSyncedTasks() async {
    final db = await database;
    return await db.query(tableName,where: "isSynced = ?",whereArgs: [0]);
  }

  @override
  Future<void> updateIsSynced(List<String> taskIds, {int value = 1})async{
    final db = await database;
    final batch = db.batch();
    for(String taskId in taskIds){
      batch.update(tableName, {'isSynced':value},where: 'id=?',whereArgs: [taskId]);
    }
    batch.commit(noResult: true);
  }
}