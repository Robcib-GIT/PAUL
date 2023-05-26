#include <Wire.h>
#include <INA3221.h>

// Sensores
INA3221 ina_0(INA3221_ADDR40_GND);
double a;

// Medida de tiempo
long int t = 0;
long int tp = 0;
const int tmin = 1000;

void current_measure_init() {
    ina_0.begin(&Wire);
    ina_0.reset();
    ina_0.setShuntRes(100, 100, 100);
}

void setup() {
  // Comunicacion con el PC
  Serial.begin(9600);
  Wire.begin();
  current_measure_init();
}

void loop() {
  t = millis();

  if (t - tp >= tmin) {
    a = ina_0.getVoltage(INA3221_CH1);
    Serial.println(a);
    tp = t;
  }
}
