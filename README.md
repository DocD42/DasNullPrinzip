# Das Null-Prinzip

Eine iPhone-first Begleit-App, die den satirischen Ratgeber **Das Null-Prinzip** inhaltlich unterstützt.

Die App parodiert Habit Tracker, Fokus-Apps, Journaling-Tools und Produktivitätscoaches. Sie misst nicht Fortschritt, sondern Stabilität: nicht begonnene Gewohnheiten, strategisch reifende Aufgaben, Ausreden mit Management-Kompatibilität und eine 30-Tage-Nullstand-Challenge.

## MVP

- Heute-Dashboard mit Umsetzungsgefahr, Null-Spruch und Button `Nichts tun`
- Nullstand-Tracker für nicht begonnene Gewohnheiten
- Strategisches Reifen für Aufgaben
- Ausreden-Generator mit mehreren Tonalitäten
- 30-Tage-Nullstand-Challenge
- Teilen-Funktion für Ausreden

## Build

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project DasNullPrinzip.xcodeproj -scheme DasNullPrinzip -destination generic/platform=iOS -derivedDataPath DerivedData build CODE_SIGNING_ALLOWED=NO
```

Hinweis: Auf einem Rechner ohne installierte iOS-Simulator-Runtime kann Xcodes Asset-Compiler (`actool`) trotz vorhandenem SDK abbrechen. Der Swift-Code lässt sich unabhängig davon so typechecken:

```sh
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -typecheck -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -target arm64-apple-ios17.0 -module-cache-path DerivedData/ManualModuleCache -sdk-module-cache-path DerivedData/ManualSDKModuleCache DasNullPrinzip/*.swift
```
