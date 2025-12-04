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
/// Protezione extra (shelterBonus):
/// Alcune spiagge in conche pronunciate (es. Cala Azzurra) hanno
/// protezione extra dai venti laterali grazie alla conformazione.
class WindLogic {
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

    // Rule 2: For all winds >= 5 km/h, calculate based on angle difference
    // Beach exposure angle (where the beach faces)
    double beachAngle = _cardinalToDegrees(beach.exposure);

    // Calculate angular difference between wind direction and beach exposure
    // Wind direction indicates where wind comes FROM
    // Beach exposure indicates where beach FACES (open to the sea)
    double diff = (windDirectionDegrees - beachAngle).abs();
    if (diff > 180) diff = 360 - diff;

    // Apply shelter bonus for beaches in pronounced coves
    // Cala Azzurra has +30° bonus, making offshore threshold 160° instead of 130°
    final offshoreThreshold = 130 + beach.shelterBonus;

    // Rule 2a: Offshore wind (from behind) -> GREEN (calm sea)
    // Wind blowing from land towards sea
    // Base threshold 130°, plus shelterBonus for protected coves
    if (diff >= offshoreThreshold) {
      return BeachStatus.green;
    }

    // Rule 2b: Light wind (5-10 km/h) -> Only GREEN or YELLOW (no RED)
    // Even frontal winds don't create significant waves at this speed
    if (windSpeedKmH < 10) {
      // Frontal or side winds with light breeze -> YELLOW (slightly choppy but safe)
      return BeachStatus.yellow;
    }

    // Rule 3: For stronger winds (>= 10 km/h), full evaluation
    // Apply shelter bonus to frontal threshold as well (more tolerance)
    final frontalThreshold =
        45 + (beach.shelterBonus ~/ 2); // Half bonus for frontal

    // Rule 3a: Frontal wind (within threshold) -> RED (rough sea)
    // Wind coming from the direction the beach faces
    if (diff <= frontalThreshold) {
      return BeachStatus.red;
    }

    // Rule 3b: Side wind -> YELLOW (acceptable)
    return BeachStatus.yellow;
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
