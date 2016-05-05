/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */

void setup() {                
  // initialize the digital pin as an output.
  pinMode(2, OUTPUT);     
}

void loop() {
  digitalWrite(2, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(2, LOW);    // set the LED off
  delay(1000);              // wait for a second
}
