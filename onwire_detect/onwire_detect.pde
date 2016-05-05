#include <OneWire.h>
 
//init the one wire interface on pin 10
OneWire ow(10);
 
void setup(void) {
  Serial.begin(9600);
  lookUpSensors();
}
 
void lookUpSensors(){
  byte address[8];
  int i=0;
  byte ok = 0, tmp = 0;
  //start the search
  Serial.println("--Search started--");
  while (ow.search(address)){
    tmp = 0;
    //0x10 = DS18S20
    if (address[0] == 0x10){
      Serial.print("Device is a DS18S20 : ");
      tmp = 1;
    } else {
      //0x28 = DS18B20
      if (address[0] == 0x28){
        Serial.print("Device is a DS18B20 : ");
        tmp = 1;
      }
    }
    //display the address, if tmp is ok
    if (tmp == 1){
      if (OneWire::crc8(address, 7) != address[7]){
        Serial.println("but it doesn't have a valid CRC!");
      } else {
        //all is ok, display it
        for (i=0;i<8;i++){
          if (address[i] < 9){
            Serial.print("0");
          }
          Serial.print(address[i],HEX);
          if (i<7){
            Serial.print("-");
          }
        }
        Serial.println("");
        ok = 1;
      }
    }//end if tmp
  }//end while
  if (ok == 0){
    Serial.println("No devices were found");
  }
  Serial.println("--Search ended--");
}
 
void loop(void) {
  //do nothing :)
}
