Null routing an IP can be of great help while preventing a server against a DDoS attack.
In order to null route an IP you can do the following:
1) Login to the server as root.
2) Issue following command
[root@server~]# route add XX.XX.XX.XX gw 127.0.0.1 lo
OR
[root@server~]# route add -host XX.XX.XX.XX reject
Considering the XX.XX.XX.XX is the IP to be null routed.
3) In order to check the above configuration you can issue following command.
[root@server~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.20.104.7   0.0.0.0         255.255.255.255 UH    0      0        0 eth0
XX.XX.XX.XX    -               255.255.255.255 !H    0      -        0 -
Now you can observer the IP XX.XX.XX.XX with “-” as it’s gateway. This will cause your server to drop all response traffic to this IP.
4) To confirm the null routing status, use ip command as follows:
[root@server~]# ip route get XX.XX.XX.XX
RTNETLINK answers: Network is unreachable
5) Also you can drop an entire subnet with following:
Drop entire subnet 192.168.0.0/24:
[root@server~]# route add -net 192.168.0.0/24 gw 127.0.0.1 lo
OR
[root@server~]# route add -net 192.168.0.0/24 reject
6) In order to remove the null route to the IP  use following command:
[root@server~]# route delete XX.XX.XX.XX
	
	
	
	
long previousMillis = 0;        // will store last time LED was updated

// the follow variables is a long because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long interval = 1000;           // interval at which to blink (milliseconds)

int sensorPin = 0; //the analog pin the TMP36 sensor pin is connected to
                        //the resolution is 10 mV / degree centigrade with a
                        //500 mV offset to allow for negative temperatures
                        

                        
void setup() {
  
  Serial.begin(9600);  //Start the serial connection with the computer
                       //to view the temperature output from TMP36 sensor open the serial monitor  
}

void loop()
{
 //TMP36 code
 //getting the voltage reading from the temperature sensor
 int reading = analogRead(sensorPin);  
 // converting that reading to voltage
 float voltage = reading * 5.0;
 voltage /= 1024.0; 
 // print out the voltage
 Serial.print(voltage); Serial.println(" volts");
 // print out the temperature in Celcius
 float temperatureC = (voltage - 0.5) * 100 ;  //converting from 10 mv per degree wit 500 mV offset
                                               //to degrees ((volatge - 500mV) times 100)
 Serial.print(temperatureC); Serial.println(" degress C");
 
 // now convert to Fahrenheight
 float temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
 Serial.print(temperatureF); Serial.println(" degress F");
 
  // code that runs constantly.
  // check to see if it's time to blink the LED; that is, if the 
  // difference between the current time and last time you blinked 
  // the LED is bigger than the interval at which you want to 
  // blink the LED.
  delay(1000);
  unsigned long currentMillis = millis(); 
 
  if(currentMillis - previousMillis > interval) {
    // save the last time you blinked the LED 
   previousMillis = currentMillis;   

 } 
}
