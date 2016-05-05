/*******************************************************************
  Tap tempo sketch for Adafruit Trinket.  Tap a button in sync with
  a beat, LED display shows beats per minute.  Stop tapping for
  4 second to reset counter.

  Required libraries include TinyWireM, Adafruit_LEDBackpack and
  Adafruit_GFX.

  Required hardware includes an Adafruit Trinket microcontroller
  (5V or 3.3V), an Adafruit 7-Segment LED Backpack, and a momentary,
  normally-open pushbutton.

  As written, this is specifically for the Trinket; would need
  modifications on other boards (Arduino Uno, etc.).

  Trinket :   5V/3V   Gnd   Pin #0   Pin #2
  Backpack:     +      -      D        C

  Pushbutton between Pin #1 and 5V/3V.
 *******************************************************************/

#include <TinyWireM.h>
#include <Adafruit_LEDBackpack.h>
#include <Adafruit_GFX.h>
#include <avr/power.h>

Adafruit_7segment disp = Adafruit_7segment();

unsigned long
  prevBeat = 0L, // Time of last button tap
  sum      = 0L; // Cumulative time of all beats
uint16_t
  nBeats   = 0;  // Number of beats counted
uint8_t
  prevButton;    // Value of last digitalRead()

void setup() {
  if(F_CPU == 16000000) clock_prescale_set(clock_div_1);
  disp.begin(0x70);
  prevButton = digitalRead(1);
}

static unsigned long debounce() { // Waits for change in button state
  uint8_t       b;
  unsigned long start, last;
  long          d;

  start = micros();

  for(;;) {
    last = micros();
    while((b = digitalRead(1)) != prevButton) { // Button changed?
      if((micros() - last) > 25000L) {          // Sustained > 25 mS?
        prevButton = b;                         // Save new state
        return last;                            // Return time of change
      }
    } // Else button unchanged...do other things...

    d = (last - start) - 4000000L; // Function start time minus 4 sec
    if(d > 0) {                    // > 4 sec with no button change?
      nBeats = 0;                  // Reset counters
      prevBeat = sum = 0L;
    }

    // If no prior tap has been registered, program is waiting
    // for initial tap.  Show instructions on display.
    if(!prevBeat) {
      if(!(d & 0x00100000)) { // ~1.05 second cycle
        disp.writeDigitRaw(0, 0x78); // t
        disp.writeDigitRaw(1, 0x77); // A
        disp.writeDigitRaw(3, 0x73); // P
        disp.writeDigitRaw(4, 0x00);
      } else {
        disp.writeDigitRaw(0, 0x7C); // b
        disp.writeDigitRaw(1, 0x79); // E
        disp.writeDigitRaw(3, 0x77); // A
        disp.writeDigitRaw(4, 0x78); // t
      }
      disp.writeDisplay();
    }
  }
}

void loop() {
  unsigned long t;
  uint16_t      b;

  t = debounce(); // Wait for new button state

  if(prevButton == HIGH) {             // Low-to-high (button tap)?
    if(prevBeat) {                     // Button tapped before?
      nBeats++;
      sum += 600000000L / (t - prevBeat); // BPM * 10
      b    = (sum / nBeats);           // Average time per tap
      if(b > 9999) b = 9999;
      disp.print(b);
      disp.writeDigitNum(3, (b/10)%10, true); // .
    } else {                           // First tap
      disp.clear();                    // Clear display, but...
      disp.writeDigitRaw(3, 0x80);     // a dot shows it's on
    }
    disp.writeDisplay();
    prevBeat = t;                      // Record time of last tap
  }
}
