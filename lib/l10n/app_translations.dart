import 'dart:ui';

class AppTranslations {
  final Locale locale;

  AppTranslations(this.locale);

  // Fallback to English if locale not supported
  String get _langCode => _localizedValues.containsKey(locale.languageCode)
      ? locale.languageCode
      : 'en';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Favignana Top Spot',
      'bestBeaches': 'Best Beaches',
      'strongWind': 'Strong Wind',
      'calmSea': 'Calm Sea',
      'roughSea': 'Rough Sea',
      'acceptable': 'Acceptable',
      'navigate': 'Navigate',
      'loading': 'Loading weather...',
      'error': 'Error loading data',
      'wind': 'Wind',
      'morning': 'Morning',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'exposure': 'Exposure',
      'direction': 'Direction',
      'topSpot': 'Top Spot',
    },
    'it': {
      'appTitle': 'Favignana Top Spot',
      'bestBeaches': 'Migliori Spiagge',
      'strongWind': 'Vento Forte',
      'calmSea': 'Mare Calmo',
      'roughSea': 'Mare Mosso',
      'acceptable': 'Accettabile',
      'navigate': 'Portami qui',
      'loading': 'Caricamento meteo...',
      'error': 'Errore caricamento dati',
      'wind': 'Vento',
      'morning': 'Mattina',
      'lunch': 'Pranzo',
      'dinner': 'Cena',
      'exposure': 'Esposizione',
      'direction': 'Direzione',
      'topSpot': 'Top Spot',
    },
  };

  String get appTitle => _localizedValues[_langCode]!['appTitle']!;
  String get bestBeaches => _localizedValues[_langCode]!['bestBeaches']!;
  String get strongWind => _localizedValues[_langCode]!['strongWind']!;
  String get calmSea => _localizedValues[_langCode]!['calmSea']!;
  String get roughSea => _localizedValues[_langCode]!['roughSea']!;
  String get acceptable => _localizedValues[_langCode]!['acceptable']!;
  String get navigate => _localizedValues[_langCode]!['navigate']!;
  String get loading => _localizedValues[_langCode]!['loading']!;
  String get error => _localizedValues[_langCode]!['error']!;
  String get wind => _localizedValues[_langCode]!['wind']!;
  String get exposure => _localizedValues[_langCode]!['exposure']!;
  String get direction => _localizedValues[_langCode]!['direction']!;
  String get topSpot => _localizedValues[_langCode]!['topSpot']!;
}
