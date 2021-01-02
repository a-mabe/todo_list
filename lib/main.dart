import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BlockWidget> blockWidgets;
  final List<Color> widgetColors = [
    Colors.red,
    Colors.brown,
    Colors.black,
    Colors.pink,
    Colors.grey
  ];

  @override
  void initState() {
    super.initState();

    blockWidgets = new List();
    for (int i = 0; i < widgetColors.length; i++) {
      blockWidgets.add(
          BlockWidget(widgetId: i, widgetColor: widgetColors.elementAt(i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('AppBar'),
      ),
      body: WidgetStacks(
        key: ValueKey('WidgetStacks_${blockWidgets.length}'),
        blocks: blockWidgets,
      ),
    );
  }
}

const blockHeight = 100.0;
const blockWidth = 100.0;

class BlockWidget {
  int widgetId;
  Color widgetColor;

  BlockWidget({
    @required this.widgetId,
    @required this.widgetColor,
  });
}

class TransformedWidget extends StatefulWidget {
  final BlockWidget block;
  final int stackIndex;
  final List<BlockWidget> attachedBlocks;
  final Function() onDragCanceled;
  final Function() onDragStart;

  TransformedWidget({
    Key key,
    @required this.block,
    @required this.stackIndex,
    @required this.attachedBlocks,
    this.onDragCanceled,
    this.onDragStart,
  }) : super(key: key);

  @override
  _TransformedWidgetState createState() => _TransformedWidgetState();
}

class _TransformedWidgetState extends State<TransformedWidget> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          widget.stackIndex * (blockHeight / 2),
          widget.stackIndex * (blockWidth / 2),
          0.0,
        ),
      child: Draggable<Map>(
        key: ValueKey(widget.stackIndex),
        onDragStarted: () => widget.onDragStart(),
        onDraggableCanceled: (_, __) => widget.onDragCanceled(),
        child: _buildBlock(),
        feedback: WidgetStacks(
          key: ValueKey('WidgetStacks_${widget.attachedBlocks.length}'),
          blocks: widget.attachedBlocks,
        ),
        childWhenDragging: Container(),
      ),
    );
  }

  Widget _buildBlock() => Material(
        child: Container(
          height: blockHeight,
          width: blockWidth,
          color: widget.block.widgetColor,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.block.widgetId.toString(),
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
        ),
      );
}

class WidgetStacks extends StatefulWidget {
  final List<BlockWidget> blocks;

  WidgetStacks({@required this.blocks, Key key}) : super(key: key);

  @override
  _WidgetStacksState createState() => _WidgetStacksState();
}

class _WidgetStacksState extends State<WidgetStacks> {
  ValueNotifier<List<BlockWidget>> blocksToBeShownNotifier;

