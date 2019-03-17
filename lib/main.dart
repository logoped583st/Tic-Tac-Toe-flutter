import 'dart:math';

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

List<String> initVal = ["", "", "", "", "", "", "", "", ""];

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
          return Transform(
              child: Transform(
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
                                padding: EdgeInsets.only(top: 4, bottom: 4),
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
                            onTap: () {
                              board._itemClick(index);
                            },
                            child: Container(
                                padding: EdgeInsets.only(bottom: 4),
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
                                padding: EdgeInsets.only(
                                    left: 4, bottom: 4, right: 4),
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
                                padding: EdgeInsets.all(4),
                                child: _CounterText(board.gameState[index])));
                      }
                    }).toList()),
                transform: Matrix4.translationValues(
                    board.gridDragAnim.value * 20, 0.0, 0.0),
              ),
              transform: Matrix4.translationValues(
                  board.gridDragAnim1.value * -20, 0.0, 0.0));
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
        Center(
          child:Container(
            child: _CounterText(board._choose), width: 72, height: 72),
          )],
        mainAxisAlignment: MainAxisAlignment.center,
      ),

      Container(
          margin: EdgeInsets.all(32),
          child: ButtonTheme(
            child: RaisedButton(
              child: Text("Restart"),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar(
                    reason: SnackBarClosedReason.hide);
                board.startGame();
              },
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
        parent: gridDrag, curve: new Interval(0.0, 0.2, curve: Curves.linear)));

    gridDragAnim1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: gridDrag, curve: new Interval(0.2, 0.4, curve: Curves.linear)));

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
    Scaffold.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
    return SnackBar(
      content: Text(_message),
      action: SnackBarAction(
        label: dey,
        onPressed: () {
          Scaffold.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
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
          if (_checkWinner() == 1) {
            _isSomeOneWin = true;

            Scaffold.of(context).showSnackBar(
                _prepareSnackBar("Winner is $_choose", "Restart"));
            return;
          } else if (_checkWinner() == 2) {
            Scaffold.of(context)
                .showSnackBar(_prepareSnackBar("Draw", "Restart"));
            return;
          }
          if (_choose == "X") {
            _choose = "0";
          } else {
            _choose = "X";
          }
        } else {
          if (_checkWinner() == 2) {
            Scaffold.of(context)
                .showSnackBar(_prepareSnackBar("Draw", "Restart"));
            return;
          } else {
            gridDrag.forward(from: 0);
          }
        }
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(_prepareSnackBar("Winner is $_choose", "Restart"));
    }
  }

  int _checkWinner() {
    if (gameState[0] == gameState[1] &&
        gameState[1] == gameState[2] &&
        gameState[0] != "") {
      return 1;
    } else if ((gameState[3] == gameState[4] &&
        gameState[4] == gameState[5] &&
        gameState[3] != "")) {
      return 1;
    } else if (gameState[6] == gameState[7] &&
        gameState[7] == gameState[8] &&
        gameState[6] != "") {
      return 1;
    } else if (gameState[0] == gameState[3] &&
        gameState[3] == gameState[6] &&
        gameState[6] != "") {
      return 1;
    } else if (gameState[1] == gameState[4] &&
        gameState[4] == gameState[7] &&
        gameState[7] != "") {
      return 1;
    } else if (gameState[2] == gameState[5] &&
        gameState[5] == gameState[8] &&
        gameState[8] != "") {
      return 1;
    } else if (gameState[0] == gameState[4] &&
        gameState[4] == gameState[8] &&
        gameState[8] != "") {
      return 1;
    } else if (gameState[2] == gameState[4] &&
        gameState[4] == gameState[6] &&
        gameState[6] != "") {
      return 1;
    } else if (!gameState.contains("")) {
      return 2;
    } else {
      return 0;
    }
  }
}

class _CounterText extends StatelessWidget {
  var data;

  _CounterText(String data) : super() {
    this.data = data;
  }

  @override
  TextStyle get style =>
      TextStyle(fontSize: 56, fontWeight: FontWeight.w500, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    if (data == "X") {
      return Container(child: Cross(), padding: EdgeInsets.all(24.0));
    } else if (data == "0") {
      return Container(child: Circle(), padding: EdgeInsets.all(24.0));
    } else {
      return Text("", style: style);
    }
  }
}

class CirclePainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CirclePainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    var rect = Offset(0.0, 0.0) & Size(size.width, size.height);
    canvas.drawArc(rect, -pi / 2, pi * 2 * _fraction, false, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}

class Circle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CircleState();
}

class CircleState extends State<Circle> with SingleTickerProviderStateMixin {
  CirclePainter painter;
  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    painter = CirclePainter(fraction);
    return CustomPaint(painter: painter);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Cross extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CrossState();
}

class CrossState extends State<Cross> with SingleTickerProviderStateMixin {
  CrossPainter painter;
  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    painter = CrossPainter(fraction);
    return CustomPaint(painter: painter);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CrossPainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CrossPainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    double leftLineFraction, rightLineFraction;

    if (_fraction < .5) {
      leftLineFraction = _fraction / .5;
      rightLineFraction = 0.0;
    } else {
      leftLineFraction = 1.0;
      rightLineFraction = (_fraction - .5) / .5;
    }

    canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width * leftLineFraction, size.height * leftLineFraction),
        _paint);

    if (_fraction >= .5) {
      canvas.drawLine(
          Offset(size.width, 0.0),
          Offset(size.width - size.width * rightLineFraction,
              size.height * rightLineFraction),
          _paint);
    }
  }

  @override
  bool shouldRepaint(CrossPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
