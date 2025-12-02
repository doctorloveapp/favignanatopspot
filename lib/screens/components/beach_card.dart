import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/beach.dart';
import '../../l10n/app_translations.dart';

class BeachCard extends StatelessWidget {
  final Beach beach;
  final AppTranslations translations;

  const BeachCard({super.key, required this.beach, required this.translations});

  Color _getStatusColor(BeachStatus status) {
    switch (status) {
      case BeachStatus.green:
        return Colors.green;
      case BeachStatus.yellow:
        return Colors.orange;
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

  Future<void> _launchMaps() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${beach.lat},${beach.lon}';
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  beach.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(beach.status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(beach.status)),
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
    );
  }
}
