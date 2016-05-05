int REDPin = 6;    // RED pin of the LED to PWM pin 4
int GREENPin = 5;  // GREEN pin of the LED to PWM pin 5
int BLUEPin = 4;   // BLUE pin of the LED to PWM pin 6
int brightness = 255; // LED brightness
int increment = 5;  // brightness increment
int fanpin = 3;

void setup()
{
  pinMode(REDPin, OUTPUT);
  pinMode(GREENPin, OUTPUT);
  pinMode(BLUEPin, OUTPUT);
//  pinMode(fanpin, OUTPUT);

  Serial.begin(9600);
  digitalWrite(fanpin, HIGH);
}

void loop()
{
  //brightness = brightness + increment;  // increment brightness for next loop iteration

 // if (brightness <= 0 || brightness >= 255)    // reverse the direction of the fading
 // {
 //   increment = -increment;
//  }
 // brightness = constrain(brightness, 0, 255);
  analogWrite(REDPin, brightness);
  delay(50);
  analogWrite(GREENPin, brightness);
  delay(50);
 analogWrite(BLUEPin, brightness);
  delay(50);
  
 // delay(20);  // wait for 20 milliseconds to see the dimming effect
}