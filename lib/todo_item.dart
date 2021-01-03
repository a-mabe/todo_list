import 'dart:convert';

class TodoItem {
  final int id;
  final double xpos, ypos;
  final String icon;

  TodoItem({
    this.xpos,
    this.ypos,
    this.icon,
    this.id,
  });

  factory TodoItem.fromJson(Map<String, dynamic> jsonData) {
    return TodoItem(
      xpos: jsonData['xpos'],
      ypos: jsonData['ypos'],
      icon: jsonData['icon'],
      id: jsonData['id'],
    );
  }

  static Map<String, dynamic> toMap(TodoItem item) => {
        'xpos': item.xpos,
        'ypos': item.ypos,
        'icon': item.icon,
        'id': item.id,
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
