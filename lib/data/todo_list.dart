import 'dart:convert';

import 'package:todo_list/data/todo_item.dart';

class TodoList {
  final int id;
  final String listName;
  final String items;
  final String completed;
  final int count;
  static const String TABLENAME = "todos";

  TodoList({
    this.id,
    this.listName,
    this.items,
    this.completed,
    this.count,
  });

  factory TodoList.fromJson(Map<String, dynamic> jsonData) {
    return TodoList(
      listName: jsonData["listName"],
      items: jsonData["items"],
      completed: jsonData["completed"],
      count: jsonData["count"],
    );
  }

  static Map<String, dynamic> toMap(TodoList todoList) => {
        "id": todoList.id,
        "listName": todoList.listName,
        "items": todoList.items,
        "completed": todoList.completed,
        "count": todoList.count,
      };

  static String encode(List<TodoList> todoList) => json.encode(
        todoList
            .map<Map<String, dynamic>>((item) => TodoList.toMap(item))
            .toList(),
      );

  static List<TodoList> decode(String todoList) =>
      (json.decode(todoList) as List<dynamic>)
          .map<TodoList>((item) => TodoList.fromJson(item))
          .toList();
}
