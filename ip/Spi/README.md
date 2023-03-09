# Her kommer dokumentasjon

Simulering kan kjøres fra sim-mappen med "./simulate.sh"

# Mer dokumentasjon...

# Noen quirks
 - Det ser ut som at GPIO regnes som en hel I/O bank ergo må alle være enten input eller output type. For å unngå dette må alle GPIO porter kobles på en inout også blir I/O-type implisitt definert fra rtl-koden. 