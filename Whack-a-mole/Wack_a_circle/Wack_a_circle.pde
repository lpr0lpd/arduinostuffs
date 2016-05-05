#include "ST7565.h"
#include <stdint.h>
#include "TouchScreen.h"

#define YP A2  // must be an analog pin, use "An" notation!
#define XM A3  // must be an analog pin, use "An" notation!
#define YM 4   // can be a digital pin
#define XP 3   // can be a digital pin

int ledPin =  13;    // LED connected to digital pin 13
int hapticPin = 2; //vibration motor connected to digital pin 2     

TouchScreen ts = TouchScreen(XP, YP, XM, YM, 300);

// the LCD backlight is connected up to a pin so you can turn it on & off
#define BACKLIGHT_LED 10

// pin 9 - Serial data out (SID)
// pin 8 - Serial clock out (SCLK)
// pin 7 - Data/Command select (RS or A0)
// pin 6 - LCD reset (RST)
// pin 5 - LCD chip select (CS)
ST7565 glcd(9, 8, 7, 6, 5);


// The setup() method runs once, when the sketch starts
void setup()   {                
  Serial.begin(9600);
  
  // turn on backlight
  pinMode(BACKLIGHT_LED, OUTPUT);
  digitalWrite(BACKLIGHT_LED, LOW);

  pinMode(hapticPin, OUTPUT);
  
  // initialize and set the contrast to 0x18
  glcd.begin(0x18);
  glcd.clear();
  randomSeed(analogRead(0));
} 

void loop() {                   
  int x,y,cdelay,radius;
  x=random(10,123);
  y=random(10,61);
  cdelay=random(100,400);
  radius=10;
  // draw a black circle, at location x=32,y=32,10 pixel radius
  glcd.fillcircle(x, y, radius, BLACK);
  glcd.display();
  delay(cdelay);
  Point p = ts.getPoint();
  if (p.z > 0) {
  //digitalWrite(hapticPin, HIGH);
  //delay(100);
  //digitalWrite(hapticPin, LOW);
  //bjw delay(cdelay);
  glcd.fillcircle(p.x, p.y, radius, 0);
  glcd.display();
  }
//  glcd.clear();
}
