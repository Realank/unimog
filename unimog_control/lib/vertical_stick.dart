import 'package:flutter/material.dart';
import 'stick_ball.dart';

typedef VerticalStickDragUpdateCallback = void Function(int value);

class VerticalStick extends StatefulWidget {
  final VerticalStickDragUpdateCallback dragUpdateCallback;
  VerticalStick(this.dragUpdateCallback);
  @override
  _VerticalStickState createState() => _VerticalStickState();
}

class _VerticalStickState extends State<VerticalStick> {
  int value;
  @override
  void initState() {
    super.initState();
    value = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxHeight = screenHeight * 0.4;
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails detail) {
        print('start Vertical drag ${detail.globalPosition}');
      },
//      onVerticalDragDown: (DragDownDetails detail) {},
      onVerticalDragUpdate: (DragUpdateDetails detail) {
        if (detail.primaryDelta != 0) {
          print('update Vertical drag ${detail.globalPosition} delta ${detail.primaryDelta}');
          double globalDelta = (screenHeight * 0.5 - detail.globalPosition.dy);
          globalDelta = globalDelta > maxHeight ? maxHeight : globalDelta;
          globalDelta = globalDelta < -maxHeight ? -maxHeight : globalDelta;
          value = (globalDelta / maxHeight * 100).toInt();
          widget.dragUpdateCallback(value);
          setState(() {});
        }
      },
      onVerticalDragCancel: () {
        print('cancel Vertical drag');
        value = 0;
        widget.dragUpdateCallback(value);
        setState(() {});
      },
      onVerticalDragEnd: (DragEndDetails detail) {
        print('end Vertical drag');
        value = 0;
        widget.dragUpdateCallback(value);
        setState(() {});
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: 20,
                  child: Ruler(),
                ),
                Container(width: 120, color: Colors.black, child: StickBall(value)),
                Container(
                  width: 20,
                  child: Ruler(),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            color: Colors.black,
            child: Center(
              child: Text(
                'Speed',
                style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Ruler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        BlankScale(),
        NumScale(),
        NumScale(),
        NumScale(),
        NumScale(),
        Container(
          height: 1,
          color: Colors.white,
        ),
        NumScale(
          reverse: true,
        ),
        NumScale(
          reverse: true,
        ),
        NumScale(
          reverse: true,
        ),
        NumScale(
          reverse: true,
        ),
        BlankScale(),
      ],
    );
  }
}

class BlankScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black,
      ),
    );
  }
}

class NumScale extends StatelessWidget {
  final bool reverse;
  NumScale({this.reverse = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: reverse ? Colors.black : Colors.grey[800],
            ),
          ),
          Expanded(
            child: Container(
              color: reverse ? Colors.grey[800] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
