enum BeachStatus { green, yellow, red }

/// Modello dati per una spiaggia di Favignana.
///
/// [exposure] indica la direzione verso cui la spiaggia è aperta (es. "NE" = Nord-Est)
/// [badWinds] lista dei venti che rendono il mare mosso (venti frontali)
///
/// Regola Generale:
/// "Se il vento soffia da una direzione, cerca una spiaggia sulla costa opposta dell'isola."
class Beach {
  final String name;
  final double lat;
  final double lon;
  final String exposure; // N, S, E, W, NE, SE, NW, SW
  final List<String> badWinds; // Winds that make the sea rough
  BeachStatus status;

  Beach({
    required this.name,
    required this.lat,
    required this.lon,
    required this.exposure,
    required this.badWinds,
    this.status = BeachStatus.green, // Default
  });

  /// Restituisce la lista completa delle spiagge di Favignana.
  ///
  /// Dati aggiornati con coordinate GPS precise e venti sfavorevoli verificati.
  /// Fonte: Mappatura locale dell'isola di Favignana.
  static List<Beach> getBeaches() {
    return [
      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD-EST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Rossa",
        lat: 37.9262,
        lon: 12.3592,
        exposure: "NE",
        // Esposta a: Maestrale (NW), Tramontana (N), Grecale (NE)
        badWinds: ["NW", "N", "NE"],
      ),
      Beach(
        name: "Cala San Nicola",
        lat: 37.9338,
        lon: 12.3497,
        exposure: "NE",
        // Esposta a: Tramontana (N), Grecale (NE), Maestrale (NW)
        badWinds: ["N", "NE", "NW"],
      ),
      Beach(
        name: "Scalo Cavallo",
        lat: 37.9375,
        lon: 12.3483,
        exposure: "NE",
        // Esposta a: Tramontana (N), Grecale (NE), Maestrale (NW)
        badWinds: ["N", "NE", "NW"],
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA EST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Bue Marino",
        lat: 37.9203,
        lon: 12.3615,
        exposure: "E",
        // Esposta a: Levante (E), Grecale (NE), Scirocco (SE)*
        // *Con Scirocco mare leggermente mosso, impraticabile con Levante/Grecale
        badWinds: ["E", "NE", "SE"],
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA SUD-EST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Azzurra",
        lat: 37.9109,
        lon: 12.3335,
        exposure: "SE",
        // Esposta a: Scirocco (SE), Levante (E)
        badWinds: ["SE", "E"],
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA SUD
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Lido Burrone",
        lat: 37.9155,
        lon: 12.3297,
        exposure: "S",
        // Esposta a: Scirocco (SE), Mezzogiorno (S), Libeccio (SW)
        badWinds: ["SE", "S", "SW"],
      ),
      Beach(
        name: "Cala Preveto",
        lat: 37.9158,
        lon: 12.2982,
        exposure: "S",
        // Esposta a: Scirocco (SE), Mezzogiorno (S), Libeccio (SW)
        badWinds: ["SE", "S", "SW"],
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA OVEST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Rotonda",
        lat: 37.9213,
        lon: 12.2878,
        exposure: "W",
        // Esposta a: Maestrale (NW), Ponente (W), Libeccio (SW)
        badWinds: ["NW", "W", "SW"],
      ),
      Beach(
        name: "Cala Grande",
        lat: 37.9250,
        lon: 12.2800,
        exposure: "W",
        // Esposta a: Maestrale (NW), Ponente (W)
        badWinds: ["NW", "W"],
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD-OVEST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Faraglioni",
        lat: 37.9463,
        lon: 12.3160,
        exposure: "NW",
        // Esposta a: Maestrale (NW), Ponente (W), Tramontana (N)
        badWinds: ["NW", "W", "N"],
      ),
      Beach(
        name: "Cala del Pozzo",
        lat: 37.9402,
        lon: 12.2905,
        exposure: "NW",
        // Esposta a: Maestrale (NW), Ponente (W)
        badWinds: ["NW", "W"],
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD (CENTRO)
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Spiaggia Praia",
        lat: 37.9315,
        lon: 12.3268,
        exposure: "N",
        // Esposta a: Tramontana (N), Grecale (NE)
        badWinds: ["N", "NE"],
      ),
    ];
  }
}
