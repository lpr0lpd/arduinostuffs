#include <OneWire.h>

// DS18S20 Temperature chip i/o
OneWire ds(10);  // on pin 10
long previousMillis = 0;        // will store last time LED was updated

// the follow variables is a long because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long interval = 1000;           // interval at which to blink (milliseconds)

int sensorPin = 0; //the analog pin the TMP36 sensor pin is connected to
                        //the resolution is 10 mV / degree centigrade with a
                        //500 mV offset to allow for negative temperatures
                        

void setup(void) {
  // initialize inputs/outputs
  // start serial port
  Serial.begin(9600);
}

int HighByte, LowByte, TReading, SignBit, Tc_100, Whole, Fract,Faren;

void loop(void) {
  byte i;
  byte present = 0;
  byte data[12];
  byte addr[8];

  if ( !ds.search(addr)) {
      //Serial.print("No more addresses.\n");
      ds.reset_search();
      return;
  }

  //Serial.print("R=");
 // for( i = 0; i < 8; i++) {
 //   Serial.print(addr[i], HEX);
 //   Serial.print(" ");
 // }

  if ( OneWire::crc8( addr, 7) != addr[7]) {
      Serial.print("CRC is not valid!\n");
      return;
  }

/*  if ( addr[0] == 0x10) {
      Serial.print("Device is a DS18S20 family device.\n");
  }
  else if ( addr[0] == 0x28) {
      Serial.print("Device is a DS18B20 family device.\n");
  }
  else {
      Serial.print("Device family is not recognized: 0x");
      Serial.println(addr[0],HEX);
      return;
  }
*/
  ds.reset();
  ds.select(addr);
  ds.write(0x44,1);         // start conversion, with parasite power on at the end

  delay(1000);     // maybe 750ms is enough, maybe not
  // we might do a ds.depower() here, but the reset will take care of it.

  present = ds.reset();
  ds.select(addr);    
  ds.write(0xBE);         // Read Scratchpad

//  Serial.print("P=");
//  Serial.print(present,HEX);
//  Serial.print(" ");
  for ( i = 0; i < 9; i++) {           // we need 9 bytes
    data[i] = ds.read();
  //  Serial.print(data[i], HEX);
  //  Serial.print(" ");
  }
 // Serial.print(" CRC=");
 // Serial.print( OneWire::crc8( data, 8), HEX);
 // Serial.println();
  
 LowByte = data[0];
  HighByte = data[1];
  TReading = (HighByte << 8) + LowByte;
  SignBit = TReading & 0x8000;  // test most sig bit
  if (SignBit) // negative
  {
    TReading = (TReading ^ 0xffff) + 1; // 2's comp
  }
  Tc_100 = (6 * TReading) + TReading / 4;    // multiply by (100 * 0.0625) or 6.25
  Faren = (Tc_100 * 9 / 5) + 32;

  Whole = Tc_100 / 100;  // separate off the whole and fractional portions
  Fract = Tc_100 % 100;


  //if (SignBit) // If its negative
  //{
   //  Serial.print("-");
 // }
 // Serial.print(Whole);
 // Serial.print(".");
 // if (Fract < 10)
 // {
   //  Serial.print("0");
 // }
  //Serial.print(Fract);
  Serial.print(Faren);
  Serial.print("\n");
   //TMP36 code
 //getting the voltage reading from the temperature sensor
 int reading = analogRead(sensorPin);  
 // converting that reading to voltage
 float voltage = reading * 5.0;
 voltage /= 1024.0; 
 // print out the voltage
 Serial.print(voltage); Serial.println(" volts");
 // print out the temperature in Celcius
 float temperatureC = (voltage - 0.5) * 100 ;  //converting from 10 mv per degree wit 500 mV offset
                                               //to degrees ((volatge - 500mV) times 100)
 Serial.print(temperatureC); Serial.println(" degress C");
 
 // now convert to Fahrenheight
 float temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
 Serial.print(temperatureF); Serial.println(" degress F");
 
  // code that runs constantly.
  // check to see if it's time to blink the LED; that is, if the 
  // difference between the current time and last time you blinked 
  // the LED is bigger than the interval at which you want to 
  // blink the LED.
  delay(1000);
  unsigned long currentMillis = millis(); 
 
  if(currentMillis - previousMillis > interval) {
    // save the last time you blinked the LED 
   previousMillis = currentMillis;   

 } 
}
