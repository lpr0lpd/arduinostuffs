#include "ST7565.h"
#include <stdio.h>

int AI1Raw = 0;
int photocellPin = 1;
int photocellReading;
int ledPin = 11;
int ledBrightness;
char msg[32];
int reading;
float volts;
float tempC;
float tempF;
#define BACKLIGHT_LED 10
int x,y;

ST7565 glcd(9, 8, 7, 6, 5);
#define LOGO16_GLCD_HEIGHT 16
#define LOGO16_GLCD_WIDTH  16 

void setup()
{
  Serial.begin(9600);
  pinMode(BACKLIGHT_LED, OUTPUT);
  digitalWrite(BACKLIGHT_LED, HIGH);
  glcd.st7565_init();
  glcd.st7565_command(CMD_DISPLAY_ON);
  glcd.st7565_command(CMD_SET_ALLPTS_NORMAL);
  glcd.st7565_set_brightness(0x18);
}

void loop()
{
//  photocellReading = analogRead(photocellPin);

//  Serial.print(photocellReading); Serial.println(" Analog Reading");

//  photocellReading = 1023 - photocellReading;

//  ledBrightness = map(photocellReading, 0, 1023, 0, 255);
  analogWrite(ledPin, HIGH);

  delay(100);

  reading = analogRead(AI1Raw);

  volts = reading * 5.0;
  volts /= 1024.0;
  Serial.print(volts); Serial.println(" volts");
  tempC = (volts - 0.5) * 100;
  Serial.print(tempC); Serial.println(" degrees C");
  tempF = (tempC * 9.0 /5.0) + 32.0;
  Serial.print(tempF); Serial.println(" degrees Faginit");
  sprintf(msg,"Current Temp: %dF", (int)tempF);  
 
  glcd.drawstring(0, 0, msg);
  for (x=0;x<127;x++) {
//  glcd.drawstring(x,50, ".");
  glcd.setpixel(x, 10, BLACK);
  glcd.display();
//  glcd.setpixel(5+x,5+x, BLACK);
  glcd.setpixel(75, 75, BLACK);
  glcd.display();
    delay(500);

  }
  
  glcd.display();    

  delay(500);

  glcd.clear();
}
