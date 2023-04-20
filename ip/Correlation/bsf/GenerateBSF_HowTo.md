# Hvordan legge til en IP i quartus og generere BSF-fil

 - Legg til alle source filer med å velge Project -> Add/Remove Files. Importer alle source filer. 
 - Åpne top-filen inne i quartus. 
    - Velg File -> Create/Update -> Create Symbol Files Fom Current File. 
    - Dette vil lage en fil som heter *.bsf i tfe4208 mappen. Flytt denne til denne mappen
 - Deretter må du Legge til bsf filen som et library for å plassere den i skjematikken
    - Velg Project -> Add/Remove Files. Deretter velg Library i lista på høyre side
    - Legg til bsf mappen under Project Libraries ved å velge directoriet og trykke Add. 
    - Trykk Apply

Det burde nå være mulig å legge til IPen i skjematikken ved å høyreklikke og velge Insert -> Symbol og finne IPen i lista der. 