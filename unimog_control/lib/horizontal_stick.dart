import 'package:flutter/material.dart';
import 'stick_ball.dart';

typedef HorizontalStickDragUpdateCallback = void Function(int value);

class HorizontalStick extends StatefulWidget {
  final HorizontalStickDragUpdateCallback dragUpdateCallback;
  HorizontalStick(this.dragUpdateCallback);
  @override
  _HorizontalStickState createState() => _HorizontalStickState();
}

class _HorizontalStickState extends State<HorizontalStick> {
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
    double screenWidth = MediaQuery.of(context).size.width;
    double viewStart = screenWidth * 5 / 8;
    double viewWidth = screenWidth * 3 / 8;
    double maxWidth = viewWidth * 0.4;
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails detail) {
        print('start Horizontal drag ${detail.globalPosition}');
      },
//      onHorizontalDragDown: (DragDownDetails detail) {},
      onHorizontalDragUpdate: (DragUpdateDetails detail) {
        if (detail.primaryDelta != 0) {
          print('update Horizontal drag ${detail.globalPosition} delta ${detail.primaryDelta}');
          double globalDelta = (viewStart + viewWidth * 0.5 - detail.globalPosition.dx);
          globalDelta = globalDelta > maxWidth ? maxWidth : globalDelta;
          globalDelta = globalDelta < -maxWidth ? -maxWidth : globalDelta;
          value = (globalDelta / maxWidth * 100).toInt();
          widget.dragUpdateCallback(value);
          setState(() {});
        }
      },
      onHorizontalDragCancel: () {
        print('cancel Horizontal drag');
        value = 0;
        widget.dragUpdateCallback(value);
        setState(() {});
      },
      onHorizontalDragEnd: (DragEndDetails detail) {
        print('end Horizontal drag');
        value = 0;
        widget.dragUpdateCallback(value);
        setState(() {});
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: Color(0xff3e3e3e), borderRadius: BorderRadius.circular(10)),
              child: Text(
                'UNIMOG',
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
          )),
          StickPart(value),
          Expanded(
              child: Container(
//            color: Color(0xff3e3e3e),
                  )),
        ],
      ),
    );
  }
}

class StickPart extends StatelessWidget {
  final int value;
  StickPart(this.value);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 20,
        ),
        Container(
          height: 20,
          child: Ruler(),
        ),
        Container(
            height: 120,
            color: Colors.black,
            child: StickBall(
              value,
              isVertical: false,
            )),
        Container(
          height: 20,
          child: Ruler(),
        ),
        Container(
          height: 20,
          child: Center(
            child: Text(
              'Direction',
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
    );
  }
}

class Ruler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        BlankScale(),
        NumScale(),
        NumScale(),
        NumScale(),
        NumScale(),
        Container(
          width: 1,
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
      child: Row(
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
