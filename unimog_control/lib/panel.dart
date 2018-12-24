import 'package:flutter/material.dart';
import 'digital_number.dart';
import 'steer_view.dart';

typedef DashBoardStopCallback = void Function();

class DashBoard extends StatelessWidget {
  final int direction;
  final int speed;
  final DashBoardStopCallback stopCallback;
  DashBoard({@required this.direction, @required this.speed, this.stopCallback});
  @override
  Widget build(BuildContext context) {
    int speedNum = this.speed > 0 ? this.speed : -this.speed;
    speedNum = speedNum >= 100 ? 99 : speedNum;

    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Text(
          '方向',
          style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SteerView(direction),
        Container(
          height: 20,
        ),
        Text(
          '速度',
          style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DigitalNumber(
              height: 60,
              width: 45,
              num: (speedNum % 100 ~/ 10).toInt(),
              lineWidth: 6,
            ),
            DigitalNumber(
              height: 60,
              width: 45,
              num: (speedNum % 10).toInt(),
              lineWidth: 6,
            ),
          ],
        )),
        Container(
          height: 60,
        ),
        FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (stopCallback != null) {
                stopCallback();
              }
            },
            child: Ink(
              width: 80,
              height: 34,
              decoration:
                  BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text('Reset',
                    style: TextStyle(
                        color: Colors.grey[400], fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            )),
        Expanded(child: Container()),
      ],
    );
  }
}
