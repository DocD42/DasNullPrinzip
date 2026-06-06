# Das Null-Prinzip

Begleit-App zum satirischen Sachbuch **Das Null-Prinzip**.

Die App ist eine iPhone-first SwiftUI-App und parodiert Habit Tracker, Fokus-Apps, Journaling-Tools und Produktivitätscoaches. Sie misst nicht Fortschritt, sondern Stabilität: nicht begonnene Gewohnheiten, strategisch reifende Aufgaben, Ausreden mit Management-Kompatibilität und eine 30-Tage-0%-Challenge.

## MVP

- Heute-Dashboard mit 0%-Status, Null-Spruch und Button `Nichts tun`
- 0%-Tracker für nicht begonnene Gewohnheiten
- Strategisches Reifen für Aufgaben
- Ausreden-Generator mit mehreren Tonalitäten
- 30-Tage-0%-Challenge
- Teilen-Funktion für Ausreden

## Build

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project DasNullPrinzip.xcodeproj -scheme DasNullPrinzip -destination generic/platform=iOS -derivedDataPath DerivedData build CODE_SIGNING_ALLOWED=NO
```
