/* RG Matrix Example   v.2 8/1/08  BroHogan
 * Demos 2 color 8x8 matrix driven by 2 MAX7821's 
 */
#include "WProgram.h"                   // needed to compile with Rel. 0013 WHY?!
#include "LedControl.h"                 // to drive the matrix
#define ISR_FREQ 190     //190=650Hz    // Sets the speed of the ISR - LOWER IS FASTER 
// prescaler is /128 -  125,000/ISR_FREQ+1 (i.e 249=500Hz, 190=650Hz) 
// Tweaked depending on the overhead in the ISR & and other factors in the sketch
// Display will be slow if too FAST. Sketch will hang on delay() if way too fast!

#define GREEN 0                         // The address of the MAX7221 for the green leds
#define RED 1                           // The address of the MAX7221 for the red leds
int maxInShutdown=GREEN;                // tells which MAX7221 is currently off 
unsigned long ISRTime;                   // DEBUG to test how long in ISR

LedControl lc=LedControl(10,9,8,2); // pins 10=DataIn, 9=CLK, 8=LOAD + 2 MAX7221s 

void setup() {
  lc.setIntensity(GREEN,15);            // 0 = dim, 15 = full brightness
  lc.setIntensity(RED,12);              // red needs less brightness
  setISRtimer();                        // setup the timer
  startISR();                           // start the timer to toggle shutdown
}

void loop() { 
  // Simple demo, but gives 2 colors a pretty good workout
  SkipRows();
  delay(1000);
  ClearMatrix();
  delay(500);
}

/////////////////////////////ISR Timer Functions ///////////////////////////
ISR(TIMER2_COMPA_vect) {  //This ISR toggles shutdown between the 2MAX7221's
  if(maxInShutdown==RED){
    lc.shutdown(GREEN,true);  // The order here is critical - Shutdown first!
    lc.shutdown(RED,false);   // . . . Then restart the other.
    maxInShutdown=GREEN;
  }
  else {
    lc.shutdown(RED,true);
    lc.shutdown(GREEN,false);
    maxInShutdown=RED;
  }
}  

void setISRtimer(){  // setup ISR timer controling toggleing
  TCCR2A = 0x02;                        // WGM22=0 + WGM21=1 + WGM20=0 = Mode2 (CTC)
  TCCR2B = 0x05;                // CS22=1 + CS21=0 + CS20=1 = /128 prescaler (125kHz)
  TCNT2 = 0;                            // clear counter
  OCR2A = ISR_FREQ;                     // set TOP (divisor) - see #define
}

void startISR(){  // Starts the ISR
  TCNT2 = 0;                            // clear counter (needed here also)
  TIMSK2|=(1<<OCIE2A);                  // set interrupts=enabled (calls ISR(TIMER2_COMPA_vect)
}

void stopISR(){    // Stops the ISR
  TIMSK2&=~(1<<OCIE2A);                  // disable interrupts
}

//////////////////////// simple LED display routine /////////////////////////////
void SkipRows() { // 1st pass alternates green & red, 2nd adds green to red making orange
  byte greenOn = true;                  // flag for lighting green for orange
  for(int row=0;row<8;row++) {
    for(int col=0;col<8;col++) {
      if (greenOn == true) SetLed(GREEN,row,col,true);
      else SetLed(RED,row,col,true);
      greenOn = !greenOn;
    }
  }
  delay(500);                           // only so you can see the first pass
  greenOn = !greenOn;
  for(int row=0;row<8;row++) {
    for(int col=0;col<8;col++) {
      delay(4);                         // only so you can see the update
      if (greenOn == true) SetLed(GREEN,row,col,true);
      greenOn = !greenOn;
    }
  }
}

/////////   Wrappers for LedControl functions . . . //////////
void SetLed(byte Color, byte Row,byte Col, byte State){
  stopISR();            // disable interrupts - stop toggling shutdown when updating
  lc.setLed(Color,Row,Col,State);
  startISR();           // enable interrupts again
}

void SetRow(byte Color, byte Row, byte State){
  stopISR();            // disable interrupts - stop toggling shutdown when updating
  lc.setRow(Color,Row,State);
  startISR();           // enable interrupts again
}

void SetColumn(byte Color, byte Col, byte State){
  stopISR();            // disable interrupts - stop toggling shutdown when updating
  lc.setColumn(Color,Col,State);
  startISR();           // enable interrupts again
}

void ClearMatrix(){
  stopISR();            // disable interrupts - stop toggling shutdown when updating
  lc.clearDisplay(GREEN);
  lc.clearDisplay(RED);
  startISR();           // enable interrupts again
}
