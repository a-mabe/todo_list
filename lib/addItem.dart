import 'package:flutter/material.dart';
import 'package:todo_list/data/images.dart';
import 'package:todo_list/data/icon_names.dart';

import 'package:todo_list/item_details.dart';

class Item {
  String id;
  String name;
  String image;

  Item({this.id, this.name, this.image});
}

/// The serch query for choosing icons from the gridview.
final TextEditingController _searchQuery = TextEditingController();

/// True if the user is currently using the search bar.
bool isSearching;
String todoListName;
int todoListOrder;

class SearchList extends StatefulWidget {
  String listName;
  int order;
  SearchList({Key key, @required this.listName, @required this.order})
      : super(key: key);
  @override
  _SearchListState createState() =>
      _SearchListState(listName: listName, order: order);
}

class _SearchListState extends State<SearchList> {
  String listName;
  int order;

  Widget appBarTitle =
      // --------------------------
      // Search box.
      // --------------------------
      TextField(
    onTap: () {
      isSearching = true;
    },
    controller: _searchQuery,
    style: TextStyle(
      color: Colors.black87,
    ),
    // --------------------------
    // Search box styling to remove lines and shadows.
    // --------------------------
    decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.grey)),
  );
  // --------------------------
  // The exit selection/search button.
  // --------------------------
  Icon actionIcon = Icon(
    Icons.close,
    color: Colors.black87,
  );

  // --------------------------
  // Search bar parameters.
  // --------------------------
  final key = GlobalKey<ScaffoldState>();
  List<Item> itemList;
  List<Item> _searchList = List();
  // --------------------------

  String _searchText = "";
  _SearchListState({String listName, int order}) {
    print("[][][][][][]");
    print(listName);
    print("[][][][][][]");
    todoListName = listName;
    todoListOrder = order;
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty && this.mounted) {
        setState(() {
          isSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else if (this.mounted) {
        setState(() {
          isSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isSearching = false;
    init();
  }

  // --------------------------
  // Initailize the list of items to display in the gridview.
  // --------------------------
  void init() {
    itemList = List();

    for (int i = 0; i < images.length; i++) {
      itemList.add(
          Item(id: i.toString(), name: names[images[i]], image: images[i]));
    }

    _searchList = itemList;
  }
  // --------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: buildBar(context),
        body: new Container(
            padding: const EdgeInsets.only(
              left: 15,
              top: 25,
              right: 15,
              bottom: 25,
            ),
            child: GridView.builder(
                itemCount: _searchList.length,
                itemBuilder: (context, index) {
                  return Uiitem(_searchList[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ))));
  }

  List<Item> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = itemList;
    } else {
      _searchList = itemList
          .where((element) =>
              element.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      print('${_searchList.length}');
      return _searchList;
    }
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: appBarTitle,
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (isSearching) {
                  _handleSearchEnd();
                } else {
                  Navigator.of(context).pop();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.close,
        color: Colors.black87,
      );
      this.appBarTitle = TextField(
        onTap: () {
          isSearching = true;
        },
        controller: _searchQuery,
        style: TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey)),
      );
      isSearching = false;
      _searchQuery.clear();
      FocusScope.of(context).unfocus();
    });
  }
}

class Uiitem extends StatelessWidget {
  final Item item;
  Uiitem(this.item);

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
      elevation: 1,
      child: InkWell(
        splashColor: Color(0xff00c29a),
        onTap: () {
          print(item.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                      image: item.image,
                      name: item.name,
                      listName: todoListName,
                      order: todoListOrder)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 0,
                top: 15,
                right: 0,
                bottom: 0,
              ),
            ),
            Center(
                child: Image.asset(
              item.image,
              width: 60,
            )),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      this.item.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 0.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.grey,

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
