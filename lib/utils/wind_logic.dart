import '../models/beach.dart';

/// Wind Engine - Core logic for calculating beach conditions.
///
/// The engine determines beach status based on wind speed and direction:
/// - VERDE (Green): Calm sea - ideal conditions
/// - GIALLO (Yellow): Acceptable - side winds
/// - ROSSO (Red): Rough sea - frontal winds
///
/// Fasce di velocità vento:
/// - < 5 km/h: Tutti gli spot VERDI (mare calmo assoluto)
/// - 5-10 km/h: Solo VERDE o GIALLO (vento leggero, no rosso)
/// - > 10 km/h: Valutazione completa VERDE/GIALLO/ROSSO
///
/// Eccezioni speciali:
/// - Cala Azzurra: conca pronunciata, VERDE con venti da N, NW, W
class WindLogic {
  /// Direzioni vento che rendono Cala Azzurra sempre VERDE
  /// (conca pronunciata protetta da Nord, Nord-Ovest, Ovest)
  static const List<String> _calaAzzurraSafeWinds = ['N', 'NW', 'W'];

  /// Calculate the beach status based on current wind conditions.
  ///
  /// [windSpeedKmH] - Current wind speed in km/h
  /// [windDirectionDegrees] - Wind direction in degrees (0-360, where 0=N, 90=E, etc.)
  /// [beach] - The beach to evaluate
  static BeachStatus calculateStatus(
    double windSpeedKmH,
    double windDirectionDegrees,
    Beach beach,
  ) {
    // Rule 1: If wind is very weak (< 5 km/h), always GREEN (calm sea)
    if (windSpeedKmH < 5) {
      return BeachStatus.green;
    }

    // Rule 1b: Cala Azzurra special case - GREEN with N, NW, W winds
    // La conca pronunciata protegge completamente da questi venti
    if (beach.name == "Cala Azzurra") {
      final windCardinal = _degreesToCardinal(windDirectionDegrees);
      if (_calaAzzurraSafeWinds.contains(windCardinal)) {
        return BeachStatus.green;
      }
    }

    // Rule 2: For all winds >= 5 km/h, calculate based on angle difference
    // Beach exposure angle (where the beach faces)
    double beachAngle = _cardinalToDegrees(beach.exposure);

    // Calculate angular difference between wind direction and beach exposure
    // Wind direction indicates where wind comes FROM
    // Beach exposure indicates where beach FACES (open to the sea)
    double diff = (windDirectionDegrees - beachAngle).abs();
    if (diff > 180) diff = 360 - diff;

    // Apply shelter bonus for beaches in pronounced coves
    final offshoreThreshold = 130 + beach.shelterBonus;

    // Rule 2a: Offshore wind (from behind) -> GREEN (calm sea)
    // Wind blowing from land towards sea
    if (diff >= offshoreThreshold) {
      return BeachStatus.green;
    }

    // Rule 2b: Light wind (5-10 km/h) -> Only GREEN or YELLOW (no RED)
    // Even frontal winds don't create significant waves at this speed
    if (windSpeedKmH < 10) {
      return BeachStatus.yellow;
    }

    // Rule 3: For stronger winds (>= 10 km/h), full evaluation
    final frontalThreshold = 45 + (beach.shelterBonus ~/ 2);

    // Rule 3a: Frontal wind (within threshold) -> RED (rough sea)
    if (diff <= frontalThreshold) {
      return BeachStatus.red;
    }

    // Rule 3b: Side wind -> YELLOW (acceptable)
    return BeachStatus.yellow;
  }

  /// Convert degrees to cardinal direction.
  static String _degreesToCardinal(double degrees) {
    // Normalize to 0-360
    degrees = degrees % 360;
    if (degrees < 0) degrees += 360;

    // Each cardinal direction covers 45° (±22.5° from center)
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SW';
    if (degrees >= 247.5 && degrees < 292.5) return 'W';
    if (degrees >= 292.5 && degrees < 337.5) return 'NW';
    return 'N';
  }

  /// Convert cardinal direction to degrees.
  static double _cardinalToDegrees(String cardinal) {
    switch (cardinal) {
      case "N":
        return 0;
      case "NE":
        return 45;
      case "E":
        return 90;
      case "SE":
        return 135;
      case "S":
        return 180;
      case "SW":
        return 225;
      case "W":
        return 270;
      case "NW":
        return 315;
      default:
        return 0;
    }
  }
}
