import 'dart:collection';
import 'dart:convert';

import 'package:todo_list/todo_item.dart';
import 'package:todo_list/data/icon_names.dart';
import 'package:todo_list/addItem.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() => runApp(MyApp());

/// List of todo item widgets.
List<Widget> todoList = [];

/// List of completed todo item widgets.
List<Widget> doneList = [];

/// List of todo items. Used to store and load the
/// todo list from disk.
List<TodoItem> todoItems = [];

/// List of completed todo items. Used to store and load the
/// completed items from disk.
List<TodoItem> doneItems = [];

/// The number of total todo items that have existed in the list,
/// whether completed or uncompleted.
int itemCount = 0;

/// Value notifier for the todo list. Increments whenever something
/// is added to the list to change the widget Stack state.
final todo = new ValueNotifier<int>(todoList.length);

/// Value notifier for the done list.
final done = new ValueNotifier<int>(doneList.length);

/// Maps the ID of each todo item to its location in the list.
Map<int, int> todoMap = HashMap();

/// Maps the ID of each completed todo item to its location in the list.
Map<int, int> doneMap = HashMap();

/// Random number generator to randomly select an image from the list.
final _random = new Random();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Draggable',
        home: HomeView(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Color(0xffff8066),
          accentColor: Color(0xff00c29a),
          primaryColorLight: Color(0xffff8066).withOpacity(0.4),
          backgroundColor: Color(0xff00c29a).withOpacity(0.4),

          // Define the default font family.
          fontFamily: 'Arial',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          primaryTextTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            headline6: TextStyle(fontSize: 24.0, color: Colors.grey),
            bodyText2: TextStyle(
                fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey),
          ),
        ));
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

List<String> images = [
  "images/sink.png",
  "images/mop.png",
  "images/walk_dog.png",
  "images/iron.png",
  "images/homework_blue.png",
  "images/homework_purple.png",
  "images/sweep.png",
  "images/wash_car.png",
  "images/wash_clothes.png",
  "images/email.png",
  "images/feed_dog.png",
  "images/trash.png",
  "images/grocery_shopping.png",
  "images/dishes.png",
  "images/dust.png",
  "images/vacuum.png",
  "images/toilet.png",
  "images/homework_red.png",
  "images/fold_laundry.png",
  "images/tub.png",
  "images/lightbulb.png",
  "images/homework_green.png"
];

