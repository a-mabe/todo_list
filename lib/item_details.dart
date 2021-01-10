import 'package:flutter/material.dart';
import 'package:todo_list/view_list.dart';

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

String todoListName;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final String image;
  String name, listName;

  HomePage(
      {Key key,
      @required this.image,
      @required this.name,
      @required this.listName})
      : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(image: image, name: name, listName: listName);
}

class _HomePageState extends State<HomePage> {
  final String image;
  String name, listName;

  _HomePageState(
      {@required this.image, @required this.name, @required this.listName});

  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    print(image);
    print(name);

    Navigator.of(context).push(_createRoute(image, name));
  }

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: name);

    todoListName = listName;

    print("---------");
    print(todoListName);
    print("---------");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            "Edit List Item",
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
                Image.asset(
                  image,
                  width: 100.0,
                ),
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
                    name = value;
                  },
                  onFieldSubmitted: (value) {
                    name = value;
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

Route _createRoute(String image, String title) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) =>
        HomeView(newImage: image, title: title, listName: todoListName),
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
