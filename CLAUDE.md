# PharoHtmx

Doel: een klein htmx-gebaseerd web-UI-framework in Pharo 14, gebouwd op Zinc (eventueel Teapot),
waarmee je snel website-UI's bouwt. Gestart 2026-10-27.

Prior art (survey 2026-10-27): er bestaat geen htmx-framework voor Pharo. Alleen
arunvickram/Seaside-HTMX-Extensions (7 hx*-methodes op WATagBrush). Seaside 3.6 koos Hotwired
Turbo, niet htmx. Bouwstenen in Pharo: Zinc (in het image, ZnHtmlOutputStream als mini-HTML-DSL),
Teapot (ca. 600 regels, Pharo 9-13), Willow/RenoirSt (ba-st).

## Wie

Georges (Soops B.V.), TypeScript/Rust-achtergrond, frist Smalltalk op. Antwoord in het Nederlands.

## Omgeving

- Pharo 14 via Pharo Launcher (Windows 11).
- VM: C:\Users\Georges\Documents\Pharo\vms\140-x64\PharoConsole.exe
- Image: C:\Users\Georges\Documents\Pharo\images\PharoMCP\PharoMCP.image
  Nooit headless op het live image draaien; kopieer het eerst naar de scratchpad.
- In het image draait Evref-BL/MCP op poort 4000, geregistreerd in .mcp.json.
  Na elke image-herstart in een Playground opnieuw evalueren: `MCP startOnPort: 4000`.
- Werk op het live image via de pharo-MCP-tools (skill `pharo-mcp` uit de Soops-marketplace).
- Broncode: Tonel via Iceberg in deze map (src/), git als source of truth. Geen tool slaat het
  image op; wijzigingen blijven alleen door Iceberg-commit of `Smalltalk saveSession`.

## Demodata

D:\projects\MarketPlaces\bookstore: 100 Google-Books-records (JSON) plus 91 covers,
bruikbaar als voorbeelddata voor een boekwinkel-UI.
