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

    // Per il banner sticky, aggiungi una linea di separazione elegante
    if (isSticky) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Linea di separazione elegante
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
              ),
            ),
          ),
          // Sottile ombra sopra il banner
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.08),
                  Colors.transparent,
                ],
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
