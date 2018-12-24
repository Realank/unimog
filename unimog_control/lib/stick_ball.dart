import 'package:flutter/material.dart';

class StickBall extends StatelessWidget {
  final int position;
  final bool isVertical;
  StickBall(this.position, {this.isVertical = true});
  @override
  Widget build(BuildContext context) {
    Alignment align = Alignment.center;
    if (isVertical) {
      align -= Alignment(0, position.toDouble() / 100);
    } else {
      align -= Alignment(position.toDouble() / 100, 0);
    }
    return Stack(
      alignment: align,
      children: <Widget>[
        Container(
          width: double.infinity,
        ),
        Container(
//          width: 100,
          height: 100,
          decoration:
              BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(40)),
        ),
        Container(
          width: 80,
          height: 80,
          decoration:
              BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(40)),
        ),
      ],
    );
  }
}
