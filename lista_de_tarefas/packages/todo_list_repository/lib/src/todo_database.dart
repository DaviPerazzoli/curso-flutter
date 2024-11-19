import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo_model.dart';


class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB('todo_list.db');
    return _database!;
  }

  Future<Database> _initDB (String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB (Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const dateTimeType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE tasks (
        id $idType,
        title $textType,
        description TEXT,
        creationDate $dateTimeType,
        dueDate TEXT,
        done $boolType
      )
    ''');
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  Future<int> createTask(Task task) async {
    try {
      final db = await database;
      final id = db.insert('tasks', task.toMap());
      return id;
    } on DatabaseException catch(e) {
      log('Erro com o banco de dados: $e');
      return -1;
    } on Exception catch(e) {
      log('Erro desconhecido: $e');
      return -1;
    }
  }

  Future<TaskList> getAllTasks() async {
    try {
      final db = await database;
      final result = await db.query('tasks');
      return TaskList(result.map( (json) => Task.fromMap(json)).toList());
    } on DatabaseException catch (e) {
      log('Erro com o banco de dados: $e');
      return TaskList.empty();
    } on Exception catch(e) {
      log('Erro desconhecido: $e');
      return TaskList.empty();
    }
  }

  Future<int> updateTask(Task task) async {
    try{
      final db = await database;
      return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    } on DatabaseException catch(e) {
      log('Erro com o banco de dados: $e');
      return -1;
    } on Exception catch(e) {
      log('Erro desconhecido: $e');
      return -1;
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } on DatabaseException catch(e) {
      log('Erro com o banco de dados: $e');
      return -1;
    } on Exception catch(e) {
      log('Erro desconhecido: $e');
      return -1;
    }
  }
}
