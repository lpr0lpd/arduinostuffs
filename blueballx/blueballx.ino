/*
Chameleon Box
by: Nick Poole @ FringeneeringLabs
Borrowing from the Keyboard Library example code by Alexander Brevig
*/
#include <Tone.h> // This library allows the Arduino to generate more than one tone at once
#include <Keypad.h> // This library makes it easy to use a key matrix
Tone notePlayer[2]; // Declaring two tone generators as an array
const byte ROWS = 4; // Four rows of keys
const byte COLS = 3;  // Three columns 

//define the symbols on the buttons of the keypads,
//makes the code easier to understand down the line.
char hexaKeys[ROWS][COLS] = {
  {'1','2','3',},
  {'4','5','6',},
  {'7','8','9',},
  {'*','0','#',}
};
byte rowPins[ROWS] = {5, 4, 3, 2}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {8, 7, 6}; //connect to the column pinouts of the keypad

//initialize an instance of class NewKeypad
Keypad customKeypad = Keypad( makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS); 

void setup(){
  Serial.begin(9600); // Pour a bowl of Serial
  notePlayer[0].begin(9); // Initialize our first tone generator
  notePlayer[1].begin(10); // Initialize our second tone generator
  pinMode(11, OUTPUT); // Green LED 
  pinMode(12, OUTPUT); // Red LED
  pinMode(13, OUTPUT); // Blue LED

}
  
void loop(){ //Main loop is the boot select. Allows the unit to start in one of several modes

     char customKey = customKeypad.getKey();
  
  if (customKey){
 
    if(customKey=='1'){beigeBox();}; // Dial DTMF Tones
    if(customKey=='2'){blueBox();}; // Dial MF Tones
    if(customKey=='3'){redBox();}; // Dial Payphone Coin Tones
    if(customKey=='4'){greenBox();}; // Dial Payphone Control Tones
    if(customKey=='5'){silverBox();}; // Dial Autovon Priority Tones & 2600Hz
   
  }
}

void beigeBox(){
  
  /*
  The BeigeBox is a lineman's handset. It dials DTMF tones just like a home phone would have. 
  What makes the BeigeBox special is that instead of a phone jack, the signal lines are terminated
  with alligator clips, allowing you to tap a line from a junction box. 
  */
  
  digitalWrite(11, HIGH);
  digitalWrite(12, HIGH);
  digitalWrite(13, LOW);
  
 while(1){ 
  
    char customKey = customKeypad.getKey();
  
  if (customKey){
  
   switch (customKey) {

    case '1':
    notePlayer[0].play(1209);
    notePlayer[1].play(697);
    break;
   case '2':
    notePlayer[0].play(1336);
    notePlayer[1].play(697);
    break;
   case '3':
    notePlayer[0].play(1477);
    notePlayer[1].play(697);
    break;
   case '4':
    notePlayer[0].play(1209);
    notePlayer[1].play(770);
    break;
   case '5':
    notePlayer[0].play(1336);
    notePlayer[1].play(770);
    break;
   case '6':
    notePlayer[0].play(1477);
    notePlayer[1].play(770);
    break;
   case '7':
    notePlayer[0].play(1209);
    notePlayer[1].play(852);
    break;
   case '8':
    notePlayer[0].play(1336);
    notePlayer[1].play(852);
    break;
   case '9':
    notePlayer[0].play(1477);
    notePlayer[1].play(852);
    break;
   case '*':
    notePlayer[0].play(1209);
    notePlayer[1].play(941);
    break;
   case '0':
    notePlayer[0].play(1336);
    notePlayer[1].play(941);
    break;
   case '#':
    notePlayer[0].play(1477);
    notePlayer[1].play(941);
    break;
    }
    delay(60);
    notePlayer[0].stop();
    notePlayer[1].stop();    
  }
  
  
}}

void redBox(){

 /*
 When a payphone accepted change, it would report this by playing a series of chirps up the line
 the operator. The RedBox generates these chirps and allowed a phreak to make free phone calls 
 by tricking the phone into believing that the call had been paid for. 
 */

  digitalWrite(11, LOW);
  digitalWrite(12, HIGH);
  digitalWrite(13, LOW);  
 
  while(1){
   
    char customKey = customKeypad.getKey();
  
  if (customKey){
  
   switch (customKey) { 

    case '1': // Nickels
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
    delay(66);
    notePlayer[0].stop();
    notePlayer[1].stop();    
    
    break;
   case '2': // Dimes
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(66);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    delay(66);
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(66);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    
    break;
    
   case '3': // Quarters
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(33);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    delay(33);
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(33);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    delay(33);
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(33);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    delay(33);
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(33);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    delay(33);
    notePlayer[0].play(1700);
    notePlayer[1].play(2200);
        delay(33);
    notePlayer[0].stop();
    notePlayer[1].stop();  
    delay(33);
    break;
    }
    notePlayer[0].stop();
    notePlayer[1].stop();    
  }
  
}}

