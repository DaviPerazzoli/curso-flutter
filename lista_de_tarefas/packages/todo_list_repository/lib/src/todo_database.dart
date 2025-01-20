import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todo_list.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textNotnullType = 'TEXT NOT NULL';
    const textType = 'TEXT';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE taskLists (
        id $idType,
        name $textNotnullType,
        color $intType
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks (
        id $idType,
        title $textNotnullType,
        description $textType,
        creationDate $textNotnullType,
        dueDate $textType,
        done $boolType,
        taskListId $intType,
        FOREIGN KEY (taskListId) REFERENCES taskLists(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _upgradeDB (Database db, int oldVersion, int newVersion) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textNotnullType = 'TEXT NOT NULL';
    const textType = 'TEXT';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';
    if (oldVersion == 1) {
      //* Cria a nova tabela taskLists
      await db.execute('''
        CREATE TABLE taskLists (
          id $idType,
          name $textNotnullType,
          color $intType
        )
      ''');

      // 2. Inserir uma lista padrão para associar às tasks existentes
      await db.insert('taskLists', {'name': 'Default', 'color': 0xFFFFFF});

      // 3. Criar uma nova tabela tasks com a foreign key
      await db.execute('''
        CREATE TABLE tasks_new (
          id $idType,
          title $textNotnullType,
          description $textType,
          creationDate $textNotnullType,
          dueDate $textType,
          done $boolType,
          taskListId $intType,
          FOREIGN KEY (taskListId) REFERENCES taskLists(id) ON DELETE CASCADE
        )
      ''');

      //* Migrar os dados da tabela antiga (tasks) para a nova tabela
      await db.execute('''
        INSERT INTO tasks_new (id, title, description, creationDate, dueDate, done, taskListId)
        SELECT id, title, description, creationDate, dueDate, done, 1 as taskListId
        FROM tasks;
      ''');

      //* Excluir a tabela antiga
      await db.execute('DROP TABLE tasks');

      //* Renomear a nova tabela para 'tasks'
      await db.execute('ALTER TABLE tasks_new RENAME TO tasks');
    }
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  Future<int> createTask(Task task) async {
    final db = await database;
    final id = db.insert('tasks', task.toMap());
    return id;
  }

  Future<int> createTaskList(TaskList taskList) async {
    final db = await database;
    final id = db.insert('taskLists', taskList.toMap());
    return id;
  }

  Future<TaskList?> getTaskList(int taskListId) async {
    final db = await database;
    final result = await db.query('tasks');
    List<Task> tasks = [];
    for (var map in result) {
      if (map["taskListId"] == taskListId) {
        tasks.add(Task.fromMap(map));
      }
    }

    final taskLists = await db.query('taskLists');
    for (var map in taskLists) {
      if (map["id"] == taskListId) {
        return TaskList.fromMap(map, tasks);
      }
    }

    return null;
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> updateTaskList(TaskList taskList) async {
    final db = await database;
    return await db.update('taskLists', taskList.toMap(), where: 'id = ?', whereArgs: [taskList.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTaskList(int id) async {
    final db = await database;
    return await db.delete(
      'taskLists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTasks() async {
    final db = await database;
    await db.delete('tasks');
    await db.execute('DELETE FROM sqlite_sequence WHERE name = "tasks"');
  }

  Future<List<TaskList>> getAllTaskLists () async {
    final db = await database;
    final result = await db.query('taskLists');
    List<TaskList> allTaskLists = [];
    for(var map in result) {

      allTaskLists.add((await getTaskList(map['id'] as int))!);

    }

    return allTaskLists;
  }

  // ignore: unused_element
  Future<void> _debugDB() async {
  final db = await database;

  final taskLists = await db.query('taskLists');
  log('TASK LISTS:');
  for (var taskList in taskLists) {
    log('\t$taskList');
  }

  final tasks = await db.query('tasks');
  log('TASKS:');
  for (var task in tasks) {
    log('\t$task');
  }
}

}
