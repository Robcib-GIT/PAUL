#include <Wire.h>
#include <INA3221.h>
INA3221 ina_0(INA3221_ADDR40_GND);

const int dirPin = 7;
const int stepPin = 46;
const int enable = 50;

const int steps = 1;
long int stepDelay;
int ok = 0;
double datos, elong;

void current_measure_init() {
    ina_0.begin(&Wire);
    ina_0.reset();
    ina_0.setShuntRes(100, 100, 100);
}

void setup() {
   Serial.begin(9600);
   Wire.begin();
   
   pinMode(dirPin, OUTPUT);
   pinMode(stepPin, OUTPUT);
   pinMode(enable, OUTPUT);

   current_measure_init();
}

void loop() {
  digitalWrite(enable, HIGH);
  if(Serial.available()){
    String ok_cadena = Serial.readString();
    int ok = ok_cadena.toInt();
    if(ok == 1){
      elong = 170.2;
      for(int i = 0; i <= 500; i++){
          datos = ina_0.getVoltage(INA3221_CH1);
          Serial.print(datos);
          Serial.print(" ");
          Serial.println(elong);
      }
      digitalWrite(enable, LOW);
      digitalWrite(dirPin, LOW);
      stepDelay = 20;
      for(int i = 1; i <= 260; i++){
          elong = elong + PI*1.8*15/180;
          digitalWrite(stepPin, HIGH);
          delay(stepDelay);
          digitalWrite(stepPin, LOW);
          delay(stepDelay);
          datos = ina_0.getVoltage(INA3221_CH1);
          Serial.print(datos);
          Serial.print(" ");
          Serial.println(elong);
       }
       Serial.print("-1"); 
       Serial.print(" "); 
       Serial.println("-1");
       delay(500);
       digitalWrite(dirPin, HIGH);
       for(int k = 1; k <= 260; k++){
          elong = elong - PI*1.8*15/180;
          digitalWrite(stepPin, HIGH);
          delay(stepDelay);
          digitalWrite(stepPin, LOW);
          delay(stepDelay);
          datos = ina_0.getVoltage(INA3221_CH1);
          Serial.print(datos);
          Serial.print(" ");
          Serial.println(elong);
       }
       elong = 170.2;
       for(int i = 0; i <= 1000; i++){
          datos = ina_0.getVoltage(INA3221_CH1);
          Serial.print(datos);
          Serial.print(" ");
          Serial.println(elong);
       }
       Serial.println("finish");
    }
  }
}
