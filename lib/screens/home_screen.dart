import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../models/ad.dart';
import '../services/weather_service.dart';
import '../services/ad_service.dart';
import '../utils/wind_logic.dart';
import '../l10n/app_translations.dart';
import 'components/beach_card.dart';
import 'components/ad_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final AdService _adService = AdService();

  Map<String, dynamic>? _weatherData;
  List<Beach> _beaches = [];
  Ad? _stickyAd;
  Ad? _nativeAd;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. Fetch Weather
      final weather = await _weatherService.fetchCurrentWeather();

      // 2. Fetch Ads
      final allAds = await _adService.fetchAds();
      final filteredAds = _adService.filterAdsByTime(allAds);

      // Separate ads by position
      final stickyAd = filteredAds.where((ad) => ad.isSticky).firstOrNull;
      final nativeAd = filteredAds.where((ad) => ad.isNative).firstOrNull;

      // 3. Process Beaches
      final beaches = Beach.getBeaches();
      for (var beach in beaches) {
        beach.status = WindLogic.calculateStatus(
          (weather['windspeed'] as num).toDouble(),
          (weather['winddirection'] as num).toDouble(),
          beach,
        );
      }

      // 4. Sort Beaches (Green first)
      beaches.sort((a, b) {
        // Green = 0, Yellow = 1, Red = 2 (by enum index)
        return a.status.index.compareTo(b.status.index);
      });

      if (mounted) {
        setState(() {
          _weatherData = weather;
          _stickyAd = stickyAd;
          _nativeAd = nativeAd;
          _beaches = beaches;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Basic localization - in a real app use Localizations.of(context)
    final locale = Localizations.localeOf(context);
    final translations = AppTranslations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.appTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(translations.loading),
                ],
              ),
            )
          : _error != null
              ? Center(child: Text(translations.error))
              : Column(
                  children: [
                    // Weather Widget
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blueAccent.withValues(alpha: 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.air,
                                  size: 32, color: Colors.blue),
                              Text("${_weatherData!['windspeed']} km/h"),
                              Text(translations.wind),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.explore,
                                size: 32,
                                color: Colors.orange,
                              ),
                              Text("${_weatherData!['winddirection']}°"),
                              Text(translations.direction),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: ListView.builder(
                        itemCount: _beaches.length +
                            (_beaches.length >= 3 && _nativeAd != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Insert Native Ad after 3rd element (index 3)
                          if (index == 3 && _nativeAd != null) {
                            return AdBanner(
                              ad: _nativeAd!,
                              isSticky: false,
                            );
                          }

                          // Adjust index for beaches if we passed the ad
                          final beachIndex = (index > 3 && _nativeAd != null)
                              ? index - 1
                              : index;
                          if (beachIndex >= _beaches.length)
                            return const SizedBox.shrink();

                          return BeachCard(
                            beach: _beaches[beachIndex],
                            translations: translations,
                          );
                        },
                      ),
                    ),

                    // Sticky Ad (fixed at bottom)
                    if (_stickyAd != null)
                      SafeArea(
                        top: false,
                        child: AdBanner(
                          ad: _stickyAd!,
                          isSticky: true,
                        ),
                      ),
                  ],
                ),
    );
  }
}
