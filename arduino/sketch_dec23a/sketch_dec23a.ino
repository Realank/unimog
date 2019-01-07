#include <ESP8266WiFi.h>
#include <Servo.h>
#include <WiFiUdp.h>
WiFiUDP Udp;
char incomingPacket[100];
int ledPin = 2;
int motorLeft1Pin = 15;
int motorLeft2Pin = 13;
int motorRight1Pin = 12;
int motorRight2Pin = 14;
int servoLeftPin = 0;
int servoRightPin = 4;
Servo servoLeft;
Servo servoRight;
int initLeftServoAngle = 87;
int initRightServoAngle = 102;//越小越左
void setup() {
  servoLeft.attach(servoLeftPin);
  servoLeft.write(initLeftServoAngle);
  servoRight.attach(servoRightPin);
  servoRight.write(initRightServoAngle);
  pinMode(ledPin, OUTPUT);
  analogWrite(ledPin, 500);
  pinMode(motorLeft1Pin, OUTPUT);
  digitalWrite(motorLeft1Pin,LOW);
  pinMode(motorLeft2Pin, OUTPUT);
  digitalWrite(motorLeft2Pin,LOW);
  pinMode(motorRight1Pin, OUTPUT);
  digitalWrite(motorRight1Pin,LOW);
  pinMode(motorRight2Pin, OUTPUT);
  digitalWrite(motorRight2Pin,LOW);
  
  Serial.begin(115200);
  Serial.println();

  Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP("Unimog", "88888888") ? "Ready" : "Failed!");
  delay(1000);
  
  Serial.print("Soft-AP IP address = ");
  Serial.println(WiFi.softAPIP());
  Udp.begin(8888);
} 
void loop() {

  int packetSize = Udp.parsePacket(); //获取当前队首数据包长度
  if (packetSize)                     // 有数据可用
  {
    Serial.printf("Received %d bytes from %s, port %d\n", packetSize, Udp.remoteIP().toString().c_str(), Udp.remotePort());
    int len = Udp.read(incomingPacket, 100); // 读取数据到incomingPacket
    if (len > 0)                             // 如果正确读取
    {
      incomingPacket[len] = 0; //末尾补0结束字符串
      Serial.printf("UDP packet contents: %s\n", incomingPacket);
      if(incomingPacket[0] == 0xfa && incomingPacket[6] == 0xfb) {
        if(incomingPacket[1] == 0x01) {
          int speedLeft = incomingPacket[2] - 100;
          int speedRight = incomingPacket[3] - 100;
          int directionLeft = incomingPacket[4] - 100;
          int directionRight = incomingPacket[5] - 100;
          Serial.printf("UDP speed: %d + %d\n", speedLeft,speedRight);
          if(speedLeft == 0 ) {
            analogWrite(motorLeft1Pin, 0);
            analogWrite(motorLeft2Pin, 0);
          } else if (speedLeft > 0) {
            analogWrite(motorLeft1Pin, speedLeft * 1023 / 110);
            analogWrite(motorLeft2Pin, 0 );
          } else {
            analogWrite(motorLeft1Pin, 0 );
            analogWrite(motorLeft2Pin, -speedLeft * 1023 / 110);
          }
          if(speedRight == 0 ) {
            analogWrite(motorRight1Pin, 0);
            analogWrite(motorRight2Pin, 0);
          } else if (speedRight > 0) {
            analogWrite(motorRight1Pin, speedRight * 1023 / 110);
            analogWrite(motorRight2Pin, 0);
          } else {
            analogWrite(motorRight1Pin, 0);
            analogWrite(motorRight2Pin, -speedRight * 1023 / 110);
          }
          Serial.printf("UDP direction: %d + %d\n", directionLeft, directionRight);
          if(directionLeft == 0) {
            servoLeft.write(initLeftServoAngle);
          } else {
            servoLeft.write(initLeftServoAngle - directionLeft * 25 / 110);
          }
          if(directionRight == 0) {
            servoRight.write(initRightServoAngle);
          } else {
            servoRight.write(initRightServoAngle - directionRight * 25 / 110);
          }
          
         
//          Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
//          char rcv[5]= {0xfa,0xf0,0,0,0xfb};
//          Udp.write(rcv); // 回复LED has been turn off
//          Udp.endPacket();
        }
      }
//      else // 如果非指定消息
//      {
//        Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
//        Udp.write("Data Error!"); // 回复Data Error!
//        Udp.endPacket();
//      }
    }
  }

  delay(10);
}
