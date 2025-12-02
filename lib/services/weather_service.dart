import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiUrl =
      "https://api.open-meteo.com/v1/forecast?latitude=37.9300&longitude=12.3270&current_weather=true";

  Future<Map<String, dynamic>> fetchCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['current_weather'];
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }
}
