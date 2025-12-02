enum BeachStatus { green, yellow, red }

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

  static List<Beach> getBeaches() {
    return [
      Beach(
        name: "Cala Rossa",
        lat: 37.9388,
        lon: 12.3592,
        exposure: "N",
        badWinds: ["N", "NE"],
      ),
      Beach(
        name: "Bue Marino",
        lat: 37.9350,
        lon: 12.3650,
        exposure: "NE",
        badWinds: ["N", "E", "NE"],
      ),
      Beach(
        name: "Lido Burrone",
        lat: 37.9150,
        lon: 12.3450,
        exposure: "S",
        badWinds: ["S", "SW"],
      ),
      Beach(
        name: "Cala Azzurra",
        lat: 37.9180,
        lon: 12.3700,
        exposure: "SE",
        badWinds: ["S", "SE"],
      ),
      Beach(
        name: "Cala Rotonda",
        lat: 37.9250,
        lon: 12.3100,
        exposure: "W",
        badWinds: ["W", "NW"],
      ),
    ];
  }
}