void blueBox(){
  
  /*
  The BlueBox, perhaps the best known phreak box, generates "MF" or "Multi-Frequency" tones,
  these are the tones used connect long distance calls. Using a BlueBox was simple. You 
  would begin the call to a free long-distance number, such as directory assistance in another 
  area code, thus opening a long-distance line. You would then play a 2600Hz tone, signalling to 
  the long distance number that you had disconnected, it would then disconnect leaving you on
  a trunk line by yourself. Now you had a long distance line which was billed for $0.00/hr. In 
  order to dial on the line, you would have to dial MF tones, preceded by a Key Pulse
  ('#' on our BlueBox) and punctuated with a Start ('*' in the code)
  */
  
  digitalWrite(11, LOW);
  digitalWrite(12, LOW);
  digitalWrite(13, HIGH); 

  while(1){
   
    char customKey = customKeypad.getKey();
  
  if (customKey){
  
   switch (customKey) {

    case '1':
    notePlayer[0].play(700);
    notePlayer[1].play(900);
    break;
   case '2':
    notePlayer[0].play(700);
    notePlayer[1].play(1100);
    break;
   case '3':
    notePlayer[0].play(900);
    notePlayer[1].play(1100);
    break;
   case '4':
    notePlayer[0].play(700);
    notePlayer[1].play(1300);
    break;
   case '5':
    notePlayer[0].play(900);
    notePlayer[1].play(1300);
    break;
   case '6':
    notePlayer[0].play(1100);
    notePlayer[1].play(1300);
    break;
   case '7':
    notePlayer[0].play(700);
    notePlayer[1].play(1500);
    break;
   case '8':
    notePlayer[0].play(900);
    notePlayer[1].play(1500);
    break;
   case '9':
    notePlayer[0].play(1100);
    notePlayer[1].play(1500);
    break;
   case '*': // "Start" or ST tone
    notePlayer[0].play(1500);
    notePlayer[1].play(1700);
    break;
   case '0':
    notePlayer[0].play(1300);
    notePlayer[1].play(1500);
    break;
   case '#': // Key Pulse or KP
    notePlayer[0].play(1100);
    notePlayer[1].play(1700);
    break;
    }
    delay(60);
    notePlayer[0].stop();
    notePlayer[1].stop();    
  }
  
}}

void greenBox(){
  
  /*
  The GreenBox is another payphone manipulator. This one generates the tones which were used by 
  payphone operators to control the coin collection mechanism of the payphone remotely. Each
  tone was preceded by a 2600Hz chirp and lasted 900ms. There are three tones on a classic 
  GreenBox: Coin Collect, Coin Return and Ring Back. 
  */
  
  digitalWrite(11, HIGH);
  digitalWrite(12, LOW);
  digitalWrite(13, LOW);  

  while(1){

     char customKey = customKeypad.getKey();
  
  if (customKey){
  
   switch (customKey) {

    case '1': // Coin Collect
    notePlayer[0].play(2600);
    delay(90);
    notePlayer[0].stop();
    delay(60);
    notePlayer[0].play(700);
    notePlayer[1].play(1100);
    break;
   case '2': // Coin Return
    notePlayer[0].play(2600);
    delay(90);
    notePlayer[0].stop();
    delay(60);
    notePlayer[0].play(1700);
    notePlayer[1].play(1100);
    break;
   case '3': // Ringback
    notePlayer[0].play(2600);
    delay(90);
    notePlayer[0].stop();
    delay(60);
    notePlayer[0].play(700);
    notePlayer[1].play(1700);
    break;
    }
    delay(900);
    notePlayer[0].stop();
    notePlayer[1].stop();    
  }   

  
}}

void silverBox(){
  
  /*
  "SilverBox" is the nickname given to a keypad which included the original "fourth column" 
  of keys, which controlled the (long obsolete) Autovon phone system. This system was used
  to assign call-priority. Our "SilverBox" emulator will generate the four priority tones
  and the 2600Hz tone (on '*' key)
  */
  
  digitalWrite(11, HIGH);
  digitalWrite(12, HIGH);
  digitalWrite(13, HIGH); 

  while(1){
   
    char customKey = customKeypad.getKey();
  
  if (customKey){
  
   switch (customKey) {

    case '1': // A: FO; Flash Override 
    notePlayer[0].play(697);
    notePlayer[1].play(1633);
    break;
   case '2': // B: F; Flash
    notePlayer[0].play(770);
    notePlayer[1].play(1633);
    break;
   case '3': // C: I; Immediate 
    notePlayer[0].play(852);
    notePlayer[1].play(1633);
    break;
   case '4': // D: P; Priorty
    notePlayer[0].play(941);
    notePlayer[1].play(1633);
    break;
   case '*': // 2600Hz "Supervisory Signal"
    notePlayer[0].play(2600);
    delay(1000);
    break;
    }
    delay(60);
    notePlayer[0].stop();
    notePlayer[1].stop();    
  }
  
}}
