<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge" alt="License">
</p>

# 🏖️ Favignana Top Spot

> **L'app turistica intelligente che ti guida alle migliori spiagge di Favignana in tempo reale.**

Favignana Top Spot analizza le condizioni meteo attuali e suggerisce automaticamente le spiagge con il mare più calmo, basandosi su un sofisticato algoritmo di calcolo del vento.

---

## 📋 Indice

1. [Panoramica](#-panoramica)
2. [Quick Start](#-quick-start)
3. [Architettura](#-architettura)
4. [Wind Engine](#-wind-engine---il-cuore-dellapp)
5. [Database Spiagge](#-database-spiagge)
6. [Sistema Pubblicitario](#-sistema-pubblicitario-smart-ads)
7. [Localizzazione](#-localizzazione-i18n)
8. [API Reference](#-api-reference)
9. [Guida allo Sviluppo](#-guida-allo-sviluppo)
10. [Troubleshooting](#-troubleshooting)
11. [Roadmap](#-roadmap)

---

## 🎯 Panoramica

### Funzionalità Principali

| Feature | Descrizione |
|---------|-------------|
| 🌊 **Wind Engine** | Algoritmo proprietario che calcola lo stato del mare per ogni spiaggia |
| 🌤️ **Meteo Live** | Integrazione real-time con Open-Meteo API |
| 🌍 **Multilingua** | Supporto automatico IT/EN basato sulla lingua del dispositivo |
| 📢 **Smart Ads** | Pubblicità contestuali basate sull'orario (colazione/pranzo/cena) |
| 🗺️ **Navigazione GPS** | Integrazione diretta con Google Maps |
| 🎨 **Material Design 3** | UI moderna con card arrotondate e colori semantici |

### Screenshot

```
┌─────────────────────────────┐
│  🏖️ Favignana Top Spot     │
├─────────────────────────────┤
│  💨 15 km/h    🧭 45° NE    │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ 🟢 Cala Rossa           │ │
│ │    Mare Calmo           │ │
│ │    [🧭 Portami qui]     │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 🟡 Bue Marino           │ │
│ │    Accettabile          │ │
│ │    [🧭 Portami qui]     │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 🔴 Lido Burrone         │ │
│ │    Mare Mosso           │ │
│ │    [🧭 Portami qui]     │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│  [    📢 BANNER ADS     ]   │
└─────────────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisiti

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- Dispositivo Android o emulatore (API 21+)

### Installazione

```bash
# 1. Clona il repository
git clone https://github.com/tuouser/favignana-top-spot.git
cd favignana-top-spot

# 2. Installa le dipendenze
flutter pub get

# 3. Verifica la configurazione
flutter doctor

# 4. Avvia l'app
flutter run
```

### Dipendenze Principali

```yaml
dependencies:
  flutter: sdk
  flutter_localizations: sdk
  http: ^1.1.0              # Chiamate API REST
  url_launcher: ^6.2.0      # Navigazione Google Maps
  cached_network_image: ^3.3.0  # Caching immagini ads
  intl: any                 # Internazionalizzazione
```

---

## 🏗️ Architettura

Il progetto segue un'**architettura modulare a layer** ispirata alla Clean Architecture:

```
lib/
│
├── main.dart                    # 🚀 Entry point & MaterialApp config
│
├── l10n/                        # 🌍 LAYER: Localizzazione
│   └── app_translations.dart    # Stringhe IT/EN con fallback
│
├── models/                      # 📦 LAYER: Domain Models
│   ├── beach.dart               # Entità spiaggia + enum BeachStatus
│   └── ad.dart                  # Modello banner pubblicitario
│
├── services/                    # 🔌 LAYER: Data Sources
│   ├── weather_service.dart     # Client API Open-Meteo
│   └── ad_service.dart          # Provider Ads (Mock → Remote)
│
├── utils/                       # ⚙️ LAYER: Business Logic
│   └── wind_logic.dart          # 🧠 Wind Engine Algorithm
│
└── screens/                     # 🖼️ LAYER: Presentation
    ├── home_screen.dart         # Dashboard principale
    └── components/              # Widget riutilizzabili
        ├── beach_card.dart      # Card singola spiaggia
        └── ad_banner.dart       # Banner pubblicitario
```

### Flusso Dati

```
┌──────────────┐     ┌───────────────┐     ┌─────────────┐
│ Open-Meteo   │────▶│ WeatherService│────▶│             │
│    API       │     │               │     │             │
└──────────────┘     └───────────────┘     │             │
                                           │  HomeScreen │
┌──────────────┐     ┌───────────────┐     │   (State)   │
│  Beach.dart  │────▶│  WindLogic    │────▶│             │
│  (Static DB) │     │  (Algorithm)  │     │             │
└──────────────┘     └───────────────┘     └──────┬──────┘
                                                  │
                     ┌───────────────┐            ▼
                     │   AdService   │     ┌─────────────┐
                     │ (Ads Provider)│────▶│  ListView   │
                     └───────────────┘     │  (Beaches)  │
                                           └─────────────┘
```

---

## 🌊 Wind Engine - Il Cuore dell'App

### Algoritmo di Calcolo

Il `WindLogic` è il motore intelligente che determina lo stato del mare per ogni spiaggia. Analizza la **velocità** e la **direzione** del vento rispetto all'**esposizione geografica** della spiaggia.

#### Regole di Business

| Velocità Vento | Angolo Δ | Stato | Colore | Significato |
|----------------|----------|-------|--------|-------------|
| < 5 km/h | Qualsiasi | `green` | 🟢 | Mare sempre calmo (cut-off assoluto) |
| 5-10 km/h | 130°-180° | `green` | 🟢 | Vento offshore, mare calmo |
| 5-10 km/h | 0°-130° | `yellow` | 🟡 | Brezza leggera, leggermente mosso ma sicuro |
| ≥ 10 km/h | 0°-45° | `red` | 🔴 | Vento frontale, mare mosso |
| ≥ 10 km/h | 45°-130° | `yellow` | 🟡 | Vento laterale, condizioni accettabili |
| ≥ 10 km/h | 130°-180° | `green` | 🟢 | Vento offshore, mare calmo |

> **Fasce di velocità vento:**
> - **< 5 km/h**: Tutti gli spot sono **VERDI** (mare calmo assoluto, brezza impercettibile)
> - **5-10 km/h**: Solo **VERDE** o **GIALLO** (vento leggero, nessuno spot rosso anche se frontale)
> - **≥ 10 km/h**: Valutazione completa **VERDE/GIALLO/ROSSO** in base alla direzione
>
> **Soglia offshore**: La soglia per considerare una spiaggia "riparata" (offshore) è **130°** invece di 135° per dare margine alle spiagge che si trovano quasi in posizione opposta al vento.

#### Formula Angolare

```dart
// Calcolo differenza angolare normalizzata
double diff = (windDirection - beachExposure).abs();
if (diff > 180) diff = 360 - diff;

// Classificazione
if (diff <= 45)  → RED     // Frontale
if (diff >= 135) → GREEN   // Offshore
else             → YELLOW  // Laterale
```

#### Mappa delle Direzioni Cardinali

```
          N (0°)
           │
    NW ────┼──── NE
   (315°)  │    (45°)
           │
  W ───────┼─────── E
 (270°)    │      (90°)
           │
    SW ────┼──── SE
   (225°)  │   (135°)
           │
          S (180°)
```

#### Esempio Pratico

**Scenario**: Vento Grecale (NE, 45°) a 20 km/h

| Spiaggia | Esposizione | Δ Angolo | Stato | Motivo |
|----------|-------------|----------|-------|--------|
| Cala Rossa | NE (45°) | 0° | 🔴 Mosso | Vento frontale |
| Bue Marino | E (90°) | 45° | 🔴 Mosso | Vento quasi frontale |
| Cala Azzurra | S (180°) | 135° | 🟢 Calmo | Vento offshore |
| Lido Burrone | S (180°) | 135° | 🟢 Calmo | Vento offshore |
| Cala Preveto | S (180°) | 135° | 🟢 Calmo | Vento offshore |
| Cala Rotonda | W (270°) | 135° | 🟢 Calmo | Vento offshore |
| Cala Grande | W (270°) | 135° | 🟢 Calmo | Vento offshore |
| Spiaggia Praia | N (0°) | 45° | 🔴 Mosso | Vento quasi frontale |

---

## 🏝️ Database Spiagge

### Schema Dati

```dart
class Beach {
  final String name;           // Nome spiaggia
  final double lat;            // Latitudine GPS
  final double lon;            // Longitudine GPS
  final String exposure;       // Esposizione cardinale (N, S, E, W, NE, SE, NW, SW)
  final List<String> badWinds; // Venti sfavorevoli (legacy, per riferimento)
  BeachStatus status;          // Stato calcolato (green/yellow/red)
}
```

### Spiagge Configurate (15 Spot)

#### 🧭 Legenda Venti Italiani
| Vento | Direzione | Gradi |
|-------|-----------|-------|
| Tramontana | N | 0° |
| Grecale | NE | 45° |
| Levante | E | 90° |
| Scirocco | SE | 135° |
| Mezzogiorno/Ostro | S | 180° |
| Libeccio | SW | 225° |
| Ponente | W | 270° |
| Maestrale | NW | 315° |

#### Costa Nord-Est
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 1 | **Cala Rossa** | 37.922464, 12.363907 | NE | Tramontana, Grecale |
| 2 | **Cala San Nicola** | 37.935022, 12.346703 | NE | Grecale, Tramontana |
| 3 | **Scalo Cavallo** | 37.930894, 12.349999 | NE | Grecale, Tramontana |

#### Costa Est
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 4 | **Bue Marino** | 37.917222, 12.369920 | E | Levante, Scirocco, Grecale |

#### Costa Sud-Est
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 5 | **Punta Marsala** | 37.907304, 12.366618 | SE | Scirocco, Levante, Ostro |

#### Costa Sud
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 6 | **Cala Azzurra** | 37.908715, 12.361280 | S | Ostro, Scirocco |
| 7 | **Lido Burrone** | 37.918272, 12.338202 | S | Scirocco, Libeccio |
| 8 | **Cala Preveto** | 37.918953, 12.302630 | S | Scirocco, Libeccio |

#### Costa Nord (Centro)
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 9 | **Spiaggia Praia** | 37.929608, 12.325196 | N | Tramontana, Grecale |

#### Costa Nord
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 10 | **Cala Faraglioni** | 37.954491, 12.306777 | N | Maestrale, Tramontana |
| 11 | **Cala Trapanese** | 37.953404, 12.308071 | N | Tramontana, Maestrale, Grecale |

#### Costa Nord-Ovest
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 12 | **Cala del Pozzo** | 37.942171, 12.287885 | NW | Maestrale, Ponente |

#### Costa Ovest
| # | Nome | Coordinate GPS | Esposizione | Venti Sfavorevoli |
|---|------|----------------|-------------|-------------------|
| 13 | **Cala Rotonda** | 37.923715, 12.284060 | W | Ponente, Maestrale |
| 14 | **Cala Grande** | 37.931035, 12.279523 | W | Ponente, Libeccio |
| 15 | **Spiaggia di Ponente** | 37.935384, 12.276704 | W | Ponente, Maestrale |

### Regola Generale per la Scelta

> **"Se il vento soffia da una direzione, cerca una spiaggia sulla costa opposta dell'isola."**

| Condizione Vento | Direzione | Coste Consigliate | Spiagge Suggerite |
|------------------|-----------|-------------------|-------------------|
| Tramontana/Maestrale/Grecale | N/NW/NE | Sud, Sud-Est | Lido Burrone, Cala Azzurra, Cala Preveto |
| Mezzogiorno/Scirocco/Libeccio | S/SE/SW | Nord, Nord-Ovest | Cala Rossa, Scalo Cavallo, Spiaggia Praia, Cala Faraglioni |
| Ponente | W | Est | Bue Marino, Cala Azzurra (lato est) |
| Levante | E | Ovest | Cala Rotonda, Cala Grande |

### Mappa Geografica

```
                         N (Tramontana)
                            ↑
            ┌───────────────┴───────────────┐
            │  ⑩ Cala Faraglioni  ⑪ Cala   │
            │      (N)         Trapanese(N) │
            │                               │
            │  ⑫ Cala                       │
   (Ponente)│  del Pozzo  ⑨ Spiaggia Praia │ (Grecale)
     W ←────│    (NW)          (N)         │────→ NE
            │                               │
            │  ⑮ Spiaggia  ② Cala San Nicola│
            │  di Ponente      (NE)         │
            │   (W)    ③ Scalo Cavallo      │
            │              (NE)             │
            │  ⑭ Cala                       │
            │  Grande    ① Cala Rossa       │
            │   (W)           (NE)          │
            │                               │
            │  ⑬ Cala           ④ Bue Marino│ (Levante)
     W ←────│  Rotonda           (E)        │────→ E
            │   (W)                         │
            │  ⑧ Cala      ⑥ Cala Azzurra   │
            │  Preveto         (S)          │
            │   (S)     ⑤ Punta Marsala     │
            │       ⑦ Lido     (SE)         │
            │       Burrone                 │
            │         (S)                   │
            └───────────────┬───────────────┘
                            ↓
                     S (Mezzogiorno)
```

### Aggiungere una Nuova Spiaggia

1. Apri `lib/models/beach.dart`
2. Aggiungi alla lista `getBeaches()`:

```dart
Beach(
  name: "Nuova Spiaggia",
  lat: 37.XXXX,
  lon: 12.XXXX,
  exposure: "SW",  // Direzione verso cui "guarda" la spiaggia
  badWinds: ["S", "SW", "W"],  // Venti che creano onde
),
```

---

## 📢 Sistema Pubblicitario (Smart Ads)

### Architettura Ads

Il sistema pubblicitario è **contestuale all'orario** e supporta due tipologie di banner con posizionamenti distinti.
Le pubblicità sono caricate dinamicamente da un **file JSON su Google Drive**, permettendo di aggiornare i banner senza modificare il codice dell'app.

#### Configurazione Remota

```dart
// URL del file JSON di configurazione ads su Google Drive
static const String _adsConfigUrl = 
    'https://drive.google.com/uc?export=download&id=1pav7QBy4-EFbxP_Q_2h3W1jJq2Ra6T0Z';
```

> **Come aggiornare le pubblicità:**
> 1. Modifica il file `ads_config.json` su Google Drive
> 2. L'app caricherà automaticamente le nuove pubblicità al prossimo avvio
> 3. Non è necessario rilasciare una nuova versione dell'app

#### Fasce Orarie

| Fascia | Orario | Tipo Target | Esempio |
|--------|--------|-------------|---------|
| 🌅 **Morning** | 06:00 - 11:00 | Colazioni, Bar | "Bar da Mario - Cappuccino €1" |
| 🍝 **Lunch** | 11:00 - 15:00 | Ristoranti, Paninerie | "Trattoria del Porto - Menu €12" |
| 🍕 **Dinner** | 19:00 - 24:00 | Pizzerie, Ristoranti | "Pizzeria Sunset - Pizza + Birra €10" |
| 📢 **All Day** | Sempre | Promo generiche | "Noleggio Barche - Sconto 20%" |

#### Tipologie Banner

| Tipo | Posizione | Ratio | Dimensioni | Note |
|------|-----------|-------|------------|------|
| **Sticky** | Fondo schermo (fisso) | 6:1 | 600×100 px | Sempre visibile durante scroll |
| **Native** | Dopo 3° spiaggia | 16:9 | 640×360 px | Integrato nel feed |

### Schema JSON Ads

```json
{
  "imageUrl": "https://cdn.example.com/ads/breakfast.jpg",
  "linkUrl": "https://example.com/restaurant",
  "type": "morning",      // morning | lunch | dinner | all
  "position": "sticky"    // sticky | native
}
```

### Configurazione Google Drive

Il file `ads_config.json` su Google Drive deve avere la seguente struttura:

```json
[
  {
    "imageUrl": "https://cdn.example.com/ads/banner1.jpg",
    "linkUrl": "https://example.com/promo",
    "type": "all",
    "position": "sticky"
  },
  {
    "imageUrl": "https://cdn.example.com/ads/banner2.jpg",
    "linkUrl": "https://example.com/restaurant",
    "type": "lunch",
    "position": "native"
  }
]
```

**Importante:** Assicurarsi che il file su Google Drive sia condiviso con "Chiunque abbia il link" per permettere all'app di scaricarlo.

---

## 🌍 Localizzazione (i18n)

### Lingue Supportate

| Codice | Lingua | Status |
|--------|--------|--------|
| `it` | 🇮🇹 Italiano | ✅ Default |
| `en` | 🇬🇧 English | ✅ Supportato |
| `*` | Altre | ⚡ Fallback → English |

### Architettura Traduzioni

```dart
class AppTranslations {
  final Locale locale;
  
  // Fallback automatico a English per lingue non supportate
  String get _langCode => 
    _localizedValues.containsKey(locale.languageCode) 
      ? locale.languageCode 
      : 'en';
}
```

### Stringhe Disponibili

| Chiave | IT | EN |
|--------|----|----|
| `appTitle` | Favignana Top Spot | Favignana Top Spot |
| `calmSea` | Mare Calmo | Calm Sea |
| `roughSea` | Mare Mosso | Rough Sea |
| `acceptable` | Accettabile | Acceptable |
| `navigate` | Portami qui | Navigate |
| `loading` | Caricamento meteo... | Loading weather... |
| `error` | Errore caricamento dati | Error loading data |
| `wind` | Vento | Wind |
| `direction` | Direzione | Direction |
| `exposure` | Esposizione | Exposure |
| `topSpot` | Top Spot | Top Spot |

### Aggiungere una Traduzione

1. Apri `lib/l10n/app_translations.dart`
2. Aggiungi la chiave in entrambe le mappe:

```dart
'en': {
  // ... esistenti
  'newKey': 'New Translation',
},
'it': {
  // ... esistenti
  'newKey': 'Nuova Traduzione',
},
```

3. Aggiungi il getter:

```dart
String get newKey => _localizedValues[_langCode]!['newKey']!;
```

---

## 📡 API Reference

### Open-Meteo Weather API

**Endpoint:**
```
GET https://api.open-meteo.com/v1/forecast
```

**Parametri:**
| Param | Valore | Descrizione |
|-------|--------|-------------|
| `latitude` | `37.9300` | Latitudine Favignana |
| `longitude` | `12.3270` | Longitudine Favignana |
| `current_weather` | `true` | Richiedi dati meteo attuali |

**Response:**
```json
{
  "current_weather": {
    "temperature": 24.5,
    "windspeed": 15.2,
    "winddirection": 45,
    "weathercode": 1,
    "time": "2024-07-15T10:00"
  }
}
```

**Campi Utilizzati:**
| Campo | Tipo | Unità | Uso |
|-------|------|-------|-----|
| `windspeed` | `double` | km/h | Soglia < 10 per mare calmo |
| `winddirection` | `double` | gradi | Confronto con esposizione spiaggia |

---

## 🛠️ Guida allo Sviluppo

### Comandi Utili

```bash
# Sviluppo
flutter run                    # Avvia in debug mode
flutter run --release          # Avvia in release mode
flutter run -d chrome          # Avvia su web (preview)

# Build
flutter build apk              # APK debug
flutter build apk --release    # APK release
flutter build appbundle        # AAB per Play Store

# Qualità
flutter analyze                # Analisi statica codice
flutter test                   # Esegui unit test
flutter pub outdated           # Verifica dipendenze obsolete

# Pulizia
flutter clean                  # Pulisci build cache
flutter pub get                # Reinstalla dipendenze
```

### Struttura Branch (Git Flow)

```
main          ← Produzione stabile
  └── develop ← Sviluppo attivo
       ├── feature/nuova-spiaggia
       ├── feature/filtri-avanzati
       └── bugfix/crash-meteo
```

### Convenzioni Codice

- **Naming**: `camelCase` per variabili, `PascalCase` per classi
- **File**: `snake_case.dart`
- **Commenti**: JSDoc per metodi pubblici
- **Costanti**: Definite in file dedicati o come `static const`

---

## 🔧 Troubleshooting

### Problemi Comuni

#### ❌ L'app non carica i dati meteo

**Sintomo:** Spinner infinito o messaggio di errore

**Soluzioni:**
1. Verificare connessione internet attiva
2. Testare l'API direttamente:
   ```bash
   curl "https://api.open-meteo.com/v1/forecast?latitude=37.93&longitude=12.327&current_weather=true"
   ```
3. Controllare i log:
   ```bash
   flutter logs
   ```

#### ❌ Le pubblicità non appaiono

**Sintomo:** Nessun banner visibile

**Cause possibili:**
1. **Orario non coperto**: L'orario attuale non rientra in nessuna fascia (15:00-19:00)
2. **Nessun ad "all"**: Aggiungere ads con `type: "all"` per copertura completa
3. **Errore di rete**: Il mock simula 500ms di delay

#### ❌ Errori di compilazione

**Sintomo:** Build fallisce

**Soluzioni:**
```bash
# 1. Pulisci e reinstalla
flutter clean
flutter pub get

# 2. Verifica SDK
flutter doctor -v

# 3. Aggiorna dipendenze
flutter pub upgrade
```

#### ❌ Google Maps non si apre

**Sintomo:** Nulla accade al tap su "Portami qui"

**Soluzioni Android:**
1. Verificare che Google Maps sia installato
2. Controllare i permessi in `AndroidManifest.xml`:
   ```xml
   <queries>
     <intent>
       <action android:name="android.intent.action.VIEW" />
       <data android:scheme="https" />
     </intent>
   </queries>
   ```

---

## 🗺️ Roadmap

### v1.0.0 (Attuale)
- [x] Wind Engine base
- [x] 5 spiagge configurate
- [x] Multilingua IT/EN
- [x] Smart Ads mock
- [x] Navigazione Google Maps

### v1.1.0 (Prossima)
- [ ] Pull-to-refresh meteo
- [ ] Widget meteo espanso (temperatura, umidità)
- [ ] Immagini spiagge reali
- [ ] Notifiche push "Top Spot del giorno"

### v1.2.0 (Futura)
- [ ] Ads backend reale (Firebase/API custom)
- [ ] Preferiti spiagge
- [ ] Storico condizioni
- [ ] Dark mode

### v2.0.0 (Vision)
- [ ] Previsioni multi-giorno
- [ ] AI recommendation engine
- [ ] Community reviews
- [ ] Integrazione noleggio attrezzature

---

## 📄 Licenza

Copyright © 2025 Favignana Top Spot. Tutti i diritti riservati.

---

<p align="center">
  <b>Made with ❤️ in Sicilia</b><br>
  <sub>Per l'isola più bella del Mediterraneo</sub>
</p>
