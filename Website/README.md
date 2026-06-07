# Das Null-Prinzip Website

Statische Website für `das-null-prinzip.de`.

## Lokal testen

```bash
cd Website
python3 -m http.server 8899
```

Dann im Browser `http://127.0.0.1:8899` öffnen.

## Deployment-Idee

Die Seite kann ohne Build-Schritt gehostet werden. Geeignet sind zum Beispiel:

- GitHub Pages
- Netlify
- Vercel
- ein klassischer Webspace beim Domainanbieter

Die Datei `CNAME` ist bereits auf `das-null-prinzip.de` gesetzt.
