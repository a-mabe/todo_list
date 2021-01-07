import 'dart:convert';

class TodoItem {
  final int id;
  double xpos, ypos;
  final String icon, name;

  TodoItem({
    this.id,
    this.xpos,
    this.ypos,
    this.icon,
    this.name,
  });

  factory TodoItem.fromJson(Map<String, dynamic> jsonData) {
    return TodoItem(
      id: jsonData['id'],
      xpos: jsonData['xpos'],
      ypos: jsonData['ypos'],
      icon: jsonData['icon'],
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(TodoItem item) => {
        'id': item.id,
        'xpos': item.xpos,
        'ypos': item.ypos,
        'icon': item.icon,
        'name': item.name,
      };

  static String encode(List<TodoItem> items) => json.encode(
        items
            .map<Map<String, dynamic>>((item) => TodoItem.toMap(item))
            .toList(),
      );

  static List<TodoItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<TodoItem>((item) => TodoItem.fromJson(item))
          .toList();
}
