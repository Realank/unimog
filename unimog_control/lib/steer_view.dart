import 'package:flutter/material.dart';

class SteerView extends StatelessWidget {
  final int percent;
  SteerView(this.percent);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 60,
      width: double.infinity,
      child: CustomPaint(
        painter: SteerPart(percent),
//        size: Size(width, height),
      ),
    );
  }
}

class SteerPart extends CustomPainter {
  final int percent;
  SteerPart(this.percent);
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int percent = this.percent;
    if (percent > 100) {
      percent = 100;
    } else if (percent < -100) {
      percent = -100;
    }
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green;
    final paintMiddle = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellowAccent;

    Path path = Path();
    path.addRect(Rect.fromPoints(Offset(size.width / 2, 15),
        Offset(size.width / 2 - percent / 100 * size.width / 2, size.height - 15)));
    canvas.drawPath(path, paint);
    Path pathMiddle = Path();
    pathMiddle.addRect(Rect.fromPoints(
        Offset(size.width / 2 - 1, 5), Offset(size.width / 2 + 1, size.height - 5)));
    canvas.drawPath(pathMiddle, paintMiddle);
  }
}
