import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<Response> fetchPost() {
    return get('https://www.baidu.com');
  }

  @override
  Widget build(BuildContext context) {
    fetchPost();
    return MaterialApp(
      title: 'Flutter Demo',
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
  @override
  void initState() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
        .then((RawDatagramSocket udpSocket) {
      this.udpSocket = udpSocket;
      setState(() {});
    });
    super.initState();
  }

  void sendData() {
    if (this.udpSocket != null) {
      List<int> dataToSend = [0xfa, 0x01, speed, direction, 0xfb];
      print('Sending from ${udpSocket.address.address}:${udpSocket.port}');
      final num =
          udpSocket.send(dataToSend, new InternetAddress('192.168.4.1'), 8888);
      print('Did send data on the stream.. $num');
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('$speed'),
            FlatButton(
                onPressed: () {
                  this.speed = (this.speed + 10) % 0xff;
                  sendData();
                  setState(() {});
                },
                child: Text('speed up')),
            FlatButton(
                onPressed: () {
                  this.speed = 0;
                  sendData();
                  setState(() {});
                },
                child: Text('stop'))
          ],
        ),
      ),
    );
  }
}
