/*
 * WiiChuckDemo -- 
 *
 * 2008 Tod E. Kurt, http://thingm.com/
 *
 */

#include <Wire.h>
#include <Servo.h>
#include "nunchuck_funcs.h"

Servo myservo;

int loop_cnt=0;

byte accx,accy,zbut,cbut;
int ledPin = 13;

int pos = 90;

void setup()
{
    Serial.begin(19200);
    nunchuck_setpowerpins();
    nunchuck_init(); // send the initilization handshake
    
    Serial.print("WiiChuckDemo ready\n");
    myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
    myservo.write(pos);
    delay(100);
}

void loop()
{
    if( loop_cnt > 100 ) { // every 100 msecs get new data
        loop_cnt = 0;

        nunchuck_get_data();

        accx = nunchuck_accelx(); // ranges from approx 70 - 182
        pos  = map(accx, 70, 182, 0, 180);
        myservo.write(pos);
        delay(15); //wait for servo to get to pos
        accy = nunchuck_accely(); // ranges from approx 65 - 173
        zbut = nunchuck_zbutton();
        cbut = nunchuck_cbutton(); 
            
        Serial.print("accx: "); Serial.print((byte)accx,DEC);
        Serial.print("\taccy: "); Serial.print((byte)accy,DEC);
        Serial.print("\tzbut: "); Serial.print((byte)zbut,DEC);
        Serial.print("\tcbut: "); Serial.println((byte)cbut,DEC);
    }
    loop_cnt++;
    delay(1);
}

