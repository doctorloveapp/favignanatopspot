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

| Condizione | Angolo Δ | Stato | Colore | Significato |
|------------|----------|-------|--------|-------------|
| Vento < 10 km/h | - | `green` | 🟢 | Mare sempre calmo |
| Vento frontale | 0° - 45° | `red` | 🔴 | Mare mosso, onde dirette |
| Vento laterale | 45° - 135° | `yellow` | 🟡 | Condizioni accettabili |
| Vento offshore | 135° - 180° | `green` | 🟢 | Mare calmo, vento da terra |

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

**Scenario**: Vento da NE (45°) a 20 km/h

| Spiaggia | Esposizione | Δ Angolo | Stato |
|----------|-------------|----------|-------|
| Cala Rossa | N (0°) | 45° | 🔴 Mosso |
| Bue Marino | NE (45°) | 0° | 🔴 Mosso |
| Lido Burrone | S (180°) | 135° | 🟢 Calmo |
| Cala Azzurra | SE (135°) | 90° | 🟡 Accettabile |
| Cala Rotonda | W (270°) | 135° | 🟢 Calmo |

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

### Spiagge Configurate

| # | Nome | Coordinate | Esposizione | Venti Sfavorevoli |
|---|------|------------|-------------|-------------------|
| 1 | **Cala Rossa** | 37.9388, 12.3592 | N | Tramontana, Grecale |
| 2 | **Bue Marino** | 37.9350, 12.3650 | NE | Tramontana, Grecale, Levante |
| 3 | **Lido Burrone** | 37.9150, 12.3450 | S | Scirocco, Libeccio |
| 4 | **Cala Azzurra** | 37.9180, 12.3700 | SE | Scirocco, Ostro |
| 5 | **Cala Rotonda** | 37.9250, 12.3100 | W | Ponente, Maestrale |

### Mappa Geografica

```
                    N
                    ↑
        ┌───────────┴───────────┐
        │                       │
        │    ① Cala Rossa      │
        │        (N)            │
   W ←──│  ⑤                ②  │──→ E
        │ Cala               Bue│
        │Rotonda            Marino
        │  (W)               (NE)│
        │                       │
        │   ③ Lido    ④ Cala   │
        │   Burrone   Azzurra  │
        │     (S)       (SE)    │
        └───────────────────────┘
                    ↓
                    S
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

### Implementazione Produzione

Per passare da mock a produzione, modifica `ad_service.dart`:

```dart
Future<List<Ad>> fetchAds() async {
  // PRODUZIONE: Decommentare
  final response = await http.get(Uri.parse('https://api.tuoserver.com/ads'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Ad.fromJson(json)).toList();
  }
  throw Exception('Failed to load ads');
  
  // MOCK: Commentare in produzione
  // await Future.delayed(const Duration(milliseconds: 500));
  // final String jsonString = '''...''';
}
```

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

Copyright © 2024 Favignana Top Spot. Tutti i diritti riservati.

---

<p align="center">
  <b>Made with ❤️ in Sicilia</b><br>
  <sub>Per l'isola più bella del Mediterraneo</sub>
</p>
