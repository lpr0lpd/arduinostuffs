#include <OneWire.h>
 
//init the one wire interface on pin 10
OneWire  ow(10);

//write here the address you receive from the other program
byte sensor[8] = {0x1c, 0x42, 0x5c, 0x4D, 0x03, 0x00, 0x00, 0x5b};
 
void setup(void) {
  Serial.begin(9600);
}
 
void writeTimeToScratchpad(byte* address){
  //reset the bus
  ow.reset();
  //select our sensor
  ow.select(address);
  //CONVERT T function call (44h) which puts the temperature into the scratchpad
  ow.write(0x44,1);
  //sleep a second for the write to take place
  delay(1000);
}
 
void readTimeFromScratchpad(byte* address, byte* data){
  //reset the bus
  ow.reset();
  //select our sensor
  ow.select(address);
  //read the scratchpad (BEh)
  ow.write(0xBE);
  for (byte i=0;i<9;i++){
    data[i] = ow.read();
  }
}
 
float getTemperature(byte* address){
  int tr;
  byte data[12];
 
  writeTimeToScratchpad(address);
 
  readTimeFromScratchpad(address,data);
 
  //put in temp all the 8 bits of LSB (least significant byte)
  tr = data[0];
 
  //check for negative temperature
  if (data[1] > 0x80){
    tr = !tr + 1; //two's complement adjustment
    tr = tr * -1; //flip value negative.
  }
 
  //COUNT PER Celsius degree (10h)
  int cpc = data[7];
  //COUNT REMAIN (0Ch)
  int cr = data[6];
 
  //drop bit 0
  tr = tr >> 1;
 
  //calculate the temperature based on this formula :
  //TEMPERATURE = TEMP READ - 0.25 + (COUNT PER Celsius Degree - COUNT REMAIN)
// (COUNT PER Celsius Degree)
 
  return tr - (float)0.25 + (cpc - cr)/(float)cpc;
}
 
//fahrenheit to celsius conversion
float f2c(float val){
  float aux = val - 32;
  return (aux * 5 / 9);
}
 
//celsius to fahrenheit conversion
float c2f(float val){
  float aux = (val * 9 / 5);
  return (aux + 32);
}
 int HighByte, LowByte, TReading, SignBit, Tc_100, Whole, Fract;
void loop(void) {
    byte i;
  byte present = 0;
  byte data[12];
  byte addr[8];
  
 LowByte = data[0];
  HighByte = data[1];
  TReading = (HighByte << 8) + LowByte;
  SignBit = TReading & 0x8000;  // test most sig bit
  if (SignBit) // negative
  {
    TReading = (TReading ^ 0xffff) + 1; // 2's comp
  }
  Tc_100 = (6 * TReading) + TReading / 4;    // multiply by (100 * 0.0625) or 6.25

  Whole = Tc_100 / 100;  // separate off the whole and fractional portions
  Fract = Tc_100 % 100;


  if (SignBit) // If its negative
  {
     Serial.print("-");
  }
  Serial.print(Whole);
  Serial.print(".");
  if (Fract < 10)
  {
     Serial.print("0");
  }
  Serial.print(Fract);

  Serial.print("\n");

}
