#include <SPI.h>


// set pin 10 as the slave select for the digital pot:
const int slaveSelectPin = 10;
// set channel we are testing to 4 (6 channels available)
const int channel = 4;
// the number of the LED pin
const int ledPin =  9;     


// Variables will change:
int ledState = LOW;
long previousMillis = 0;        // will store last time LED was updated

// the follow variables is a long because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long interval = 1000;           // interval at which to blink (milliseconds)

int sensorPin = 0; //the analog pin the TMP36 sensor pin is connected to
                        //the resolution is 10 mV / degree centigrade with a
                        //500 mV offset to allow for negative temperatures
                        
int digitalPotWrite(int address, int value) {
  // take the SS pin low to select the chip:
  digitalWrite(slaveSelectPin,LOW);
  //  send in the address and value via SPI:
  SPI.transfer(address);
  SPI.transfer(value);
  // take the SS pin high to de-select the chip:
  digitalWrite(slaveSelectPin,HIGH); 
  //end spi
}
                        
void setup() {
  // set the digital pin as output:
  // pinMode(ledPin, OUTPUT);   
  Serial.begin(9600);  //Start the serial connection with the computer
                       //to view the temperature output from TMP36 sensor open the serial monitor  
  // set the slaveSelectPin as an output:
  pinMode (slaveSelectPin, OUTPUT);
  // initialize SPI:
  SPI.begin();  
  // set ledPin to OUPUT so internal pullups will be applied
  pinMode(ledPin, OUTPUT);
}

void loop()
{
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
 
 //start spi
 // change the resistance on this channel from min to max:
 for (int level = 0; level < 255; level++) {
   digitalPotWrite(channel, level);
   delay(10);
  }
  // wait a 100 millaseconds at the max;
  delay(100);
  // change the resistance on this channel from max to min:
  for (int level = 0; level < 255; level++) {
    digitalPotWrite(channel, 255 - level);
    delay(10);
  }

  // code that runs constantly.
  // check to see if it's time to blink the LED; that is, if the 
  // difference between the current time and last time you blinked 
  // the LED is bigger than the interval at which you want to 
  // blink the LED.
  unsigned long currentMillis = millis(); 
 
  if(currentMillis - previousMillis > interval) {
    // save the last time you blinked the LED 
   previousMillis = currentMillis;   

   // if the LED is off turn it on and vice-versa:
   if (ledState == LOW)
     ledState = HIGH;
   else
     ledState = LOW;

   // set the ledState:
   digitalWrite(ledPin, ledState);
 } 
}

