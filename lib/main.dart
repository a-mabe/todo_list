/*
/// Flutter code sample for NestedScrollView

// This example shows a [NestedScrollView] whose header is the combination of a
// [TabBar] in a [SliverAppBar] and whose body is a [TabBarView]. It uses a
// [SliverOverlapAbsorber]/[SliverOverlapInjector] pair to make the inner lists
// align correctly, and it uses [SafeArea] to avoid any horizontal disturbances
// (e.g. the "notch" on iOS when the phone is horizontal). In addition,
// [PageStorageKey]s are used to remember the scroll position of each tab's
// list.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rerderable List',
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
              fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.grey),
          headline6: TextStyle(fontSize: 24.0, color: Colors.grey),
          bodyText2:
              TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey),
        ),
      ),
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = ['Tab 1', 'Tab 2'];
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'), // This is the title in the app bar.
                pinned: true,
                expandedHeight: 150.0,
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  // These are the widgets to put in each tab in the tab bar.
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                // This Builder is needed to provide a BuildContext that is
                // "inside" the NestedScrollView, so that
                // sliverOverlapAbsorberHandleFor() can find the
                // NestedScrollView.
                builder: (BuildContext context) {
                  return CustomScrollView(
                    // The "controller" and "primary" members should be left
                    // unset, so that the NestedScrollView can control this
                    // inner scroll view.
                    // If the "controller" property is set, then this scroll
                    // view will not be associated with the NestedScrollView.
                    // The PageStorageKey should be unique to this ScrollView;
                    // it allows the list to remember its scroll position when
                    // the tab view is not on the screen.
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        // In this example, the inner scroll view has
                        // fixed-height list items, hence the use of
                        // SliverFixedExtentList. However, one could use any
                        // sliver widget here, e.g. SliverList or SliverGrid.
                        sliver: SliverFixedExtentList(
                          // The items in this example are fixed to 48 pixels
                          // high. This matches the Material Design spec for
                          // ListTile widgets.
                          itemExtent: 48.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              // This builder is called for each child.
                              // In this example, we just number each list item.
                              return ListTile(
                                title: Text('Item $index'),
                              );
                            },
                            // The childCount of the SliverChildBuilderDelegate
                            // specifies how many children this inner list
                            // has. In this example, each tab has a list of
                            // exactly 30 items, but this is arbitrary.
                            childCount: 30,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:todo_list/data/todo_list.dart';
import 'package:todo_list/data/database_helper.dart';
import 'package:todo_list/view_list.dart';
import 'package:todo_list/name_list.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
  //await loadLists();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rerderable List',
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
              fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.grey),
          headline6: TextStyle(fontSize: 24.0, color: Colors.grey),
          bodyText2:
              TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey),
        ),
      ),
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ItemData {
  ItemData(this.title, this.color, this.order, this.key);

  final String title;
  final int color;
  int order;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  Android,
}

final numItems = new ValueNotifier<int>(0);
List<TodoList> todos = List();

void loadLists() async {
  //String encodedData = TodoItem.encode(todoItems);

  //await DatabaseHelper.instance.insertTodo(TodoList(
  //listName: "test_list", items: encodedData, count: todoItems.length));

  _items = List();

  todos = await DatabaseHelper.instance.retrieveTodos();

  // For each list that existed in the database
  for (int i = 0; i < todos.length; i++) {
    print(todos[i].listName);
    _items.add(ItemData(
        todos[i].listName, todos[i].color, todos[i].ordering, ValueKey(i)));
  }

  _items.sort((a, b) => a.order.compareTo(b.order));
  todos.sort((a, b) => a.ordering.compareTo(b.ordering));

  numItems.value++;
  print(_items);
}

void saveList() async {
  for (int i = 0; i < todos.length; i++) {
    await DatabaseHelper.instance.updateTodo(todos[i]);
  }
}

List<ItemData> _items = List();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("init");
    loadLists();
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    final draggedTodoItem = todos[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

      todos.removeAt(draggingIndex);
      todos.insert(newPositionIndex, draggedTodoItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");

    for (int i = 0; i < _items.length; i++) {
      _items[i].order = i;
      todos[i].setOrder(i);
    }

    for (int i = 0; i < _items.length; i++) {
      print(_items[i].order);
      print(todos[i].ordering);
    }
    print("Saving...");
    saveList();
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  Widget build(BuildContext context) {
    final List<String> _tabs = ['Tab 1', 'Tab 2'];
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'), // This is the title in the app bar.
                pinned: true,
                expandedHeight: 150.0,
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  // These are the widgets to put in each tab in the tab bar.
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: [
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                // This Builder is needed to provide a BuildContext that is
                // "inside" the NestedScrollView, so that
                // sliverOverlapAbsorberHandleFor() can find the
                // NestedScrollView.
                builder: (BuildContext context) {
                  return ReorderableList(
                    onReorder: this._reorderCallback,
                    onReorderDone: this._reorderDone,
                    child: CustomScrollView(
                      key: PageStorageKey<String>("name"),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber
                          // above.
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Item(
                                      data: _items[index],
                                      // First and last attributes affect border drawn during dragging
                                      isFirst: index == 0,
                                      isLast: index == _items.length - 1,
                                      draggingMode: _draggingMode,
                                    ),
                                    onTap: () {
                                      print("Loading your list at " +
                                          _items[index].order.toString());
                                      Navigator.of(context).push(
                                          _createViewListRoute(
                                              _items[index].title,
                                              _items[index].order));
                                    },
                                  );
                                },
                                childCount: _items.length,
                              ),
                            )),
                      ],
                    ),
                  );

                  /*
                  return CustomScrollView(
                    // The "controller" and "primary" members should be left
                    // unset, so that the NestedScrollView can control this
                    // inner scroll view.
                    // If the "controller" property is set, then this scroll
                    // view will not be associated with the NestedScrollView.
                    // The PageStorageKey should be unique to this ScrollView;
                    // it allows the list to remember its scroll position when
                    // the tab view is not on the screen.
                    key: PageStorageKey<String>("name"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        // In this example, the inner scroll view has
                        // fixed-height list items, hence the use of
                        // SliverFixedExtentList. However, one could use any
                        // sliver widget here, e.g. SliverList or SliverGrid.
                        sliver: SliverFixedExtentList(
                          // The items in this example are fixed to 48 pixels
                          // high. This matches the Material Design spec for
                          // ListTile widgets.
                          itemExtent: 48.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              // This builder is called for each child.
                              // In this example, we just number each list item.
                              return ListTile(
                                title: Text('Item $index'),
                              );
                            },
                            // The childCount of the SliverChildBuilderDelegate
                            // specifies how many children this inner list
                            // has. In this example, each tab has a list of
                            // exactly 30 items, but this is arbitrary.
                            childCount: 30,
                          ),
                        ),
                      ),
                    ],
                  );*/
                },
              ),
            ),
            Icon(Icons.directions_transit),
          ],

          /*_tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                // This Builder is needed to provide a BuildContext that is
                // "inside" the NestedScrollView, so that
                // sliverOverlapAbsorberHandleFor() can find the
                // NestedScrollView.
                builder: (BuildContext context) {
                  return CustomScrollView(
                    // The "controller" and "primary" members should be left
                    // unset, so that the NestedScrollView can control this
                    // inner scroll view.
                    // If the "controller" property is set, then this scroll
                    // view will not be associated with the NestedScrollView.
                    // The PageStorageKey should be unique to this ScrollView;
                    // it allows the list to remember its scroll position when
                    // the tab view is not on the screen.
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        // In this example, the inner scroll view has
                        // fixed-height list items, hence the use of
                        // SliverFixedExtentList. However, one could use any
                        // sliver widget here, e.g. SliverList or SliverGrid.
                        sliver: SliverFixedExtentList(
                          // The items in this example are fixed to 48 pixels
                          // high. This matches the Material Design spec for
                          // ListTile widgets.
                          itemExtent: 48.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              // This builder is called for each child.
                              // In this example, we just number each list item.
                              return ListTile(
                                title: Text('Item $index'),
                              );
                            },
                            // The childCount of the SliverChildBuilderDelegate
                            // specifies how many children this inner list
                            // has. In this example, each tab has a list of
                            // exactly 30 items, but this is arbitrary.
                            childCount: 30,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),*/
        ),
      ),
    );
  }

  /*Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(_createNewListRoute());
          });
        },
      ),
      body: ValueListenableBuilder<int>(
          valueListenable: numItems,
          builder: (context, value, child) {
            return ReorderableList(
              onReorder: this._reorderCallback,
              onReorderDone: this._reorderDone,
              child: CustomScrollView(
                // cacheExtent: 3000,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: Container(),
                    actions: <Widget>[
                      PopupMenuButton<DraggingMode>(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text("Options"),
                        ),
                        initialValue: _draggingMode,
                        onSelected: (DraggingMode mode) {
                          setState(() {
                            _draggingMode = mode;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<DraggingMode>>[
                          const PopupMenuItem<DraggingMode>(
                              value: DraggingMode.iOS,
                              child: Text('iOS-like dragging')),
                          const PopupMenuItem<DraggingMode>(
                              value: DraggingMode.Android,
                              child: Text('Android-like dragging')),
                        ],
                      ),
                    ],
                    pinned: true,
                    expandedHeight: 100.0,
                    flexibleSpace: const FlexibleSpaceBar(
                      title: const Text("To-do, Ta-da"),
                    ),
                  ),
                  SliverPadding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return GestureDetector(
                              child: Item(
                                data: _items[index],
                                // First and last attributes affect border drawn during dragging
                                isFirst: index == 0,
                                isLast: index == _items.length - 1,
                                draggingMode: _draggingMode,
                              ),
                              onTap: () {
                                print("Loading your list at " +
                                    _items[index].order.toString());
                                Navigator.of(context).push(_createViewListRoute(
                                    _items[index].title, _items[index].order));
                              },
                            );
                          },
                          childCount: _items.length,
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }*/
}

