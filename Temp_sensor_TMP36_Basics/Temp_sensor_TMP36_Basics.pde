 
//TMP36 Pin Variables
int sensorPin = 0; //the analog pin the TMP36's Vout (sense) pin is connected to
                        //the resolution is 10 mV / degree centigrade with a
                        //500 mV offset to allow for negative temperatures

#define BANDGAPREF 14   // special indicator that we want to measure the bandgap

/*
 * setup() - this function runs once when you turn your Arduino on
 * We initializ the serial connection with the computer
 */
int rotopin =  8;    // roto connected to digital pin 8

void setup()
{
  Serial.begin(57600);  //Start the serial connection with the computer to view the result open the serial monitor 
  pinMode(rotopin, OUTPUT);     
  delay(1500);
}
 
void loop()                     // run over and over again
{
  // get voltage reading from the secret internal 1.05V reference
  int refReading = analogRead(BANDGAPREF);  
//bjw  Serial.println(refReading);
  
  // now calculate our power supply voltage from the known 1.05 volt reading
  float supplyvoltage = (1.05 * 1024) / refReading;
//bjw  Serial.print(supplyvoltage); Serial.println("V power supply");
  
  //getting the voltage reading from the temperature sensor
  int reading = analogRead(sensorPin);  

  // converting that reading to voltage
  float voltage = reading * supplyvoltage / 1024; 
 
  // print out the voltage
//bjw  Serial.print(voltage); Serial.println(" volts");
 
  // now print out the temperature
  float temperatureC = (voltage - 0.5) * 100 ;   //converting from 10 mv per degree wit 500 mV offset
                                               //to degrees ((volatge - 500mV) times 100)
//bjw  Serial.print(temperatureC); Serial.println(" degress C");
 
  // now convert to Fahrenheight
  float temperatureF = (temperatureC * 9 / 5) + 32;
  Serial.print(temperatureF); Serial.println(" degress F");
  
//  digitalWrite(rotopin, HIGH);   
//  delay(100);                
//  digitalWrite(rotopin, LOW); 
 
 
  delay(1000);                                     //waiting a second
}

