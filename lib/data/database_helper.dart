import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_list/data/todo_list.dart';
import 'package:todo_list/view_list.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'todos_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      // Possible fix for iOS issue (did not work)
      if (Platform.isIOS) {
        await db.execute('PRAGMA sqflite -- db_config_defensive_off');
      }

      await db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, listName TEXT, items TEXT, completed TEXT, count INTEGER, color INTEGER, ordering INTEGER)");
    });
  }

  Future<List<TodoList>> retrieveTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TodoList.TABLENAME);

    return List.generate(maps.length, (i) {
      return TodoList(
        id: maps[i]["id"],
        listName: maps[i]["listName"],
        items: maps[i]["items"],
        completed: maps[i]["completed"],
        count: maps[i]["count"],
        color: maps[i]["color"],
        ordering: maps[i]["ordering"],
      );
    });
  }

  insertTodo(TodoList todoList) async {
    final db = await database;
    await db.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO todos(listName, items, completed, count, color, ordering) VALUES(?, ?, ?, ?, ?, ?)',
          [
            todoList.listName,
            todoList.items,
            todoList.completed,
            todoList.count,
            todoList.color,
            todoList.ordering
          ]);

      /*await txn.insert(TodoList.TABLENAME, TodoList.toMap(todoList),
          conflictAlgorithm: ConflictAlgorithm.replace);*/
    });
    //return res;
  }

  updateTodo(TodoList todoList) async {
    final db = await database;

    await db.update(TodoList.TABLENAME, TodoList.toMap(todoList),
        where: "id = ?",
        whereArgs: [todoList.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteTodo(int id) async {
    var db = await database;
    db.delete(TodoList.TABLENAME, where: "id = ?", whereArgs: [id]);
  }
}