Route _createViewListRoute(String listName, int order) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => HomeView(
      newImage: "",
      title: "",
      listName: listName,
      order: order,
    ),
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

Route _createNewListRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) =>
        NameList(listName: "New List", order: _items.length),
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

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background while dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
            left: Divider.createBorderSide(context,
                color: Color(data.color), width: 30),
          ),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Color(0xffffffff),
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xffd1d1d1)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: Text(data.title,
                        style: Theme.of(context).textTheme.subtitle1),
                  )),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}

/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:todo_list/data/todo_list.dart';
import 'package:todo_list/data/database_helper.dart';
import 'package:todo_list/view_list.dart';
import 'package:todo_list/name_list.dart';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
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
              fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.grey),
          headline6: TextStyle(fontSize: 24.0, color: Colors.grey),
          bodyText2:
              TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainCollapsingToolbar(),
    ));

class MainCollapsingToolbar extends StatefulWidget {
  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

class _MainCollapsingToolbarState extends State<MainCollapsingToolbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Collapsing Toolbar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.info), text: "Tab 1"),
                      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              MyHomePage(),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ItemData {
  ItemData(this.title, this.color, this.order, this.key);

  final String title;
  final int color;
  int order;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  Android,
}

final numItems = new ValueNotifier<int>(0);
List<TodoList> todos = List();

