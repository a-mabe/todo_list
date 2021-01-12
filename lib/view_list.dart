import 'dart:collection';

import 'package:todo_list/data/todo_item.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/addItem.dart';
import 'package:todo_list/data/database_helper.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:todo_list/data/todo_list.dart';

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
final todo = new ValueNotifier<int>(0);

/// Value notifier for the done list.
final done = new ValueNotifier<int>(0);

/// Maps the ID of each todo item to its location in the list.
Map<int, int> todoMap = HashMap();

/// Maps the ID of each completed todo item to its location in the list.
Map<int, int> doneMap = HashMap();

/// Random number generator to randomly select an image from the list.
final _random = new Random();

int todoListID, todoListColor, todoListOrder;
String todoListName = "";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeView(
        newImage: "",
        title: "",
        listName: "",
        order: 0,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  final String newImage, title, listName;
  final int order;

  HomeView(
      {Key key,
      @required this.newImage,
      @required this.title,
      @required this.listName,
      @required this.order})
      : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState(
      key: key,
      newImage: newImage,
      title: title,
      listName: listName,
      order: order);
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

Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) =>
        SearchList(listName: todoListName, order: todoListOrder),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createHomeRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// -------------------------------------------------------
///
/// The main screen to display a todo list with a todo side
/// and a done side.
///
/// -------------------------------------------------------
class _HomeViewState extends State<HomeView> {
  String newImage, title, listName;
  int order;

  _HomeViewState(
      {Key key,
      @required this.newImage,
      @required this.title,
      @required this.listName,
      @required this.order});

  @override
  void initState() {
    super.initState();
    print("init");
    print(newImage);
    print(title);
    print(listName);
    print(order);
    loadLists(newImage, title, listName, order);
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).push(_createHomeRoute());
    return true;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes, delete"),
      onPressed: () {
        DatabaseHelper.instance.deleteTodo(todoListID);
        Navigator.of(context).pop();
        Navigator.of(context).push(_createHomeRoute());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting To-do List"),
      content:
          Text("Are you sure you want to delete \"" + todoListName + "\"?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Delete To-do List':
        print("delete");

        showAlertDialog(context);

        //await DatabaseHelper.instance.deleteTodo(todoListID);
        break;
      case 'Settings':
        print("Setting");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  //saveListStates();
                  Navigator.of(context).push(_createRoute());
                });
              },
            ),
            appBar: new AppBar(
              backgroundColor: Colors.white,
              title: new Text(
                listName,
                style: new TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
              ),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {"Settings", "Delete To-do List"}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: (choice == "Delete To-do List")
                            ? Text(choice,
                                style: TextStyle(
                                  color: Colors.red,
                                ))
                            : Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
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
                                    children:
                                        todoList, // The list of todo widgets.
                                  ),
                                  height: 1000, // Take up a lot of the screen.
                                  margin: const EdgeInsets.all(6),
                                  // --------------------------
                                  // --------------------------
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  // --------------------------
                                  // --------------------------
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ))));
  }
}

