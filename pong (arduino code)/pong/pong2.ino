#include <CapacitiveSensor.h>
//player 1
CapacitiveSensor cs_4_2 = CapacitiveSensor(4,2);
CapacitiveSensor cs_4_6 = CapacitiveSensor(4,6); 

//player 2
CapacitiveSensor cs_7_8 = CapacitiveSensor(7,8);
CapacitiveSensor cs_7_10 = CapacitiveSensor(7,10); 
long left, right;

 
 void setup() {
 //player 1 
 cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF); // turn off autocalibrate on channel 1 - just as an example
 cs_4_6.set_CS_AutocaL_Millis(0xFFFFFFFF); // turn off autocalibrate on channel 1 - just as an example

 //player 2
 cs_7_8.set_CS_AutocaL_Millis(0xFFFFFFFF); // turn off autocalibrate on channel 1 - just as an example
 cs_7_10.set_CS_AutocaL_Millis(0xFFFFFFFF); // turn off autocalibrate on channel 1 - just as an example
 
  Serial.begin(9600);
}

void loop() {
 //long left, right;
 long up_1 = cs_4_2.capacitiveSensor(10);
 long down_1 = cs_4_6.capacitiveSensor(10);

 long up_2 = cs_7_8.capacitiveSensor(10);
 long down_2 = cs_7_10.capacitiveSensor(10);


if(up_1>=5){
  left = 0;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
  }

  if(up_2>=5){
  right = 0;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
  }

  if(down_1>=5){
  left = 1023;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
  }

  if(down_2>=5){
  right = 1023;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
  }

if(up_1>=5 && up_2>=5){
 left = 0;
 right = 0;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
  
 }

 if(up_1>=5 && down_2>=5){
 left =  0;
 right = 1023;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
 }

 
 if(up_2>=5 && down_1>=5){
  left = 1023;
 right = 0;
  Serial.print(left);
  Serial.print(" ");
  Serial.print(right);
  Serial.print("\n");
  delay(100);
  
 }

 if(down_1>=5 && down_2>=5){
  left = 1023;
 right = 1023;
  Serial.print(left);
  Serial.print(" ");
  Serial.println(right);
  Serial.print("\n");
  delay(100);
 }
 
 }


  

