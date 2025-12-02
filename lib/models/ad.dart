/// Represents an advertisement banner.
///
/// [type] determines when the ad is shown:
/// - 'morning': 06:00 - 11:00
/// - 'lunch': 11:00 - 15:00
/// - 'dinner': 19:00 - 24:00
/// - 'all': Always shown
///
/// [position] determines where the ad appears:
/// - 'sticky': Fixed at bottom (ratio 6:1)
/// - 'native': In list after 3rd item (ratio 16:9)
class Ad {
  final String imageUrl;
  final String linkUrl;
  final String type;
  final String position; // 'sticky' or 'native'

  Ad({
    required this.imageUrl,
    required this.linkUrl,
    required this.type,
    this.position = 'sticky',
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      imageUrl: json['imageUrl'],
      linkUrl: json['linkUrl'],
      type: json['type'],
      position: json['position'] ?? 'sticky',
    );
  }

  bool get isSticky => position == 'sticky';
  bool get isNative => position == 'native';
}
