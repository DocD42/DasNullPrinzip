# Website live schalten

Die Domain allein ist nur die Adresse. Damit dort die Website erscheint, brauchst du:

1. einen Hosting-Ort für die Dateien aus diesem Ordner
2. DNS-Einträge beim Domainanbieter
3. optional HTTPS, sobald DNS korrekt zeigt

## Einfacher Weg: GitHub Pages

1. GitHub-Repo öffnen.
2. Unter `Settings` -> `Pages` als Quelle `GitHub Actions` auswählen.
3. Als Custom Domain `das-null-prinzip.de` eintragen.
4. Beim Domainanbieter die DNS-Zone bearbeiten.
5. Nach dem nächsten Push oder einem manuellen Start von `Deploy website` unter `Actions` veröffentlicht GitHub den Ordner `Website`.

Laut offizieller GitHub-Dokumentation soll ein Apex-Domainname wie `das-null-prinzip.de` per `A` Records auf diese GitHub-Pages-IP-Adressen zeigen:

```text
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

Für `www.das-null-prinzip.de` wird ein `CNAME` auf die GitHub-Pages-Adresse des Accounts gesetzt, zum Beispiel:

```text
DocD42.github.io
```

GitHub empfiehlt außerdem, die Custom Domain vor oder beim Einrichten zu verifizieren, um Domain-Takeover-Risiken zu vermeiden.

Quelle: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

## Was ich ohne deinen Login nicht tun kann

Ich kann die Website-Dateien vorbereiten und ins Repo pushen. Ich kann aber nicht selbst in deinen Domainanbieter-Account gehen, solange du mir nicht im Chat sagst, bei welchem Anbieter du die Domain registriert hast und welche DNS-Maske du dort siehst.

Du musst keine Passwörter teilen. Es reicht meistens, wenn du Screenshots oder die Namen der DNS-Felder hier beschreibst.
