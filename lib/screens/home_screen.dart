import 'dart:async';
import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../models/ad.dart';
import '../services/weather_service.dart';
import '../services/ad_service.dart';
import '../utils/wind_logic.dart';
import '../l10n/app_translations.dart';
import 'components/beach_card.dart';
import 'components/ad_banner.dart';
import 'components/island_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final WeatherService _weatherService = WeatherService();
  final AdService _adService = AdService();

  Map<String, dynamic>? _weatherData;
  List<Beach> _beaches = [];
  Ad? _stickyAd;
  Ad? _nativeAd;
  bool _isLoading = true;
  String? _error;
  String?
      _selectedBeachName; // Per evidenziare la scheda selezionata dalla mappa

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _listKey = GlobalKey();

  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
      _startAutoRefresh();
    } else if (state == AppLifecycleState.paused) {
      _refreshTimer?.cancel();
    }
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final weather = await _weatherService.fetchCurrentWeather();
      final allAds = await _adService.fetchAds();
      final filteredAds = _adService.filterAdsByTime(allAds);
      final stickyAd = filteredAds.where((ad) => ad.isSticky).firstOrNull;
      final nativeAd = filteredAds.where((ad) => ad.isNative).firstOrNull;

      final beaches = Beach.getBeaches();
      for (var beach in beaches) {
        beach.status = WindLogic.calculateStatus(
          (weather['windspeed'] as num).toDouble(),
          (weather['winddirection'] as num).toDouble(),
          beach,
        );
      }

      beaches.sort((a, b) => a.status.index.compareTo(b.status.index));

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

  /// Scrolla alla spiaggia selezionata nella lista
  void _scrollToBeach(Beach beach) {
    debugPrint('_scrollToBeach called for: ${beach.name}');

    final index = _beaches.indexWhere((b) => b.name == beach.name);
    debugPrint('Beach index in sorted list: $index');

    if (index == -1) {
      debugPrint('Beach not found in list!');
      return;
    }

    // Altezze misurate
    const double mapHeight = 335.0;
    const double cardHeight = 248.0;
    const double nativeAdHeight = 200.0;

    double offset = mapHeight;

    // Calcola offset per le card prima dell'indice target
    for (int i = 0; i < index; i++) {
      offset += cardHeight;
      if (i == 2 && _nativeAd != null) {
        offset += nativeAdHeight;
      }
    }

    // Aggiungi ~150px per centrare la card sullo schermo (più in alto)
    offset += 150.0;

    // Limita l'offset al massimo scrollabile
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (offset > maxScroll) {
      offset = maxScroll;
    }

    debugPrint('Scrolling to offset: $offset');

    // Imposta lo spot selezionato per evidenziarlo
    setState(() {
      _selectedBeachName = beach.name;
    });

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final translations = AppTranslations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translations.appTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _loadData();
            },
          ),
        ],
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
              ? _buildErrorWidget(translations)
              : Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: IslandMapWidget(
                              beaches: _beaches,
                              windSpeed: (_weatherData!['windspeed'] as num)
                                  .toDouble(),
                              windDirection:
                                  (_weatherData!['winddirection'] as num)
                                      .toDouble(),
                              onBeachTap: _scrollToBeach,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.beach_access,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    translations.bestBeaches,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_beaches.where((b) => b.status == BeachStatus.green).length} ${translations.topSpot}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            key: _listKey,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index == 3 && _nativeAd != null) {
                                  return AdBanner(
                                    ad: _nativeAd!,
                                    isSticky: false,
                                  );
                                }

                                final beachIndex =
                                    (index > 3 && _nativeAd != null)
                                        ? index - 1
                                        : index;

                                if (beachIndex >= _beaches.length) {
                                  return const SizedBox.shrink();
                                }

                                return BeachCard(
                                  beach: _beaches[beachIndex],
                                  translations: translations,
                                  isSelected: _selectedBeachName ==
                                      _beaches[beachIndex].name,
                                );
                              },
                              childCount: _beaches.length +
                                  (_beaches.length >= 3 && _nativeAd != null
                                      ? 1
                                      : 0),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 70),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildErrorWidget(AppTranslations translations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              translations.error,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadData();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}
