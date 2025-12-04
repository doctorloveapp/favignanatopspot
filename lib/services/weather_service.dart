import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

/// Servizio per recuperare i dati meteo da Open-Meteo API.
///
/// Gestisce:
/// - Timeout di connessione (15 secondi)
/// - Errori DNS (SocketException)
/// - Errori di rete generici
/// - Retry automatico con backoff
class WeatherService {
  static const String _apiUrl =
      "https://api.open-meteo.com/v1/forecast?latitude=37.9300&longitude=12.3270&current_weather=true";

  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 3;

  /// Cache dei dati meteo per fallback
  static Map<String, dynamic>? _cachedWeather;

  Future<Map<String, dynamic>> fetchCurrentWeather() async {
    // Retry con backoff esponenziale
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          // Backoff: 1s, 2s, 4s...
          await Future.delayed(Duration(seconds: 1 << attempt));
        }

        final client = http.Client();
        try {
          final response =
              await client.get(Uri.parse(_apiUrl)).timeout(_timeout);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final weather = data['current_weather'] as Map<String, dynamic>;

            // Salva in cache per fallback futuro
            _cachedWeather = weather;

            return weather;
          }
        } finally {
          client.close();
        }
      } on SocketException {
        // Errore DNS o connessione di rete - continua retry
      } on TimeoutException {
        // Timeout - continua retry
      } on FormatException {
        // Risposta non valida - continua retry
      } catch (_) {
        // Altri errori - continua retry
      }
    }

    // Se abbiamo dati in cache, usiamoli come fallback
    if (_cachedWeather != null) {
      return _cachedWeather!;
    }

    // Altrimenti, restituisci dati di default (vento leggero)
    // Questo permette all'app di funzionare offline mostrando tutto verde
    return {
      'windspeed': 3.0,
      'winddirection': 0.0,
      'temperature': 25.0,
      'weathercode': 0,
      'is_fallback': true,
    };
  }
}
