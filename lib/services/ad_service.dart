import 'dart:convert';
import '../models/ad.dart';

class AdService {
  // Placeholder for remote JSON
  // In a real app, this would be an http.get call
  Future<List<Ad>> fetchAds() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock Data
    // Note: In production, replace with actual API call:
    // final response = await http.get(Uri.parse('YOUR_ADS_API_URL'));
    // Ratio 6:1 for sticky banners (e.g., 600x100)
    // Ratio 16:9 for native banners (e.g., 640x360)
    final String jsonString = '''
    [
      {
        "imageUrl": "https://picsum.photos/600/100?random=1", 
        "linkUrl": "https://example.com/breakfast",
        "type": "morning",
        "position": "sticky"
      },
      {
        "imageUrl": "https://picsum.photos/640/360?random=2",
        "linkUrl": "https://example.com/breakfast-native",
        "type": "morning",
        "position": "native"
      },
      {
        "imageUrl": "https://picsum.photos/600/100?random=3",
        "linkUrl": "https://example.com/lunch",
        "type": "lunch",
        "position": "sticky"
      },
      {
        "imageUrl": "https://picsum.photos/640/360?random=4",
        "linkUrl": "https://example.com/lunch-native",
        "type": "lunch",
        "position": "native"
      },
      {
        "imageUrl": "https://picsum.photos/600/100?random=5",
        "linkUrl": "https://example.com/dinner",
        "type": "dinner",
        "position": "sticky"
      },
      {
        "imageUrl": "https://picsum.photos/640/360?random=6",
        "linkUrl": "https://example.com/dinner-native",
        "type": "dinner",
        "position": "native"
      },
      {
        "imageUrl": "https://picsum.photos/600/100?random=7",
        "linkUrl": "https://example.com/promo",
        "type": "all",
        "position": "sticky"
      },
      {
        "imageUrl": "https://picsum.photos/640/360?random=8",
        "linkUrl": "https://example.com/promo-native",
        "type": "all",
        "position": "native"
      }
    ]
    ''';

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Ad.fromJson(json)).toList();
  }

  List<Ad> filterAdsByTime(List<Ad> ads) {
    final now = DateTime.now();
    final hour = now.hour;
    String currentType = 'morning';

    if (hour >= 6 && hour < 11) {
      currentType = 'morning';
    } else if (hour >= 11 && hour < 15) {
      currentType = 'lunch';
    } else if (hour >= 19 && hour < 24) {
      currentType = 'dinner';
    } else {
      currentType = 'all'; // Fallback or specific logic for afternoon/night
    }

    return ads
        .where((ad) => ad.type == currentType || ad.type == 'all')
        .toList();
  }
}
