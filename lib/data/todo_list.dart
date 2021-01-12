import 'dart:convert';

class TodoList {
  final int id;
  final String listName;
  final String items;
  final String completed;
  final int count;
  final int color;
  int ordering;
  static const String TABLENAME = "todos";

  TodoList({
    this.id,
    this.listName,
    this.items,
    this.completed,
    this.count,
    this.color,
    this.ordering,
  });

  void setOrder(int newOrdering) {
    ordering = newOrdering;
  }

  factory TodoList.fromJson(Map<String, dynamic> jsonData) {
    return TodoList(
      listName: jsonData["listName"],
      items: jsonData["items"],
      completed: jsonData["completed"],
      count: jsonData["count"],
      color: jsonData["color"],
      ordering: jsonData["ordering"],
    );
  }

  static Map<String, dynamic> toMap(TodoList todoList) => {
        "id": todoList.id,
        "listName": todoList.listName,
        "items": todoList.items,
        "completed": todoList.completed,
        "count": todoList.count,
        "color": todoList.color,
        "ordering": todoList.ordering
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
