#define SER_BAUD  9600

#define PIN_SCE   7
#define PIN_RESET 6
#define PIN_DC    5
#define PIN_SDIN  4
#define PIN_SCLK  3

#define LCD_C     LOW
#define LCD_D     HIGH

void LcdClear(void)
{
  for (int index = 0; index < 84 * 48 / 8; index++)
  {
    LcdWrite(LCD_D, 0x00);
  }
}

void LcdInitialise(void)
{
  pinMode(PIN_SCE, OUTPUT);
  pinMode(PIN_RESET, OUTPUT);
  pinMode(PIN_DC, OUTPUT);
  pinMode(PIN_SDIN, OUTPUT);
  pinMode(PIN_SCLK, OUTPUT);
  digitalWrite(PIN_RESET, LOW);
  digitalWrite(PIN_RESET, HIGH);
  LcdWrite(LCD_C, 0x22);
  LcdWrite(LCD_C, 0x0C);
  LcdClear();
}

void LcdWrite(byte dc, byte data)
{
  digitalWrite(PIN_DC, dc);
  digitalWrite(PIN_SCE, LOW);
  shiftOut(PIN_SDIN, PIN_SCLK, MSBFIRST, data);
  digitalWrite(PIN_SCE, HIGH);
}

void SerialInitialise(void) {
  Serial.begin(SER_BAUD);
}

void SerialRead(void) {
  if (Serial.available())
  {
    while (Serial.available())
    {
      LcdWrite(LCD_D, Serial.read());
    }
  }
}

void setup(void)
{
  LcdInitialise();
  SerialInitialise();
}

void loop(void)
{
  SerialRead();
}

