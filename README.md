# tfe4208

# PiWedge pinout
Mappinge til PiWedge er ikke 1 til 1 med GPIO pinsene derfor trenger vi denne

PWM0 (GPIO0) -> 3V3
PWM1 (GPIO1) -> 5V
PWM2 (GPIO2) -> SDA

5V -> G17
GND(5V) -> G18

DI0 (GPIO33) -> G20 
DI1 (GPIO32) -> G26
DI2 (GPIO31) -> G16
DI3 (GPIO30) -> G19

CE (GPIO25) -> IDSC
SCK (GPIO24) -> IDSD

3V3 -> G5
GND (3V3) -> GND

Debug:
Corr ValidOut (GPIO12) G22
Peak ValidOut (GPIO13) G23
SPI  ValidOut (GPIO15) G24