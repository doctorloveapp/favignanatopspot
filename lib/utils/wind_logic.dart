import '../models/beach.dart';

/// Wind Engine - Core logic for calculating beach conditions.
///
/// The engine determines beach status based on wind speed and direction:
/// - VERDE (Green): Calm sea - ideal conditions
/// - GIALLO (Yellow): Acceptable - side winds
/// - ROSSO (Red): Rough sea - frontal winds
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
    // Rule 1: If wind is weak (< 10 km/h), always GREEN (calm sea)
    if (windSpeedKmH < 10) {
      return BeachStatus.green;
    }

    // Rule 2: For stronger winds, calculate based on angle difference
    // Beach exposure angle (where the beach faces)
    double beachAngle = _cardinalToDegrees(beach.exposure);

    // Calculate angular difference between wind direction and beach exposure
    // Wind direction indicates where wind comes FROM
    // Beach exposure indicates where beach FACES (open to the sea)
    double diff = (windDirectionDegrees - beachAngle).abs();
    if (diff > 180) diff = 360 - diff;

    // Rule 2a: Frontal wind (within 45°) -> RED (rough sea)
    // Wind coming from the direction the beach faces
    if (diff <= 45) {
      return BeachStatus.red;
    }

    // Rule 2b: Offshore wind (from behind, 135°+) -> GREEN (calm sea)
    // Wind blowing from land towards sea
    if (diff >= 135) {
      return BeachStatus.green;
    }

    // Rule 2c: Side wind (45° to 135°) -> YELLOW (acceptable)
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