/// -------------------------------------------------------
///
/// The main screen to display a todo list with a todo side
/// and a done side.
///
/// -------------------------------------------------------
class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    loadLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchList()));

              /*
              // Random index in the range [0, 20) to pick an image from
              // the list of possible icons.
              String image = images[next(0, 22)];

              /// Add an item to the list of todo item widgets.
              todoList.add(MoveableStackItem(
                  80, 300, true, itemCount, image, UniqueKey()));

              /// Set the [itemCount] to correspond to the location in [todoList].
              todoMap[itemCount] = todoList.length - 1;

              /// Add the [TodoItem] to [todoItems].
              addTodoList("gshopping", 80, 300, image, itemCount);

              /// Increment the count since an item has been added.
              itemCount++;
              */
            });
          },
        ),
        body:
            // --------------------------
            // Add padding.
            // --------------------------
            new Container(
                padding: const EdgeInsets.only(
                  left: 9,
                  top: 60,
                  right: 9,
                  bottom: 20,
                ),
                // --------------------------
                // Row to display the side by side containers.
                // --------------------------
                child: Row(
                  // --------------------------
                  // List of the two side by side containers
                  // as children of the Row.
                  // --------------------------
                  children: <Widget>[
                    // --------------------------
                    // Expanded to fill up appr. half the screen.
                    // --------------------------
                    Expanded(
                      // --------------------------
                      // Contents of Expanded will update each
                      // time a value is updated.
                      // --------------------------
                      child: ValueListenableBuilder<int>(
                        valueListenable:
                            todo, // Rebuild each time an item is added.
                        builder: (context, value, child) {
                          // Builder: Content to be rebuilt.
                          // --------------------------
                          // Fractionally sized to fill entire space given.
                          // --------------------------
                          return FractionallySizedBox(
                            alignment: Alignment
                                .centerLeft, // Doesn't matter, take up all space anyways.
                            widthFactor: 1, // Take up all possible space.
                            // --------------------------
                            // Container to manage the actual todo stack.
                            // --------------------------
                            child: Container(
                              child: Stack(
                                children: todoList, // The list of todo widgets.
                              ),
                              height: 1000, // Take up a lot of the screen.
                              margin: const EdgeInsets.all(6),
                              // --------------------------
                              // --------------------------
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              // --------------------------
                              // --------------------------
                            ),
                          );
                        },
                      ),
                    ),
                    // --------------------------
                    // Expanded to fill up appr. half the screen.
                    // --------------------------
                    Expanded(
                      // --------------------------
                      // Contents of Expanded will update each
                      // time a value is updated.
                      // --------------------------
                      child: ValueListenableBuilder<int>(
                        valueListenable: done,
                        builder: (context, value, child) {
                          // --------------------------
                          // Fractionally sized to fill entire space given.
                          // --------------------------
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 1,
                            // --------------------------
                            // Container to manage the actual todo stack.
                            // --------------------------
                            child: Container(
                              child: Stack(
                                children: doneList,
                              ),
                              height: 1000,
                              margin: const EdgeInsets.all(6),
                              // --------------------------
                              // --------------------------
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 3,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              // --------------------------
                              // --------------------------
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )));
  }
}

void loadLists() async {
  // Obtain shared preferences
  final prefs = await SharedPreferences.getInstance();

  //prefs.clear();

  // Try reading data from the key. If it doesn't exist, return empty list.
  String fetchedToDoList = prefs.getString('todo') ?? "";

  List<TodoItem> decodedData = [];

  if (fetchedToDoList != "") decodedData = TodoItem.decode(fetchedToDoList);
  todoItems = decodedData;

  for (TodoItem item in todoItems) {
    /// Add an item to the list of todo item widgets.
    todoList.add(MoveableStackItem(
        item.xpos, item.ypos, true, itemCount, item.icon, UniqueKey()));

    /// Set the [itemCount] to correspond to the location in [todoList].
    todoMap[itemCount] = todoList.length - 1;

    /// Increment the count since an item has been added.
    itemCount++;
    todo.value++;
  }

  //----------------------------------------------------------------------

  // Try reading data from the key. If it doesn't exist, return empty list.
  String fetchedDoneList = prefs.getString('done') ?? "";

  List<TodoItem> decodedDone = [];

  if (fetchedDoneList != "") decodedDone = TodoItem.decode(fetchedDoneList);
  doneItems = decodedDone;

  for (TodoItem item in doneItems) {
    /// Add an item to the list of todo item widgets.
    doneList.add(MoveableStackItem(
        item.xpos, item.ypos, false, itemCount, item.icon, UniqueKey()));

    /// Set the [itemCount] to correspond to the location in [doneList].
    doneMap[itemCount] = doneList.length - 1;

    /// Increment the count since an item has been added.
    itemCount++;
    done.value++;
  }
}

/// -------------------------------------------------------
/// Adds a todo item to the todo list to be stored on disk. The [xpos] and
/// [ypos] parameters are set so that the icons load exactly where the user
/// left them. [title] and [icon] are also set to display the proper item.
/// To keep track of which item it is, [id] is also set.
///
/// Example todo list structure with grocery shopping entry:
///
/// "todoList": [ "gshopping": {"xpos": "100",
///                             "ypos": "100",
///                             "icon": "images/grocery_shopping.png",
///                             "id": "2"}
///             ]
/// -------------------------------------------------------
void addTodoList(
    String title, double xpos, double ypos, String icon, int id) async {
  // Obtain shared preferences
  final prefs = await SharedPreferences.getInstance();

  todoItems.add(TodoItem(id: id, xpos: xpos, ypos: ypos, icon: icon));

  final String encodedData = TodoItem.encode(todoItems);

  prefs.setString('todo', encodedData);
}

/// -------------------------------------------------------
///
/// -------------------------------------------------------
void saveListStates() async {
  // Obtain shared preferences
  final prefs = await SharedPreferences.getInstance();

  final String encodedTodo = TodoItem.encode(todoItems);
  final String encodedDone = TodoItem.encode(doneItems);

  prefs.setString('todo', encodedTodo);
  prefs.setString('done', encodedDone);
}

/// -------------------------------------------------------
/// Adds a todo item to the todo list to be stored on disk. The [xpos] and
/// [ypos] parameters are set so that the icons load exactly where the user
/// left them. [title] and [icon] are also set to display the proper item.
/// To keep track of which item it is, [id] is also set.
///
/// Example todo list structure with grocery shopping entry:
///
/// "todoList": [ "gshopping": {"xpos": "100",
///                             "ypos": "100",
///                             "icon": "images/grocery_shopping.png",
///                             "id": "2"}
///             ]
/// -------------------------------------------------------
void addDoneList(
    String title, double xpos, double ypos, String icon, int id) async {
  // Obtain shared preferences
  final prefs = await SharedPreferences.getInstance();

  doneItems.add(TodoItem(id: id, xpos: xpos, ypos: ypos, icon: icon));

  final String encodedData = TodoItem.encode(doneItems);

  prefs.setString('done', encodedData);
}

/// -------------------------------------------------------
///
/// -------------------------------------------------------
class MoveableStackItem extends StatefulWidget {
  MoveableStackItem(this.xPosition, this.yPosition, this.isTodo, this.id,
      this.imageSource, this.key);

  double xPosition;
  double yPosition;
  bool isTodo;
  int id;
  Key key;
  String imageSource;

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState(
        xPosition, yPosition, isTodo, id, imageSource, key);
  }
}

/// -------------------------------------------------------
///
/// -------------------------------------------------------
class _MoveableStackItemState extends State<MoveableStackItem> {
  _MoveableStackItemState(this.xPosition, this.yPosition, this.isTodo, this.id,
      this.imageSource, this.key);

  double xPosition;
  double yPosition;
  bool isTodo;
  int id;
  Key key;
  String imageSource;

  // Set to true if an icon has hit the edge to be passed to the other list.
  // Prevents the item from being transferred more than once in a row.
  bool hitEdge = false;

  bool transferred = false;

  var selected;

  @override
  void initState() {
    super.initState();
  }

  void _showPopupMenu(Offset offset) async {
    // Get the width of the screen.
    double width = MediaQuery.of(context).size.width;
    // Get the height of the screen.
    double height = MediaQuery.of(context).size.height - kToolbarHeight;

    double left = offset.dx;
    double top = offset.dy;

    selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 100000, 0),
      items: [
        PopupMenuItem(
          child: Center(
            child: Text(
              names[imageSource],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
            ),
          ),
          enabled: false,
        ),
        PopupMenuItem(
          child: Center(
              child: Column(
            children: [
              Image.asset(
                imageSource,
                width: 50.0,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 0,
                  top: 14,
                  right: 0,
                  bottom: 0,
                ),
              ),
              Text(
                "Edit",
                style: TextStyle(color: Colors.black87),
              ),
            ],
          )),
        ),
        PopupMenuItem(
          child: Center(
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
          value: 1,
        ),
      ],
      elevation: 8.0,
    );

    switch (selected) {
      case 0:

      case 1:
        print("You selected Delete.");
        if (isTodo) {
          // ---------------------------
          // Remove the item from the todo side.
          // ---------------------------
          int location = todoMap[id];
          todoList.removeAt(location);
          todoItems.removeAt(location);
          todoMap.remove(id);
          // ---------------------------

          // ---------------------------
          // Update the key map.
          // ---------------------------
          for (int key in todoMap.keys) {
            if (todoMap[key] > location) todoMap[key] = todoMap[key] - 1;
          }
          // ---------------------------

          todo.value--;
        } else {
          // ---------------------------
          // Remove the item from the done side.
          // ---------------------------
          int location = doneMap[id];
          doneList.removeAt(location);
          doneItems.removeAt(location);
          doneMap.remove(id);
          // ---------------------------

          // ---------------------------
          // Update the key map.
          // ---------------------------
          for (int key in doneMap.keys) {
            if (doneMap[key] > location) {
              doneMap[key] = doneMap[key] - 1;
            }
          }
          // ---------------------------

          done.value--;
        }
        saveListStates();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen.
    double width = MediaQuery.of(context).size.width;
    // Get the height of the screen.
    double height = MediaQuery.of(context).size.height - kToolbarHeight;

    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          print("tap");
          _showPopupMenu(details.globalPosition);
        },
        onPanUpdate: (tapInfo) {
          setState(() {
            // Update the position of the widget.
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;

            // If the widget is being dragged past the bottom.
            if (yPosition > (height - 92)) {
              yPosition = (height - 92);
            }
            // If the widget is being dragged past the top.
            if (yPosition < 0) {
              yPosition = 0;
            }
            // If the widget is being dragged to the left and is a completed item.
            // This means the item is being dragged back on the todo side.
            if (xPosition < -15 && !isTodo) {
              xPosition = -15;

              // If it is the first time the widget is being bumped to the lefthand side.
              if (!hitEdge && !isTodo) {
                setState(() {
                  transferred = true;

                  // ---------------------------
                  // Remove the item from the done side.
                  // ---------------------------
                  int location = doneMap[id];
                  doneList.removeAt(location);
                  doneItems.removeAt(location);
                  doneMap.remove(id);
                  // ---------------------------

                  // ---------------------------
                  // Update the key map.
                  // ---------------------------
                  for (int key in doneMap.keys) {
                    if (doneMap[key] > location) {
                      doneMap[key] = doneMap[key] - 1;
                    }
                  }
                  // ---------------------------

                  // ---------------------------
                  // Add the widget onto the todo list.
                  // ---------------------------
                  todoList.add(MoveableStackItem(((width - 180) / 2), yPosition,
                      true, id, imageSource, UniqueKey()));
                  todoItems.add(TodoItem(
                      id: id,
                      xpos: xPosition,
                      ypos: yPosition,
                      icon: imageSource));
                  // ---------------------------

                  // Make an entry for that item in the map.
                  todoMap[id] = todoList.length - 1;

                  // Update values to refresh UI.
                  done.value--;
                  todo.value++;
                });
              }

              hitEdge = true;
            }
            // If we're on the todo side, just keep the widget in the boundary.
            else if (xPosition < 0 && isTodo) {
              xPosition = 0;
            }

            // If the widget is being dragged to the right and is an uncompleted item.
            // This means the item is being dragged onto the done side.
            if (xPosition > ((width - 105) / 2) && isTodo) {
              xPosition = ((width - 105) / 2);

              // If it is the first time the widget is being bumped to the righthand side.
              if (!hitEdge && isTodo) {
                setState(() {
                  transferred = true;

                  // ---------------------------
                  // Remove the item from the todo side.
                  // ---------------------------
                  int location = todoMap[id];
                  todoList.removeAt(location);
                  todoItems.removeAt(location);
                  todoMap.remove(id);
                  // ---------------------------

                  // ---------------------------
                  // Update the key map.
                  // ---------------------------
                  for (int key in todoMap.keys) {
                    if (todoMap[key] > location)
                      todoMap[key] = todoMap[key] - 1;
                  }
                  // ---------------------------

                  // ---------------------------
                  // Add the widget onto the done list.
                  // ---------------------------
                  doneList.add(MoveableStackItem((xPosition - (xPosition - 3)),
                      yPosition, false, id, imageSource, UniqueKey()));
                  doneItems.add(TodoItem(
                      id: id,
                      xpos: xPosition,
                      ypos: yPosition,
                      icon: imageSource));
                  // ---------------------------

                  // Make an entry for that item in the map.
                  doneMap[id] = doneList.length - 1;

                  // Update values to refresh UI.
                  done.value++;
                  todo.value--;
                });
              }

              hitEdge = true;
            }
            // If we're on the done side, just keep the widget in the boundary.
            else if (xPosition > ((width - 170) / 2) && !isTodo) {
              xPosition = ((width - 170) / 2);
            }
          });
        },
        onPanEnd: (tapInfo) {
          hitEdge = false;

          if (isTodo && !transferred) {
            todoItems[todoMap[id]].xpos = xPosition;
            todoItems[todoMap[id]].ypos = yPosition;
          } else if (!isTodo && !transferred) {
            doneItems[doneMap[id]].xpos = xPosition;
            doneItems[doneMap[id]].ypos = yPosition;
          }

          saveListStates();
        },
        child: DragItem(imageSource),
      ),
    );
  }
}

///
/// Generates a positive random integer uniformly distributed on the range
/// from [min], inclusive, to [max], exclusive.
///
int next(int min, int max) => min + _random.nextInt(max - min);

///
/// The child of the draggable widget.
///
class DragItem extends StatelessWidget {
  DragItem(this.imageSource);

  String imageSource;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageSource,
      width: 50.0,
    );
  }
}
