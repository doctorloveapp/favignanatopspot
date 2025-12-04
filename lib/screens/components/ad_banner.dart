import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ad.dart';

class AdBanner extends StatelessWidget {
  final Ad ad;
  final bool isSticky;

  const AdBanner({super.key, required this.ad, this.isSticky = false});

  Future<void> _launchURL() async {
    if (!await launchUrl(Uri.parse(ad.linkUrl))) {
      throw Exception('Could not launch ${ad.linkUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerContent = GestureDetector(
      onTap: _launchURL,
      child: Container(
        margin: isSticky
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        width: double.infinity,
        height: isSticky ? 72 : 200, // Altezza aumentata del 20% (60 → 72)
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: isSticky ? null : BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius:
              isSticky ? BorderRadius.zero : BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: ad.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );

    // Per il banner sticky, aggiungi una linea di separazione turchese
    if (isSticky) {
      // Colore turchese
      const turquoise = Color(0xFF00CED1); // Dark Turquoise

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Linea turchese sfumata ai lati
          Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  turquoise.withValues(alpha: 0.5),
                  turquoise,
                  turquoise.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
              ),
            ),
          ),
          bannerContent,
        ],
      );
    }

    return bannerContent;
  }
}
