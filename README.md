<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.3-blue?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" alt="Platform">
</p>

# Favignana Top Spot

> L'app turistica intelligente che ti guida alle migliori spiagge di Favignana in tempo reale.

---

## Caratteristiche

| Feature | Descrizione |
|---------|-------------|
| Wind Engine | Algoritmo proprietario per stato del mare |
| Mappa Interattiva | Marker colorati e animazione vento |
| Auto-Refresh | Aggiornamento automatico ogni 30 minuti |
| Meteo Live | Open-Meteo API real-time |
| Multilingua | IT/EN automatico |
| Smart Ads | Pubblicita da Google Drive |
| Navigazione GPS | Integrazione Google Maps |

---

## I 15 Spot

### Costa Nord-Est
1. **Cala Rossa** (NE) - Iconica
2. **Cala San Nicola** (NE) - Tranquilla
3. **Scalo Cavallo** (NE) - Accesso facile

### Costa Est
4. **Bue Marino** (E) - Grotte marine

### Costa Sud-Est
5. **Punta Marsala** (SE) - Vista Marsala

### Costa Sud
6. **Cala Azzurra** (S) - Conca protetta N/NW/W = VERDE
7. **Lido Burrone** (S) - Attrezzata
8. **Cala Preveto** (S) - Selvaggia

### Costa Nord
9. **Spiaggia Praia** (N) - Vicina al porto
10. **Cala Faraglioni** (N) - Faraglioni iconici
11. **Cala Trapanese** (N)

### Costa Nord-Ovest
12. **Cala del Pozzo** (NW) - Antica cava

### Costa Ovest
13. **Cala Rotonda** (W) - Forma circolare
14. **Cala Grande** (W) - Ampia
15. **Spiaggia di Ponente** (W) - Tramonti

---

## Wind Engine

### Fasce Velocita Vento
- **< 5 km/h**: Tutti VERDI (mare calmo)
- **5-10 km/h**: Solo VERDE/GIALLO (no rosso)
- **>= 10 km/h**: Valutazione completa

### Soglie Angolari
- 0-45 gradi: ROSSO (frontale)
- 45-130 gradi: GIALLO (laterale)
- 130+ gradi: VERDE (offshore)

### Eccezione Cala Azzurra
Conca pronunciata: VERDE automatico con venti N, NW, W

---

## Build

### Debug
```
flutter run -d <device>
```

### Release APK
```
flutter build apk --release
```

### Play Store (AAB)
```
flutter build appbundle --release
```

---

## Changelog

### v1.0.3
- 15 spot con GPS preciso
- Auto-refresh 30 minuti
- Protezione Cala Azzurra N/NW/W
- Ads da Google Drive
- Gestione errori rete robusta

### v1.0.2
- 3 nuovi spot
- Riduzione UI elementi

### v1.0.1
- Fix animazione vento
- Soglia 5 km/h

### v1.0.0
- Release iniziale

---

Copyright 2025 Favignana Top Spot
