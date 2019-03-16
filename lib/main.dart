import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: "Tick Tac Toe",
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

List<String> initVal = ["", "", "", "", "", "", "", "", "", ""];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _GameField(),
    );
  }
}

class _GameField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameFieldState();
}

class AnimatedGrid extends AnimatedWidget {
  _GameFieldState board;

  AnimatedGrid(Animation<double> animation, _GameFieldState _gameFieldState,
      {Key key})
      : super(key: key, listenable: animation) {
    board = _gameFieldState;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: board.gridDrag,
        builder: (BuildContext context, Widget child) {
          return Transform(child: Transform(
            child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(32),
                crossAxisCount: 3,
                children: List.generate(9, (index) {
                  if (index == 1) {
                    return InkResponse(
                        onTap: () => board._itemClick(index),
                        child: Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: new Border(
                                    left: BorderSide(
                                        color: Colors.blue, width: 4),
                                    right: BorderSide(
                                        color: Colors.blue, width: 4))),
                            child: _CounterText(board.gameState[index])));
                  }
                  if (index % 3 == 1) {
                    return InkResponse(
                        onTap: () => board._itemClick(index),
                        child: Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: new Border(
                                    top: BorderSide(
                                        color: Colors.blue, width: 4),
                                    left: BorderSide(
                                        color: Colors.blue, width: 4),
                                    right: BorderSide(
                                        color: Colors.blue, width: 4))),
                            child: _CounterText(board.gameState[index])));
                  } else if (index >= 3) {
                    return InkResponse(
                        onTap: () => board._itemClick(index),
                        child: Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: new Border(
                                    top: BorderSide(
                                        color: Colors.blue, width: 4))),
                            child: _CounterText(board.gameState[index])));
                  } else {
                    return InkResponse(
                        onTap: () => board._itemClick(index),
                        child: Container(
                            child: _CounterText(board.gameState[index])));
                  }
                }).toList()),
            transform: Matrix4.translationValues(
                board.gridDragAnim.value * 20, 0.0, 0.0),

          ), transform: Matrix4.translationValues(
              board.gridDragAnim1.value * -20, 0.0, 0.0)
          );
        });
  }
}

class AnimatedBoard extends AnimatedWidget {
  _GameFieldState board;

  AnimatedBoard(Animation<double> animation, _GameFieldState _gameFieldState,
      {Key key})
      : super(key: key, listenable: animation) {
    board = _gameFieldState;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> test = listenable;

    return Center(
        child: Container(
            height: test.value,
            width: test.value,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                AnimatedGrid(board.gridDragAnim, board),
                Row(
                  children: <Widget>[
                    Text(
                      "Time for",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                    _CounterText(board._choose)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Container(
                    margin: EdgeInsets.all(32),
                    child: ButtonTheme(
                      child: RaisedButton(
                        child: Text("Restart"),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: board.startGame,
                      ),
                      minWidth: 10000,
                      padding: EdgeInsets.all(16),
                    ))
              ],
            )));
  }
}

class _GameFieldState extends State<_GameField> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController gridDrag;
  Animation<double> gridDragAnim;
  Animation<double> gridDragAnim1;

  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    gridDrag = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);


    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);


    gridDragAnim = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: gridDrag,
        curve: new Interval(0.0, 0.2, curve: Curves.linear)
    ));

    gridDragAnim1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: gridDrag,
        curve: new Interval(0.2, 0.4, curve: Curves.linear)
    ));

    animation = Tween(begin: 180.0, end: 1000.0).animate(controller);

    controller.forward(from: 0);
    gridDrag.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBoard(animation, this);
  }

  String _choose = "X";
  bool _isSomeOneWin = false;
  List<String> gameState = List.from(initVal);

  void startGame() {
    controller.forward(from: 0);
    setState(() {
      gameState.clear();
      gameState.addAll(initVal);
      _isSomeOneWin = false;
      _choose = "X";
    });
  }

  SnackBar _prepareSnackBar(String _message, [String dey = '']) {
    return SnackBar(
      content: Text(_message),
      action: SnackBarAction(
        label: dey,
        onPressed: () {
          startGame();
        },
      ),
    );
  }

//

  // void restartGame
  void _itemClick(int index) {
    if (!_isSomeOneWin) {
      setState(() {
        if (gameState[index] == "") {
          gameState[index] = _choose;
          if (_checkWinner()) {
            _isSomeOneWin = true;

            Scaffold.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
            Scaffold.of(context).showSnackBar(
                _prepareSnackBar("Winner is $_choose", "Restart"));
            return;
          }
          if (_choose == "X") {
            _choose = "0";
          } else {
            _choose = "X";
          }
        } else {
          debugPrint('test');

          gridDrag.forward(from: 0);
        }
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(_prepareSnackBar("Winner is $_choose", "Restart"));
    }
  }

  bool _checkWinner() {
    if (gameState[0] == gameState[1] &&
        gameState[1] == gameState[2] &&
        gameState[0] != "") {
      return true;
    } else if ((gameState[3] == gameState[4] &&
        gameState[4] == gameState[5] &&
        gameState[3] != "")) {
      return true;
    } else if (gameState[6] == gameState[7] &&
        gameState[7] == gameState[8] &&
        gameState[6] != "") {
      return true;
    } else if (gameState[0] == gameState[3] &&
        gameState[3] == gameState[6] &&
        gameState[6] != "") {
      return true;
    } else if (gameState[1] == gameState[4] &&
        gameState[4] == gameState[7] &&
        gameState[7] != "") {
      return true;
    } else if (gameState[2] == gameState[5] &&
        gameState[5] == gameState[8] &&
        gameState[8] != "") {
      return true;
    } else if (gameState[0] == gameState[4] &&
        gameState[4] == gameState[8] &&
        gameState[8] != "") {
      return true;
    } else if (gameState[2] == gameState[4] &&
        gameState[4] == gameState[6] &&
        gameState[6] != "") {
      return true;
    } else {
      return false;
    }
  }
}

class _CounterText extends Text {
  _CounterText(String data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Center(child: super.build(context));
  }

  @override
  TextStyle get style =>
      TextStyle(fontSize: 56, fontWeight: FontWeight.w500, color: Colors.red);
}
