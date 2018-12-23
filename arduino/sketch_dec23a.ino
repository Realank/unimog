#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
WiFiUDP Udp;
char incomingPacket[100];

void setup() {
  pinMode(2, OUTPUT);
//  digitalWrite(2, LOW);
  analogWrite(2, 0);
  
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
      if(incomingPacket[0] == 0xfa && incomingPacket[4] == 0xfb) {
        if(incomingPacket[1] == 0x01) {
          Serial.printf("UDP speed: 0x%x\n", incomingPacket[2]);
//          digitalWrite(2, incomingPacket[2] % 2 ? HIGH : LOW);
          analogWrite(2, incomingPacket[2] * 1023 / 0xff);
          Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
          char rcv[5]= {0xfa,0xf0,0,0,0xfb};
          Udp.write(rcv); // 回复LED has been turn off
          Udp.endPacket();
        }
      }
      else // 如果非指定消息
      {
        Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
        Udp.write("Data Error!"); // 回复Data Error!
        Udp.endPacket();
      }
    }
  }

  delay(10);
}
