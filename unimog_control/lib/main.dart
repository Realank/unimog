import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'vertical_stick.dart';
import 'horizontal_stick.dart';
import 'panel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
//  Future<Response> fetchPost() {
//    return get('https://www.baidu.com');
//  }

  @override
  Widget build(BuildContext context) {
//    fetchPost();
    return MaterialApp(
      title: 'RC Realank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ControlPanel(),
    );
  }
}

class ControlPanel extends StatefulWidget {
  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  RawDatagramSocket udpSocket;
  int speed = 0;
  int direction = 0;
  bool useFeed = false;
  @override
  void initState() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((RawDatagramSocket udpSocket) {
      this.udpSocket = udpSocket;
      setState(() {});
    });
    super.initState();
  }

  void sendData() {
    if (this.udpSocket != null) {
      //directionNum > 0 left
      int speedLeftFeed = (speed == 0 || !useFeed) ? 0 : (-direction ~/ 10);
      int speedRightFeed = (speed == 0 || !useFeed) ? 0 : (direction ~/ 10);
      double multiDirectLeft = (direction == 0 || !useFeed) ? 1 : (direction > 0 ? 0.9 : 0.8);
      double multiDirectRight = (direction == 0 || !useFeed) ? 1 : (direction > 0 ? 0.8 : 0.9);
      int speedNum = speed + 100;
      double directionLeftNum = direction * multiDirectLeft + 100;
      double directionRightNum = direction * multiDirectRight + 100;
      List<int> dataToSend = [
        0xfa,
        0x01,
        speedNum + speedLeftFeed, //left speed
        speedNum + speedRightFeed, //right speed
        directionLeftNum.toInt(), //left steel
        directionRightNum.toInt(), //right steel
        0xfb
      ];
      print('Sending from ${udpSocket.address.address}:${udpSocket.port}');
      final num = udpSocket.send(dataToSend, new InternetAddress('192.168.4.1'), 8888);
      print('Did send data on the stream.. $num for $dataToSend');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    udpSocket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(mainAxisSize: MainAxisSize.max, children: [
        Container(
          color: Colors.black,
          width: width / 4.0,
          child: VerticalStick((int value) {
            setState(() {
              speed = value;
              sendData();
            });
          }),
        ),
        Container(
            color: Colors.black,
            width: width / 8 * 3,
            child: DashBoard(
              direction: direction,
              speed: speed,
              useFeed: useFeed,
              stopCallback: () {
                this.speed = 0;
                this.direction = 0;
                sendData();
                setState(() {});
              },
              useFeedCallback: (useFeed) {
                this.useFeed = useFeed;
                setState(() {});
              },
            )),
        Container(
          color: Colors.black,
          width: width * 3 / 8,
          child: HorizontalStick((value) {
            setState(() {
              direction = value;
              sendData();
            });
          }),
        ),
      ]),
    );
  }
}
