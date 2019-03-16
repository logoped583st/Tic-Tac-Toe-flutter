import 'package:flutter/material.dart';

class _GameField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameFieldState();
}

class _GameFieldState extends State<_GameField> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 3,

        children: List.generate(3, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline,
            ),
          );
        }));
  }
}

_GameField _gameField() => _GameField();