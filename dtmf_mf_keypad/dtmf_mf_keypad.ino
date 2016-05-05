
// DTMF/MF/SF "BlueBox" Dialer
// http://en.wikipedia.org/wiki/Blue_box
// ^^^ MF/DTMF freqs can be found on wiki page
// 2600Hz should always be 1500ms duration 
// [DT]MF tones 75 or 120ms duration       
// After trunk seizure, MF is KP+digits+ST (KP,x,y,z,ST) e.g.
// To dial MF 101 (13,1,0,1,ST) = playMF(phone_number[13], TONE_LENGTH); 
//                                playMF(phone_number[1], TONE_LENGTH); 
//                                playMF(phone_number[0], TONE_LENGTH); 
//                                playMF(phone_number[14], TONE_LENGTH);
//
#include <Tone.h>
#include <Keypad.h>
//
//Tone setups
Tone freq1;
Tone freq2;
//                            0     1     2     3     4     5     6     7     8     9   10,*  11,#  12,A  13,B  14,C  15,D  16/SF(2600)
const int DTMF_freq1[] = { 1336, 1209, 1336, 1477, 1209, 1336, 1477, 1209, 1336, 1477,  1209, 1477, 1633, 1633, 1633, 1633,       2600 };
const int DTMF_freq2[] = {  941,  697,  697,  697,  770,  770,  770,  852,  852,  852,   941,  941,  697,  770,  852,  941,       2600  };

//                          0    1     2     3     4     5     6     7     8     9 10/ST3 11/ST2  12/ST3  13/KP 14/ST 15/SF(2600)
const int MF_freq1[] = { 1300, 700,  700,  900,  700,  900, 1100,  700,  900, 1100,   700,    900,  1100,  1300, 1500,      2600 };
const int MF_freq2[] = { 1500, 900, 1100, 1100, 1300, 1300, 1300, 1500, 1500, 1500,  1700,   1700,  1700,  1700, 1700,      2600  };
//
const int TONE_LENGTH = 120;     // Min 40 for detection on LED (ms)
const int TONE_WAIT = 500;       // This is how long to wait after triggering a [DT]MF call (ms)
const int TONE_LOOP_WAIT = 2000; // Wait this long after loop (ms)
//
//Keypad setups
const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns
//define the cymbols on the buttons of the keypads
char hexaKeys[ROWS][COLS] = {
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}
};
//
byte rowPins[ROWS] = {9,8,7,6}; //Rows 0 to 3
byte colPins[COLS]= {5,4,3,2}; //Columns 0 to 3
//initialize an instance of class NewKeypad
Keypad customKeypad = Keypad( makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS); 
//
//
void setup()
{
  Serial.begin(9600);
  freq1.begin(11);
  freq2.begin(12);
}

void playDTMF(uint8_t number, long duration)
{
  freq1.play(DTMF_freq1[number], duration);
  freq2.play(DTMF_freq2[number], duration);
}

void playMF(uint8_t number, long duration)
{
  freq1.play(MF_freq1[number], duration);
  freq2.play(MF_freq2[number], duration);
}

void loop()
{
  int i;
  uint8_t phone_number[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};

  while(1){
    char customKey = customKeypad.getKey();
  
    if (customKey){
      Serial.println(customKey);
      switch (customKey) {
        case '1':
          playMF(phone_number[1], TONE_LENGTH);
          break;
        case '2':
          playMF(phone_number[2], TONE_LENGTH);
          break;
        case '3':
          playMF(phone_number[3], TONE_LENGTH);
          break;
        case '4':
          playMF(phone_number[4], TONE_LENGTH);
          break;
        case '5':
          playMF(phone_number[5], TONE_LENGTH);
          break;
        case '6':
          playMF(phone_number[6], TONE_LENGTH);
          break;
        case '7':
           playMF(phone_number[7], TONE_LENGTH);
           break;
        case '8':
           playMF(phone_number[8], TONE_LENGTH);
           break;
        case '9':
           playMF(phone_number[9], TONE_LENGTH);
           break;
        case '*': // Key Pulse or KP
           playMF(phone_number[13], TONE_LENGTH);
           break;
        case '0':
           playMF(phone_number[0], TONE_LENGTH);
           break;
        case 'A': //2600Hz SF 1500ms
           freq1.play(2600, 1500);
           break;
        case '#': // Start or ST
           playMF(phone_number[14], TONE_LENGTH); 
           break;
       }
    delay(150);
    } 
  }
}
