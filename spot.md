# Regole degli Spot - Favignana Top Spot

Questo documento riassume le logiche di calcolo delle condizioni del mare per i 15 spot dell'applicazione.

## Legenda Regole Generali

| Stato | Condizione | Vento (Direzione vs Esposizione) | Velocità Vento |
| :--- | :--- | :--- | :--- |
| **VERDE** (Calmo) | Eccellente | Vento da dietro (Offshore) o < 5 km/h | Ogni velocità (o < 5 km/h) |
| **GIALLO** (Accettabile) | Balneabile | Vento Laterale o Vento Frontale debole | 5 - 10 km/h |
| **ROSSO** (Mosso) | Sconsigliato | Vento Frontale (Onshore) | > 10 km/h |

---

## Dettaglio Spot (Ver 1.0.3)

| Nome Spot | Esposizione | Mare Calmo (VERDE) | Mare Accettabile (GIALLO) | Mare Mosso (ROSSO) | Note Speciali |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Cala Rossa** | NE | Venti da S, SW, W, NW | Vento < 10 km/h o Laterali (SE, E) | Venti da N, NE (> 10 km/h) | - |
| **Cala San Nicola** | NE | Venti da S, SW, W, NW | Vento < 10 km/h o Laterali (SE, E) | Venti da NE, N (> 10 km/h) | - |
| **Scalo Cavallo** | NE | Venti da S, SW, W, NW | Vento < 10 km/h o Laterali (SE, E) | Venti da NE, N (> 10 km/h) | - |
| **Bue Marino** | E | Venti da W, NW, SW | Vento < 10 km/h o Laterali (N, S) | Venti da E, SE, NE (> 10 km/h) | Molto esposto a Est |
| **Cala Azzurra** | S | Venti da N, NW, W, NE | Vento < 10 km/h o Laterali (E, SW) | Venti da S, SE (> 10 km/h) | **Sempre Verde** con N, NW, W |
| **Punta Marsala** | SE | Venti da NW, N, W | Vento < 10 km/h o Laterali (NE, SW) | Venti da SE, E, S (> 10 km/h) | - |
| **Lido Burrone** | S | Venti da N, NE, NW | Vento < 10 km/h o Laterali (E, W) | Venti da S, SE, SW (> 10 km/h) | - |
| **Cala Preveto** | S | Venti da N, NE, NW | Vento < 10 km/h o Laterali (E, W) | Venti da S, SE, SW (> 10 km/h) | - |
| **Spiaggia Praia** | N | Venti da S, SE, SW | Vento < 10 km/h o Laterali (E, W) | Venti da N, NE (> 10 km/h) | - |
| **Cala Faraglioni** | N | Venti da S, SE, SW | Vento < 10 km/h o Laterali (NE, E) | Venti da NW, N (> 10 km/h) | - |
| **Cala Trapanese** | N | Venti da S, SE, SW | Vento < 10 km/h o Laterali (W, E) | Venti da N, NW, NE (> 10 km/h) | - |
| **Cala del Pozzo** | NW | Venti da SE, S, E | Vento < 10 km/h o Laterali (N, SW) | Venti da NW, W (> 10 km/h) | - |
| **Cala Rotonda** | W | Venti da E, SE, NE | Vento < 10 km/h o Laterali (N, S) | Venti da W, NW (> 10 km/h) | - |
| **Cala Grande** | W | Venti da E, SE, NE | Vento < 10 km/h o Laterali (N, S) | Venti da W, SW (> 10 km/h) | - |
| **Spiaggia di Ponente** | W | Venti da E, SE, NE | Vento < 10 km/h o Laterali (N, S) | Venti da W, NW (> 10 km/h) | - |

---

## Logica Tecnica (Wind Engine)

1.  **Sotto i 5 km/h**: Tutti gli spot sono **VERDE**.
2.  **Tra 5 e 10 km/h**: Lo stato può essere solo **VERDE** (vento calmo/posteriore) o **GIALLO** (vento frontale o laterale). Il **ROSSO** è disabilitato per brezze leggere.
3.  **Sopra i 10 km/h**: Valutazione completa dell'angolo di incidenza:
    *   **Frontale (Entro 45°)**: ROSSO
    *   **Laterale (Tra 45° e 130°)**: GIALLO
    *   **Posteriore (Oltre 130°)**: VERDE
4.  **Eccezione Cala Azzurra**: Grazie alla sua conformazione (shelterBonus + logic override), rimane **VERDE** con venti da Nord (N), Nord-Ovest (NW) e Ovest (W) anche se forti.
