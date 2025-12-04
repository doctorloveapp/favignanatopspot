enum BeachStatus { green, yellow, red }

/// Modello dati per una spiaggia di Favignana.
///
/// [exposure] indica la direzione verso cui la spiaggia è aperta (es. "NE" = Nord-Est)
/// [badWinds] lista dei venti che rendono il mare mosso (venti frontali)
/// [mapX] e [mapY] sono le coordinate relative (0.0-1.0) sulla mappa dell'isola
/// [shelterBonus] gradi extra di protezione per spiagge in conche pronunciate (default 0)
///
/// Regola Generale:
/// "Se il vento soffia da una direzione, cerca una spiaggia sulla costa opposta dell'isola."
class Beach {
  final String name;
  final double lat;
  final double lon;
  final String exposure; // N, S, E, W, NE, SE, NW, SW
  final List<String> badWinds; // Winds that make the sea rough
  final double mapX; // Posizione X sulla mappa (0.0 = sinistra, 1.0 = destra)
  final double mapY; // Posizione Y sulla mappa (0.0 = alto, 1.0 = basso)
  final int shelterBonus; // Gradi extra di protezione per conche pronunciate
  BeachStatus status;

  Beach({
    required this.name,
    required this.lat,
    required this.lon,
    required this.exposure,
    required this.badWinds,
    required this.mapX,
    required this.mapY,
    this.shelterBonus = 0, // Default: nessuna protezione extra
    this.status = BeachStatus.green, // Default
  });

  /// Restituisce la lista completa delle spiagge di Favignana.
  ///
  /// Dati aggiornati con coordinate GPS precise e venti sfavorevoli verificati.
  /// Le coordinate mapX/mapY sono calibrate sulla mappa mappaOK.png
  /// Fonte: Mappatura locale dell'isola di Favignana.
  static List<Beach> getBeaches() {
    return [
      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD-EST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Rossa",
        lat: 37.922464,
        lon: 12.363907,
        exposure: "NE",
        badWinds: [
          "N",
          "NE"
        ], // Maestrale (NW) arriva laterale ma può disturbare
        mapX: 0.801,
        mapY: 0.578,
      ),
      Beach(
        name: "Cala San Nicola",
        lat: 37.935022,
        lon: 12.346703,
        exposure: "NE",
        badWinds: ["NE", "N"],
        mapX: 0.691,
        mapY: 0.350,
      ),
      Beach(
        name: "Scalo Cavallo",
        lat: 37.930894,
        lon: 12.349999,
        exposure: "NE",
        badWinds: ["NE", "N"],
        mapX: 0.720,
        mapY: 0.414,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA EST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Bue Marino",
        lat: 37.917222,
        lon: 12.369920,
        exposure: "E",
        badWinds: ["E", "SE", "NE"],
        mapX: 0.850,
        mapY: 0.661,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA SUD
      // ═══════════════════════════════════════════════════════════════
      // Cala Azzurra: conca molto pronunciata, ben difesa dai venti
      // di Nord, Nord-Ovest e Ovest. Esposta solo a Sud e Sud-Est.
      // shelterBonus: +60° di tolleranza extra (Maestrale/Ponente = VERDE)
      Beach(
        name: "Cala Azzurra",
        lat: 37.908715,
        lon: 12.361280,
        exposure: "S",
        badWinds: ["S", "SE"], // Solo venti frontali diretti
        shelterBonus: 60, // Conca molto pronunciata: massima tolleranza
        mapX: 0.773,
        mapY: 0.783,
      ),
      Beach(
        name: "Punta Marsala",
        lat: 37.907304,
        lon: 12.366618,
        exposure: "SE",
        badWinds: ["SE", "E", "S"],
        mapX: 0.828,
        mapY: 0.772,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA SUD
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Lido Burrone",
        lat: 37.918272,
        lon: 12.338202,
        exposure: "S",
        badWinds: ["SE", "SW"],
        mapX: 0.605,
        mapY: 0.627,
      ),
      Beach(
        name: "Cala Preveto",
        lat: 37.918953,
        lon: 12.302630,
        exposure: "S",
        badWinds: ["SE", "SW"],
        mapX: 0.375,
        mapY: 0.623,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD (CENTRO)
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Spiaggia Praia",
        lat: 37.929608,
        lon: 12.325196,
        exposure: "N",
        badWinds: ["N", "NE"],
        mapX: 0.540,
        mapY: 0.380,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Faraglioni",
        lat: 37.954491,
        lon: 12.306777,
        exposure: "N",
        badWinds: ["NW", "N"],
        mapX: 0.410,
        mapY: 0.139,
      ),
      Beach(
        name: "Cala Trapanese",
        lat: 37.953404,
        lon: 12.308071,
        exposure: "N",
        badWinds: ["N", "NW", "NE"],
        mapX: 0.428,
        mapY: 0.162,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA NORD-OVEST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala del Pozzo",
        lat: 37.942171,
        lon: 12.287885,
        exposure: "NW",
        badWinds: ["NW", "W"],
        mapX: 0.250,
        mapY: 0.280,
      ),

      // ═══════════════════════════════════════════════════════════════
      // COSTA OVEST
      // ═══════════════════════════════════════════════════════════════
      Beach(
        name: "Cala Rotonda",
        lat: 37.923715,
        lon: 12.284060,
        exposure: "W",
        badWinds: ["W", "NW"],
        mapX: 0.237,
        mapY: 0.552,
      ),
      Beach(
        name: "Cala Grande",
        lat: 37.931035,
        lon: 12.279523,
        exposure: "W",
        badWinds: ["W", "SW"],
        mapX: 0.180,
        mapY: 0.450,
      ),
      Beach(
        name: "Spiaggia di Ponente",
        lat: 37.935384,
        lon: 12.276704,
        exposure: "W",
        badWinds: ["W", "NW"],
        mapX: 0.182,
        mapY: 0.394,
      ),
    ];
  }
}
