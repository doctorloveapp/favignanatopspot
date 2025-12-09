import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/beach.dart';
import '../../l10n/app_translations.dart';

class BeachCard extends StatelessWidget {
  final Beach beach;
  final AppTranslations translations;
  final bool isSelected;

  const BeachCard({
    super.key,
    required this.beach,
    required this.translations,
    this.isSelected = false,
  });

  Color _getStatusColor(BeachStatus status) {
    switch (status) {
      case BeachStatus.green:
        return Colors.green;
      case BeachStatus.yellow:
        return Colors.amber; // Giallo vero invece di arancione
      case BeachStatus.red:
        return Colors.red;
    }
  }

  String _getStatusText(BeachStatus status) {
    switch (status) {
      case BeachStatus.green:
        return translations.calmSea; // Or "Top Spot"
      case BeachStatus.yellow:
        return translations.acceptable;
      case BeachStatus.red:
        return translations.roughSea;
    }
  }

  /// Restituisce il path dell'immagine corrispondente allo spot
  String _getImagePath() {
    // Mappa dei nomi spot ai file immagine
    final Map<String, String> imageMap = {
      'Cala Rossa': 'assets/spot/cala_rossa.jpg',
      'Cala San Nicola': 'assets/spot/cala_san_nicola.jpg',
      'Scalo Cavallo': 'assets/spot/scalo_cavallo.jpg',
      'Bue Marino': 'assets/spot/buemarino.jpg',
      'Cala Azzurra': 'assets/spot/cala_azzurra.jpeg',
      'Punta Marsala': 'assets/spot/punta_marsala.jpg',
      'Lido Burrone': 'assets/spot/lido_burrone.jpg',
      'Cala Preveto': 'assets/spot/cala_preveto.jpg',
      'Spiaggia Praia': 'assets/spot/spiaggia_praia.jpeg',
      'Cala Faraglioni': 'assets/spot/cala_faraglioni.jpg',
      'Cala Trapanese': 'assets/spot/cala_trapanese.jpg',
      'Cala del Pozzo': 'assets/spot/cala_del_pozzo.jpg',
      'Cala Rotonda': 'assets/spot/cala_rotonda.jpeg',
      'Cala Grande': 'assets/spot/cala_grande.jpg',
      'Spiaggia di Ponente': 'assets/spot/spiaggia_di_ponente.jpg',
    };
    return imageMap[beach.name] ?? 'assets/spot/cala_rossa.jpg';
  }

  Future<void> _launchMaps() async {
    // Usa il nome dello spot per la ricerca su Google Maps (più preciso delle coordinate GPS)
    final destination = Uri.encodeComponent('${beach.name}, Favignana, Italia');
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$destination';
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: isSelected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                // Effetto neon azzurro
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            )
          : null,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? const BorderSide(color: Colors.cyan, width: 3)
              : BorderSide.none,
        ),
        elevation: isSelected ? 8 : 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine dello spot con altezza fissa
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.asset(
                _getImagePath(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 40, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          beach.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(beach.status)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: _getStatusColor(beach.status)),
                        ),
                        child: Text(
                          _getStatusText(beach.status),
                          style: TextStyle(
                            color: _getStatusColor(beach.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("${translations.exposure}: ${beach.exposure}"),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _launchMaps,
                      icon: const Icon(Icons.navigation),
                      label: Text(translations.navigate),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // Close Card
    ); // Close Container
  }
}
