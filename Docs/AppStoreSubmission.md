# App-Store-Einreichung: Das Null-Prinzip

Stand: 13. August 2026

Diese Datei ist die Arbeitsmappe fuer App Store Connect. Sie enthaelt Felder zum Kopieren, Review-Hinweise, Datenschutzantworten und die Wochenend-Checkliste.

## App-Information

| Feld | Wert |
| --- | --- |
| App-Name | Das Null-Prinzip |
| Bundle ID | de.dasnullprinzip.app |
| SKU | das-null-prinzip-ios |
| Primaersprache | Deutsch |
| Kategorie primaer | Lifestyle |
| Kategorie sekundaer | Unterhaltung |
| Preisempfehlung fuer Version 1.0 | Kostenlos |
| Copyright | 2026 Dr. René Deist |
| Support URL | https://das-null-prinzip.de/support.html |
| Marketing URL | https://das-null-prinzip.de/ |
| Datenschutz URL | https://das-null-prinzip.de/datenschutz.html |

Hinweis: Wenn der Apple Developer Account als Einzelperson gefuehrt wird, zeigt Apple den rechtlichen Namen als Anbieter/Developer an. Das ist konsistent mit dem Impressum.

## Produktseite de-DE

### Name

```text
Das Null-Prinzip
```

### Untertitel

Empfehlung:

```text
Nullstand statt Stress
```

Alternativen:

```text
Anti-Produktivität
Besser nicht anfangen
```

### Promotional Text

```text
Die Begleit-App zum satirischen Sachbuch: misst Umsetzungsgefahr, pflegt Ausreden und schützt Ideen vor vorschneller Wirklichkeit.
```

### Beschreibung

```text
Das Null-Prinzip ist die Anti-Produktivitäts-App für alle, die genug Ziele haben und trotzdem gern professionell wirken.

Die App begleitet das satirische Sachbuch von Dr. Lasse Sein und dreht die Logik klassischer Selbstoptimierung um: Nicht Fortschritt ist das Ideal, sondern Nullstand. Jede Idee, die zu konkret wird, jede Aufgabe, die zu sehr nach Handlung riecht, erhöht die Umsetzungsgefahr.

Funktionen:

- Dashboard mit Umsetzungsgefahr, Null-Spruch und Nichtstun-Konto
- Nullstand-Tracker für innere Ideen, Projekte und Challenges, die lieber Möglichkeit bleiben
- Strategisches Reifen für Aufgaben, die von außen an dich herangetragen wurden
- Ausreden-Generator mit mehreren Tonlagen, von Corporate bis Paargeeignet
- 30-Tage-Nullstand-Challenge für kontrollierte Nichteskalation
- Teilen-Funktion für besonders tragfähige Ausreden

Alles bleibt lokal auf deinem iPhone. Es gibt kein Konto, kein Tracking, keine Werbung und keine Cloud-Synchronisierung.

Das Null-Prinzip ist kein Ratgeber. Es ist ein liebevoll gestalteter Gegenentwurf zum Zwang, aus allem ein Projekt zu machen.
```

### Keywords

```text
prokrastination,ausreden,humor,satire,tracker,gewohnheiten,challenge,nichtstun,produktivität
```

Falls App Store Connect bei Keywords wider Erwarten zickt, kann `produktivität` durch `produktivitaet` ersetzt werden.

## Datenschutz in App Store Connect

### Privacy Policy URL

```text
https://das-null-prinzip.de/datenschutz.html
```

### Datenerhebung

Empfohlene Antwort:

```text
No, we do not collect data from this app.
```

Begruendung: Die App speichert Ideen, Aufgaben, Challenge-Status und Nichtstun-Zaehler nur lokal per UserDefaults auf dem Geraet. Es gibt keinen Account, keine Serververbindung, kein Tracking, keine Werbung und keine Drittanbieter-SDKs.

### Privacy Manifest

Im Projekt enthalten:

```text
DasNullPrinzip/PrivacyInfo.xcprivacy
```

Deklariert:

- `NSPrivacyAccessedAPICategoryUserDefaults`
- Grund `CA92.1`: Lesen/Schreiben von Informationen, die nur der App selbst zugaenglich sind.
- Keine gesammelten Daten.
- Kein Tracking.

## Altersfreigabe

Empfohlene Antworten:

- Made for Kids: Nein
- User-generated content / Social Media / Messaging: Nein
- Unrestricted Web Access: Nein
- Advertising: Nein
- Contests, Gambling, Loot Boxes: Nein
- Medical or Treatment Information: Nein
- Violence / Weapons: Nein
- Sexual Content / Nudity: Nein
- Alcohol, Tobacco, Drugs: Nein
- Profanity or Crude Humor: hoechstens infrequent/mild, falls Apple den satirischen Ton so einordnet; sonst Nein.

Erwartung: wahrscheinlich 4+ oder 9+. Nicht freiwillig hoeher einstufen, solange der Fragebogen keine hoehere Einstufung erzeugt.

## App Review Notes

```text
Das Null-Prinzip is a German-language satirical companion app for the book of the same name. It parodies productivity, habit tracking and self-optimization apps.

The app has no account system, no backend, no advertising, no analytics and no third-party SDKs. User-created ideas, tasks and challenge progress are stored locally on the device only via UserDefaults.

There is no user-generated public content, no messaging, no unrestricted web access and no in-app purchases. The home screen includes a neutral external link to the official website for book information; it opens outside the app and does not unlock app content, features or functionality. The share sheet is used only when the user explicitly shares a generated excuse through iOS.

All core features are available immediately after launch.
```

## Screenshots

Fuer den ersten App-Store-Start reichen 5 iPhone-Screenshots:

1. Dashboard: Umsetzungsgefahr, Null-Spruch, Nichts-tun-Button
2. Ausreden-Generator: Eingabe, Modus, generierte Ausrede
3. Nullstand-Tracker: innere Ideen und Umsetzungsgefahr
4. Strategisches Reifen: aeussere Aufgaben, Tageszaehler, goldener Rand
5. 30-Tage-Nullstand-Challenge: Fortschritt und Tageskarten

Optional spaeter: gestaltete Screenshots mit kurzen Headlines. Fuer die erste Review-Runde sind echte, unverfaelschte Screenshots oft stressfreier.

## Wochenendablauf

1. Apple Developer Account pruefen: Agreements, Tax/Banking nur falls kostenpflichtig.
2. App Store Connect: neue App anlegen.
3. App Information aus dieser Datei eintragen.
4. App Privacy beantworten und Privacy Policy URL setzen.
5. Age Rating ausfuellen.
6. Screenshots aus dem iPhone-Simulator erstellen.
7. In Xcode Team setzen, Bundle ID pruefen, Archive bauen.
8. Archive zu App Store Connect hochladen.
9. Build in App Store Connect auswaehlen.
10. App Review Notes eintragen.
11. Zur Pruefung einreichen.

## Vor dem finalen Klick pruefen

- Website HTTPS funktioniert: https://das-null-prinzip.de/
- Datenschutzseite oeffnet: https://das-null-prinzip.de/datenschutz.html
- Impressum oeffnet: https://das-null-prinzip.de/impressum.html
- Keine Community-/User-Content-Funktion in Version 1.0.
- Keine externen Dienste oder Tracking-SDKs hinzugefuegt.
- Der Buch-Hinweis in der App fuehrt neutral zur Website, nicht als direkter Amazon-Kaufbutton.
- App-Version in Xcode: 1.0.0, Build: 1.
