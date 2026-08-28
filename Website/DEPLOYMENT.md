# Website bei IONOS aktualisieren

Die Live-Website liegt im IONOS-Webspace im Verzeichnis:

```text
/das-null-prinzip
```

## Upload

Am einfachsten im Finder doppelklicken:

```text
Website/ionos-deploy.local.command
```

Danach:

1. Benutzer und Remote-Verzeichnis mit Enter bestätigen.
2. `ja` eintippen.
3. Beim Passwort-Prompt das SFTP-Passwort blind einfügen und Enter drücken.
4. Erst wenn `sftp>` erscheint, die angezeigten Upload-Befehle einfügen.

## Dateien, die live hochgeladen werden

- `index.html`
- `styles.css`
- `script.js`
- `impressum.html`
- `datenschutz.html`
- `support.html`
- `.htaccess`
- `robots.txt`
- `sitemap.xml`
- `favicon.ico`
- `assets/book-cover.png`
- `assets/apple-touch-icon.png`

Nicht hochladen:

- `README.md`
- `DEPLOYMENT.md`
- `LEGAL-CHECKLIST.md`
- `CNAME`

## Nach dem Upload prüfen

- `https://das-null-prinzip.de/`
- `https://das-null-prinzip.de/impressum.html`
- `https://das-null-prinzip.de/datenschutz.html`
- `https://das-null-prinzip.de/support.html`
- `http://das-null-prinzip.de/` sollte automatisch auf `https://das-null-prinzip.de/` weiterleiten.
- `https://www.das-null-prinzip.de/` sollte automatisch auf `https://das-null-prinzip.de/` weiterleiten.

Im Browser bei Bedarf mit Cmd-Shift-R hart neu laden.
