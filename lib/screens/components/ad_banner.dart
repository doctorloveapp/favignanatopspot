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
    return GestureDetector(
      onTap: _launchURL,
      child: Container(
        margin: isSticky
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        width: double.infinity,
        height: isSticky ? 60 : 200, // Approx ratio 6:1 vs 16:9 (roughly)
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: isSticky ? null : BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: isSticky
              ? BorderRadius.zero
              : BorderRadius.circular(12),
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
  }
}
