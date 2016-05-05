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

  // turn on backlight
  pinMode(BACKLIGHT_LED, OUTPUT);
  digitalWrite(BACKLIGHT_LED, HIGH);

  pinMode(hapticPin, OUTPUT);
  
  // initialize and set the contrast to 0x18
  glcd.begin(0x18);
  glcd.clear();
  glcd.display();  
} 

void loop() {                   
  int radius;
  long x,y;
  radius=1;
  Point p = ts.getPoint();
  if (p.z > ts.pressureThreshhold) {
  //digitalWrite(hapticPin, HIGH);
  //delay(45);
  //digitalWrite(hapticPin, LOW);
    if (p.x < 200 && p.y < 200 ) {
      glcd.clear();
      glcd.display();
      exit;
    } 
  y = map(p.x, 925, 260, 0, 63);
  x = map(p.y, 70, 960, 0, 127);
  
  glcd.fillcircle(x, y, radius, 1);
  //glcd.setpixel(x, y, 1);
  glcd.display();
  }
}
