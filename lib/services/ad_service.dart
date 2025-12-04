import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/ad.dart';

/// Servizio per caricare le pubblicità da Google Drive.
///
/// Gestisce:
/// - Timeout di connessione (15 secondi)
/// - Errori DNS (SocketException)
/// - Fallback automatico se rete non disponibile
class AdService {
  /// URL del file JSON di configurazione ads su Google Drive
  /// Formato: { "banners": [ { id, clientName, type, imageUrl, linkUrl, timeSlots } ] }
  static const String _adsConfigUrl =
      'https://drive.google.com/uc?export=download&id=1pav7QBy4-EFbxP_Q_2h3W1jJq2Ra6T0Z';

  static const Duration _timeout = Duration(seconds: 15);

  /// Ads di fallback se il caricamento da remoto fallisce
  static final List<Ad> _fallbackAds = [
    Ad(
      id: 'fallback_1',
      clientName: 'Favignana Top Spot',
      imageUrl: 'https://picsum.photos/600/100?random=1',
      linkUrl: 'https://example.com',
      type: 'STICKY_BOTTOM',
      timeSlots: ['ALL_DAY'],
    ),
  ];

  /// Carica le pubblicità dal file JSON remoto su Google Drive
  /// Se il caricamento fallisce, restituisce gli ads di fallback
  Future<List<Ad>> fetchAds() async {
    try {
      final client = http.Client();
      try {
        final response =
            await client.get(Uri.parse(_adsConfigUrl)).timeout(_timeout);

        if (response.statusCode == 200) {
          final body = response.body.trim();

          // Nuovo formato: { "banners": [...] }
          if (body.startsWith('{')) {
            final Map<String, dynamic> jsonMap = json.decode(body);
            if (jsonMap.containsKey('banners')) {
              final List<dynamic> banners = jsonMap['banners'];
              if (banners.isNotEmpty) {
                return banners.map((b) => Ad.fromJson(b)).toList();
              }
            }
          }
          // Vecchio formato: array diretto [...]
          else if (body.startsWith('[')) {
            final List<dynamic> jsonList = json.decode(body);
            if (jsonList.isNotEmpty) {
              return jsonList.map((json) => Ad.fromJson(json)).toList();
            }
          }
        }
      } finally {
        client.close();
      }

      // Se arriviamo qui, usa fallback
      return _fallbackAds;
    } on SocketException {
      // Errore DNS o rete non disponibile
      return _fallbackAds;
    } on TimeoutException {
      // Timeout connessione
      return _fallbackAds;
    } catch (_) {
      // Qualsiasi altro errore
      return _fallbackAds;
    }
  }

  /// Filtra gli ads in base all'ora corrente
  List<Ad> filterAdsByTime(List<Ad> ads) {
    return ads.where((ad) => ad.shouldShowNow()).toList();
  }
}
