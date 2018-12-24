import 'package:flutter/material.dart';

final matrix = [
  [
    //0
    true,
    true,
    true,
    true,
    true,
    true,
    false,
  ],
  [
    //1
    false,
    true,
    true,
    false,
    false,
    false,
    false,
  ],
  [
    //2
    true,
    true,
    false,
    true,
    true,
    false,
    true,
  ],
  [
    //3
    true,
    true,
    true,
    true,
    false,
    false,
    true,
  ],
  [
    //4
    false,
    true,
    true,
    false,
    false,
    true,
    true,
  ],
  [
    //5
    true,
    false,
    true,
    true,
    false,
    true,
    true,
  ],
  [
    //6
    true,
    false,
    true,
    true,
    true,
    true,
    true,
  ],
  [
    //7
    true,
    true,
    true,
    false,
    false,
    false,
    false,
  ],
  [
    //8
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ],
  [
    //9
    true,
    true,
    true,
    true,
    false,
    true,
    true,
  ]
];

class DigitalNumber extends StatelessWidget {
  final double height;
  final double width;
  final double lineWidth;
  final int num;
  final bool dotLight;
  final Color highlightColor;
  final Color delightColor;

  DigitalNumber(
      {@required this.height,
      @required this.width,
      this.lineWidth = 8,
      num,
      this.dotLight = true,
      this.highlightColor = Colors.red,
      this.delightColor = const Color(0x33FF0000)})
      : this.num = num > 0 ? (num > 9 ? 9 : num) : 0;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NumberPart(
          lineWidth: lineWidth,
          num: num,
          dotLight: dotLight,
          highlightColor: highlightColor,
          delightColor: delightColor),
      size: Size(width, height),
    );
  }
}

class NumberPart extends CustomPainter {
  final int num;
  final bool dotLight;
  final Color highlightColor;
  final Color delightColor;
  final double lineWidth;
  NumberPart(
      {@required this.lineWidth,
      @required this.num,
      @required this.dotLight,
      @required this.highlightColor,
      @required this.delightColor});
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Paint getPaint(int index) {
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = highlightColor;
    final delightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = delightColor;
    return matrix[num][index] ? highlightPaint : delightPaint;
  }

  Path genPath(Offset offset, double length, double width) {
    final path = Path();
    double lerp = width / 1.7;
    path.addPolygon([
      Offset(0, 0) + offset,
      Offset(lerp, -width / 2) + offset,
      Offset(length - lerp, -width / 2) + offset,
      Offset(length, 0) + offset,
      Offset(length - lerp, width / 2) + offset,
      Offset(lerp, width / 2) + offset
    ], true);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = lineWidth;
    double length = (size.width) / 1.5 - width;
    double leftOffset = size.width / 3;
    double gap = width / 8;
    Path pathA = genPath(Offset.zero, length, width);
    Matrix4 transform = Matrix4.identity();
    transform.translate(leftOffset, width / 2 + 2);
    pathA = pathA.transform(transform.storage);
    canvas.drawPath(pathA, getPaint(0));

    Path pathB = genPath(Offset.zero, length, width);
    transform.translate(length);
    transform.translate(gap, gap);
    transform.rotateZ((10 + 90) / 180 * 3.14159);
    pathB = pathB.transform(transform.storage);
    canvas.drawPath(pathB, getPaint(1));

    Path pathC = genPath(Offset.zero, length, width);
    transform.translate(length + gap);
    pathC = pathC.transform(transform.storage);
    canvas.drawPath(pathC, getPaint(2));

    Path pathD = genPath(Offset.zero, length, width);
    transform.translate(length + gap, gap);
    transform.rotateZ((90 - 10) / 180 * 3.14159);
    pathD = pathD.transform(transform.storage);
    canvas.drawPath(pathD, getPaint(3));

    Path pathE = genPath(Offset.zero, length, width);
    transform.translate(length + gap, gap);
    transform.rotateZ((90 + 10) / 180 * 3.14159);
    pathE = pathE.transform(transform.storage);
    canvas.drawPath(pathE, getPaint(4));

    Path pathF = genPath(Offset.zero, length, width);
    Matrix4 transformF = transform.clone();
    transformF.translate(length + gap);
    pathF = pathF.transform(transformF.storage);
    canvas.drawPath(pathF, getPaint(5));

    Path pathG = genPath(Offset.zero, length, width);
    transform.translate(length + gap / 2, gap);
    transform.rotateZ((90 - 10) / 180 * 3.14159);
    pathG = pathG.transform(transform.storage);
    canvas.drawPath(pathG, getPaint(6));
  }
}