  @override
  void initState() {
    blocksToBeShownNotifier = ValueNotifier<List<BlockWidget>>(widget.blocks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5 * blockHeight,
      width: 5 * blockWidth,
      margin: EdgeInsets.all(2.0),
      child: ValueListenableBuilder<List<BlockWidget>>(
        valueListenable: blocksToBeShownNotifier,
        builder: (BuildContext context, List<BlockWidget> value, Widget child) {
          return Stack(
            children: value.map((block) {
              int index = value.indexOf(block);
              return TransformedWidget(
                key: ValueKey(block.widgetId),
                block: block,
                stackIndex: index,
                onDragStart: () {
                  blocksToBeShownNotifier.value =
                      widget.blocks.sublist(0, index);
                },
                onDragCanceled: () {
                  blocksToBeShownNotifier.value = widget.blocks;
                },
                attachedBlocks: widget.blocks.sublist(index),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}*/

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

List<Widget> todoList = [];
List<Widget> doneList = [];
int itemCount = 0;
final done = new ValueNotifier<int>(doneList.length);
final todo = new ValueNotifier<int>(todoList.length);

Map<int, int> todoMap = HashMap();
Map<int, int> doneMap = HashMap();

List<String> images = [
  "images/sink.png",
  "images/mop.png",
  "images/walk_dog.png",
  "images/iron.png",
  "images/homework_blue.png",
  "images/homework_purple.png",
  "images/sweep.png",
  "images/wash_car.png",
  "images/washing_machine.png",
  "images/email.png",
  "images/feed_dog.png",
  "images/trash.png",
  "images/grocery.png",
  "images/dishes.png",
  "images/dust.png",
  "images/vacuum.png",
  "images/watering_can.png",
  "images/toilet.png",
  "images/homework_red.png",
  "images/fold_laundry.png",
  "images/tub.png"
];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todoList.add(MoveableStackItem(
                  80, 300, true, itemCount, images[next(0, 20)], UniqueKey()));

              todoMap[itemCount] = todoList.length - 1;

              print(todoMap[itemCount]);

              itemCount++;
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
                  child: ValueListenableBuilder<int>(
                    valueListenable: todo,
                    builder: (context, value, child) {
                      return FractionallySizedBox(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: done,
                    builder: (context, value, child) {
                      return FractionallySizedBox(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      );
                    },
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

class _MoveableStackItemState extends State<MoveableStackItem> {
  _MoveableStackItemState(this.xPosition, this.yPosition, this.isTodo, this.id,
      this.imageSource, this.key);

  double xPosition;
  double yPosition;
  bool isTodo;
  int id;
  Key key;
  String imageSource;

  bool hitEdge = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - kToolbarHeight;

    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;

            if (yPosition > (height - 88)) {
              yPosition = (height - 88);
            }

            if (yPosition < 0) {
              yPosition = 0;
            }

            if (xPosition < -15 && !isTodo) {
              xPosition = -15;

              //todoList.remove(this);
              if (!hitEdge && !isTodo) {
                setState(() {
                  print("Removing from done...");
                  print(doneMap);

                  doneList.removeAt(doneMap[id]);
                  int location = doneMap[id];
                  doneMap.remove(id);

                  print("Removed!");

                  for (int key in doneMap.keys) {
                    if (doneMap[key] > location) {
                      doneMap[key] = doneMap[key] - 1;
                    }
                  }

                  print("Updated");
                  print(doneMap);

                  print("Adding to todo...");

                  todoList.add(MoveableStackItem(((width - 180) / 2), yPosition,
                      true, id, imageSource, UniqueKey()));

                  todoMap[id] = todoList.length - 1;

                  done.value--;
                  todo.value++;
                });
              }

              hitEdge = true;
            } else if (xPosition < -2 && isTodo) {
              xPosition = -2;
            }

            if (xPosition > ((width - 105) / 2) && isTodo) {
              xPosition = ((width - 105) / 2);

              //todoList.remove(this);
              if (!hitEdge && isTodo) {
                setState(() {
                  print("Removing from todo...");
                  print(todoMap);

                  todoList.removeAt(todoMap[id]);
                  int location = todoMap[id];
                  todoMap.remove(id);

                  doneList.add(MoveableStackItem((xPosition - (xPosition - 3)),
                      yPosition, false, id, imageSource, UniqueKey()));

                  for (int key in todoMap.keys) {
                    if (todoMap[key] > location)
                      todoMap[key] = todoMap[key] - 1;
                  }

                  print("Updated");
                  print(todoMap);

                  print("Adding to done...");

                  doneMap[id] = doneList.length - 1;

                  done.value++;
                  todo.value--;
                });
              }

              hitEdge = true;
            } else if (xPosition > ((width - 130) / 2) && !isTodo) {
              xPosition = ((width - 130) / 2);
            }
          });
        },
        onPanEnd: (tapInfo) {
          hitEdge = false;
        },
        child: DragItem(imageSource),
      ),
    );
  }
}

/**
 * Generates a positive random integer uniformly distributed on the range
 * from [min], inclusive, to [max], exclusive.
 */
int next(int min, int max) => min + _random.nextInt(max - min);

class DragItem extends StatelessWidget {
  DragItem(this.imageSource);

  String imageSource;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageSource,
      width: 60.0,
    );
  }
}