void loadLists(
    String newImage, String title, String listName, int order) async {
  //String encodedData = TodoItem.encode(todoItems);

  //await DatabaseHelper.instance.insertTodo(TodoList(
  //listName: "test_list", items: encodedData, count: todoItems.length));

  todoList = [];
  doneList = [];

  List<TodoList> todos = await DatabaseHelper.instance.retrieveTodos();
  todoListName = listName;
  todoListOrder = order;
  print("The todolist name is: ");
  print(todoListName);
  print(todoListOrder);

  if (todos != null) {
    for (int i = 0; i < todos.length; i++) {
      if (todos[i].ordering == todoListOrder) {
        List<TodoItem> decodedTodo = TodoItem.decode(todos[i].items);
        print("Got the todos and the name is...");
        print(todoListName);
        List<TodoItem> decodedDone = TodoItem.decode(todos[i].completed);
        print("Got the completed");
        todoItems = decodedTodo;
        doneItems = decodedDone;
        todoListID = todos[i].id;
        todoListColor = todos[i].color;
        //todoListOrder = todos[i].order;
        break;
      }
    }

    for (TodoItem item in todoItems) {
      /// Add an item to the list of todo item widgets.
      todoList.add(MoveableStackItem(item.xpos, item.ypos, true, itemCount,
          item.icon, UniqueKey(), item.name));

      /// Set the [itemCount] to correspond to the location in [todoList].
      todoMap[itemCount] = todoList.length - 1;

      /// Increment the count since an item has been added.
      itemCount++;
      todo.value++;
    }

    for (TodoItem item in doneItems) {
      /// Add an item to the list of todo item widgets.
      doneList.add(MoveableStackItem(item.xpos, item.ypos, false, itemCount,
          item.icon, UniqueKey(), item.name));

      /// Set the [itemCount] to correspond to the location in [doneList].
      doneMap[itemCount] = doneList.length - 1;

      /// Increment the count since an item has been added.
      itemCount++;
      done.value++;
    }

    if (newImage != "") {
      /// Add an item to the list of todo item widgets.
      todoList.add(MoveableStackItem(
          80, 300, true, itemCount, newImage, UniqueKey(), title));
      addTodoList(todoListName, 80, 300, newImage, itemCount);

      /// Set the [itemCount] to correspond to the location in [todoList].
      todoMap[itemCount] = todoList.length - 1;

      /// Increment the count since an item has been added.
      itemCount++;
      todo.value++;
    }
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
  todoItems
      .add(TodoItem(id: id, xpos: xpos, ypos: ypos, icon: icon, name: title));

  String encodedTodo = TodoItem.encode(todoItems);
  String encodedDone = TodoItem.encode(doneItems);

  TodoList list = TodoList(
      id: todoListID,
      listName: todoListName,
      items: encodedTodo,
      completed: encodedDone,
      count: todoItems.length + doneItems.length,
      color: todoListColor,
      ordering: todoListOrder);

  await DatabaseHelper.instance.updateTodo(list);
}

/// -------------------------------------------------------
///
/// -------------------------------------------------------
void saveListStates() async {
  print("Saving");

  String encodedTodo = TodoItem.encode(todoItems);
  String encodedDone = TodoItem.encode(doneItems);

  TodoList list = TodoList(
      id: todoListID,
      listName: todoListName,
      items: encodedTodo,
      completed: encodedDone,
      count: todoItems.length + doneItems.length,
      color: todoListColor,
      ordering: todoListOrder);

  await DatabaseHelper.instance.updateTodo(list);

  print("Updated list");
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
      this.imageSource, this.key, this.title);

  double xPosition;
  double yPosition;
  bool isTodo;
  int id;
  Key key;
  String imageSource;
  String title;

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState(
        xPosition, yPosition, isTodo, id, imageSource, key, title);
  }
}

/// -------------------------------------------------------
///
/// -------------------------------------------------------
class _MoveableStackItemState extends State<MoveableStackItem> {
  _MoveableStackItemState(this.xPosition, this.yPosition, this.isTodo, this.id,
      this.imageSource, this.key, this.title);

  double xPosition;
  double yPosition;
  bool isTodo;
  int id;
  Key key;
  String imageSource;
  String title;

  // Set to true if an icon has hit the edge to be passed to the other list.
  // Prevents the item from being transferred more than once in a row.
  bool hitEdge = false;

  bool transferred = false;

  var selected;

  @override
  void initState() {
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Yes, delete"),
      onPressed: () {
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
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting item from list"),
      content: Text("Are you sure you want to delete \"" + title + "\"?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;

    selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 100000, 0),
      items: [
        PopupMenuItem(
          child: Center(
            child: Text(
              title,
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

        showAlertDialog(context);

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
        onTapUp: (tapUpDetails) {
          print("tap");
          _showPopupMenu(tapUpDetails.globalPosition);
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
                  print("Putting in todo list");
                  print(doneList);
                  print(doneItems);
                  print(doneMap);
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
                      true, id, imageSource, UniqueKey(), title));
                  todoItems.add(TodoItem(
                      id: id,
                      xpos: xPosition,
                      ypos: yPosition,
                      icon: imageSource));
                  // ---------------------------

                  // Make an entry for that item in the map.
                  todoMap[id] = todoList.length - 1;

                  print(todoList);
                  print(todoItems);
                  print(todoMap);

                  // Update values to refresh UI.
                  done.value--;
                  todo.value++;

                  print("Saving after move");

                  saveListStates();
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
                      yPosition, false, id, imageSource, UniqueKey(), title));
                  doneItems.add(TodoItem(
                      id: id,
                      xpos: xPosition,
                      ypos: yPosition,
                      icon: imageSource,
                      name: title));
                  // ---------------------------

                  // Make an entry for that item in the map.
                  doneMap[id] = doneList.length - 1;

                  // Update values to refresh UI.
                  done.value++;
                  todo.value--;

                  print("Saving after move");

                  saveListStates();
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

          print("Done info: ");
          print(id);
          print(doneMap);
          print(doneItems);
          //print(doneItems[doneMap[id]]);

          print("Todo info: ");
          print(todoMap);
          print(todoItems);
          //print(todoItems[todoMap[id]]);

          if (isTodo && !transferred) {
            print("Update todo position");
            todoItems[todoMap[id]].xpos = xPosition;
            todoItems[todoMap[id]].ypos = yPosition;
          } else if (!isTodo && !transferred) {
            print("Update position");
            doneItems[doneMap[id]].xpos = xPosition;
            doneItems[doneMap[id]].ypos = yPosition;
          }

          print("Starting to save");

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
