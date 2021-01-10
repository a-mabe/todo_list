import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:todo_list/view_list.dart';
import 'package:todo_list/data/database_helper.dart';
import 'package:todo_list/data/todo_list.dart';
import 'package:todo_list/data/todo_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Color(0xff00c29a),
        primaryColorLight: Colors.white,
        backgroundColor: Color(0xff00c29a).withOpacity(0.4),

        // Define the default font family.
        fontFamily: 'Arial',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        primaryTextTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.grey),
          headline6: TextStyle(fontSize: 24.0, color: Colors.grey),
          bodyText2:
              TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey),
        ),
      ),
    );
  }
}

class NameList extends StatefulWidget {
  String listName;

  NameList({Key key, @required this.listName}) : super(key: key);

  @override
  _NameListState createState() => _NameListState(listName: listName);
}

class _NameListState extends State<NameList> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  String listName;

  _NameListState({@required this.listName});

  void _submit() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    print(listName);

    List<TodoItem> items = List();
    List<TodoItem> completed = List();

    String encodedTodo = TodoItem.encode(items);
    String encodedDone = TodoItem.encode(completed);

    await DatabaseHelper.instance.insertTodo(TodoList(
        listName: listName,
        items: encodedTodo,
        completed: encodedDone,
        count: 0));

    Navigator.of(context).push(_createRoute(listName));
  }

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: "New List");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            "New To-do List",
            style: new TextStyle(
                color: Colors.grey, fontWeight: FontWeight.normal),
          )),
      //body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //form
        child: Form(
          key: _formKey,
          child: Padding(
            padding: new EdgeInsets.fromLTRB(20.0, 40, 20.0, 25.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 40,
                    right: 0,
                    bottom: 0,
                  ),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 22.0, color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff0f0f0),
                    labelStyle: TextStyle(
                      color: Color(0xff00c29a),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide:
                          BorderSide(width: 1, color: Color(0xff00c29a)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 1,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffff8066))),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffff8066))),
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 15),
                    labelText: "Title",
                  ),
                  controller: _controller,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    listName = value;
                    print(value);
                  },
                  onFieldSubmitted: (value) {
                    listName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty || value.length > 25) {
                      return "Task name must be 0 - 25 characters.";
                    }
                    return null;
                  },
                ),
                //box styling
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                //text input
                TextFormField(
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff0f0f0),
                    labelStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide:
                          BorderSide(width: 1, color: Color(0xff00c29a)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 1,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffff8066))),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffff8066))),
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 15),
                    labelText: "Details (optional)",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onFieldSubmitted: (value) {},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: FlatButton(
                        shape: Border(
                            bottom:
                                BorderSide(color: Color(0xffff8066), width: 2)),
                        //color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Color(0xffff8066),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(child: Container(), flex: 1),
                    Expanded(
                      flex: 5,
                      child: FlatButton(
                        shape: Border(
                            bottom:
                                BorderSide(color: Color(0xff00c29a), width: 2)),
                        //color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Color(0xff00c29a),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () => _submit(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(String listName) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) =>
        HomeView(newImage: "", title: "", listName: listName),
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
