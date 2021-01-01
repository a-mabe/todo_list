import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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

List<Widget> todoList = [];
List<Widget> doneList = [];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todoList.add(MoveableStackItem());
            });
          },
        ),
        body: new Container(
            padding: const EdgeInsets.only(
              left: 9,
              top: 60,
              right: 9,
              bottom: 20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    child: Container(
                      child: Stack(
                        children: todoList,
                      ),
                      height: 1000,
                      margin: const EdgeInsets.all(6),
                      //color: Theme.of(context).primaryColorLight,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    child: Container(
                      child: Stack(
                        children: doneList,
                      ),
                      height: 1000,
                      margin: const EdgeInsets.all(6),
                      //color: Theme.of(context).primaryColorLight,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          border: Border.all(
                            color: Theme.of(context).accentColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ),
              ],
            )));
    /*Stack(
          children: movableItems,
        ));*/
  }
}

class MoveableStackItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 100;
  double yPosition = 400;
  Color color;
  @override
  void initState() {
    color = Color(0xff00c29a);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Height (without status and toolbar)
    double height = MediaQuery.of(context).size.height - kToolbarHeight;

    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;

            if (yPosition > (height - 85)) {
              yPosition = yPosition - 5;
            }

            if (yPosition < -2) {
              yPosition = yPosition + 5;
            }

            if (xPosition < -2 || xPosition > ((width - 110) / 2)) {
              xPosition = xPosition + 5;
            }

            if (xPosition > ((width - 130) / 2)) {
              xPosition = xPosition - 5;
            }
          });
        },
        child: DragItem('images/fold_laundry.png'),
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  DragItem(this.imageSource);

  String imageSource;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageSource,
      width: 40.0,
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Position {
  Position(this._x, this._y);

  setPosition(double x, double y, double width) {
    if (y < 150) {
      y = 400;
    }

    if (x < 20 || x > (width - 40)) {
      x = 100;
    }

    this._x = x;
    this._y = y;
  }

  double get x {
    return this._x;
  }

  double get y {
    return this._y;
  }

  double _x;
  double _y;
}

class _MyHomePageState extends State<MyHomePage> {
  List<Position> pos = List<Position>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    pos.add(Position(10, 150));
    pos.add(Position(50, 150));
    pos.add(Position(25, 150));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Center(
          child: CustomMultiChildLayout(
            delegate: DragArea(pos),
            children: <Widget>[
              LayoutId(
                id: 't0',
                child: Draggable(
                  feedback: DragItem('images/fold_laundry.png'),
                  child: DragItem('images/fold_laundry.png'),
                  childWhenDragging: Container(),
                  onDragEnd: (DraggableDetails d) {
                    setState(() {
                      pos[0].setPosition(d.offset.dx, d.offset.dy, width);
                    });
                  },
                ),
              ),
              LayoutId(
                id: 't1',
                child: Draggable(
                  feedback: DragItem('images/grocery_shopping.png'),
                  child: DragItem('images/grocery_shopping.png'),
                  childWhenDragging: Container(),
                  onDragEnd: (DraggableDetails d) {
                    setState(() {
                      pos[1].setPosition(d.offset.dx, d.offset.dy, width);
                    });
                  },
                ),
              ),
              LayoutId(
                id: 't2',
                child: Draggable(
                  feedback: DragItem('images/homework_red.png'),
                  child: DragItem('images/homework_red.png'),
                  childWhenDragging: Container(),
                  onDragEnd: (DraggableDetails d) {
                    setState(() {
                      pos[2].setPosition(d.offset.dx, d.offset.dy, width);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DragArea extends MultiChildLayoutDelegate {
  List<Position> _p = List<Position>();

  DragArea(this._p);

  @override
  void performLayout(Size size) {
    for (int i = 0; i < 3; i++) {
      layoutChild('t' + i.toString(), BoxConstraints.loose(size));
      positionChild('t' + i.toString(), Offset(_p[i].x, _p[i].y));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class DragItem extends StatelessWidget {
  DragItem(this.imageSource);

  String imageSource;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageSource,
      width: 40.0,
    );
  }
}*/

/*class Drag extends StatefulWidget {
  Drag({Key key}) : super(key: key);
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  double top = 0;
  double left = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
          backgroundColor: Color(0xFFFFFFFF),
        ),
        body: new Container(
            padding: const EdgeInsets.only(
              left: 9,
              top: 60,
              right: 9,
              bottom: 20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    child: Container(
                      height: 1000,
                      margin: const EdgeInsets.all(6),
                      //color: Theme.of(context).primaryColorLight,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: <Widget>[
                          Draggable(
                            child: Container(
                              padding: EdgeInsets.only(top: top, left: left),
                              child: DragItem(),
                            ),
                            feedback: Container(
                              padding: EdgeInsets.only(top: top, left: left),
                              child: DragItem(),
                            ),
                            childWhenDragging: Container(),
                            onDragCompleted: () {},
                            onDragEnd: (drag) {
                              setState(() {
                                top = top + drag.offset.dy < 0
                                    ? 0
                                    : top + drag.offset.dy;
                                left = left + drag.offset.dx < 0
                                    ? 0
                                    : left + drag.offset.dx;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    //color: Theme.of(context).primaryColorLight,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ],
            )));
  }
}

class DragItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/grocery_shopping.png',
      width: 40.0,
    );
  }
}*/

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
        title: "To-do List",
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
          backgroundColor: Color(0xFFFFFFFF),
        ),
        body: new Container(
            padding: const EdgeInsets.only(
              left: 9,
              top: 60,
              right: 9,
              bottom: 20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    child: Container(
                      height: 1000,
                      margin: const EdgeInsets.all(6),
                      //color: Theme.of(context).primaryColorLight,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Draggable(
                              child: new Image.asset(
                                'images/grocery_shopping.png',
                                width: 40.0,
                              ),
                              feedback: new Image.asset(
                                'images/grocery_shopping.png',
                                width: 40.0,
                              ),
                              childWhenDragging: Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    //color: Theme.of(context).primaryColorLight,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ],
            )));
  }
}

class DragItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/grocery_shopping.png',
      width: 40.0,
    );
  }
}*/