void loadLists() async {
  _items = List();

  todos = await DatabaseHelper.instance.retrieveTodos();

  // For each list that existed in the database
  for (int i = 0; i < todos.length; i++) {
    print(todos[i].listName);
    _items.add(ItemData(
        todos[i].listName, todos[i].color, todos[i].ordering, ValueKey(i)));
  }

  _items.sort((a, b) => a.order.compareTo(b.order));
  todos.sort((a, b) => a.ordering.compareTo(b.ordering));

  numItems.value++;
  print(_items);
}

void saveList() async {
  for (int i = 0; i < todos.length; i++) {
    await DatabaseHelper.instance.updateTodo(todos[i]);
  }
}

List<ItemData> _items = List();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("init");
    loadLists();
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    final draggedTodoItem = todos[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

      todos.removeAt(draggingIndex);
      todos.insert(newPositionIndex, draggedTodoItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");

    for (int i = 0; i < _items.length; i++) {
      _items[i].order = i;
      todos[i].setOrder(i);
    }

    for (int i = 0; i < _items.length; i++) {
      print(_items[i].order);
      print(todos[i].ordering);
    }
    print("Saving...");
    saveList();
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;
  String currentlyViewing = "Incomplete";
  Color currentColor = Color(0xffff8066);

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(_createNewListRoute());
          });
        },
      ),
      body: ValueListenableBuilder<int>(
          valueListenable: numItems,
          builder: (context, value, child) {
            return ReorderableList(
              onReorder: this._reorderCallback,
              onReorderDone: this._reorderDone,
              child: CustomScrollView(
                // cacheExtent: 3000,
                slivers: <Widget>[
                  SliverPadding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return GestureDetector(
                              child: Item(
                                data: _items[index],
                                // First and last attributes affect border drawn during dragging
                                isFirst: index == 0,
                                isLast: index == _items.length - 1,
                                draggingMode: _draggingMode,
                              ),
                              onTap: () {
                                print("Loading your list at " +
                                    _items[index].order.toString());
                                Navigator.of(context).push(_createViewListRoute(
                                    _items[index].title, _items[index].order));
                              },
                            );
                          },
                          childCount: _items.length,
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }
}

Route _createViewListRoute(String listName, int order) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => HomeView(
      newImage: "",
      title: "",
      listName: listName,
      order: order,
    ),
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

Route _createNewListRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) =>
        NameList(listName: "New List", order: _items.length),
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

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background while dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
            left: Divider.createBorderSide(context,
                color: Color(data.color), width: 30),
          ),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Color(0xffffffff),
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xffd1d1d1)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: Text(data.title,
                        style: Theme.of(context).textTheme.subtitle1),
                  )),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}*/
