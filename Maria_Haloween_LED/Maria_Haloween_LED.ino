//int ledPin2 = 9; // 2nd LED connected to digital pin 9
int ledPin = 10; // LED connected to digital pin 10
   

void setup()  { 
  // nothing happens in setup 
} 

void loop()  { 
  // fade in from min to max in increments of 5 points:
  for(int fadeValue = 20 ; fadeValue <= 255; fadeValue +=5) { 
    // sets the value (range from 0 to 255):
    analogWrite(ledPin, fadeValue); 
    //analogWrite(ledPin2, fadeValue);    
    // wait for 30 milliseconds to see the dimming effect    
    delay(30);                            
  } 

  // fade out from max to min in increments of 5 points:
  for(int fadeValue = 255 ; fadeValue >= 20; fadeValue -=5) { 
    // sets the value (range from 0 to 255):
    //analogWrite(ledPin2, fadeValue); 
    analogWrite(ledPin, fadeValue);    
    // wait for 30 milliseconds to see the dimming effect    
    delay(30);                            
  } 
}


