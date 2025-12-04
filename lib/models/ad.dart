/// Represents an advertisement banner.
///
/// [timeSlots] determines when the ad is shown:
/// - 'MORNING': 06:00 - 11:00
/// - 'LUNCH': 11:00 - 15:00
/// - 'DINNER': 19:00 - 24:00
/// - 'ALL_DAY': Always shown
///
/// [type] determines where the ad appears:
/// - 'STICKY_BOTTOM': Fixed at bottom (ratio 6:1)
/// - 'NATIVE': In list after 3rd item (ratio 16:9)
class Ad {
  final String id;
  final String clientName;
  final String imageUrl;
  final String linkUrl;
  final String type; // 'STICKY_BOTTOM' or 'NATIVE'
  final List<String> timeSlots;

  Ad({
    required this.id,
    required this.clientName,
    required this.imageUrl,
    required this.linkUrl,
    required this.type,
    required this.timeSlots,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    // Supporta sia il vecchio formato che il nuovo
    final rawType = json['type']?.toString() ?? 'STICKY_BOTTOM';
    final position = json['position']?.toString();

    // Converti vecchio formato position in nuovo type
    String adType;
    if (rawType == 'STICKY_BOTTOM' || rawType == 'NATIVE') {
      adType = rawType;
    } else if (position == 'sticky') {
      adType = 'STICKY_BOTTOM';
    } else if (position == 'native') {
      adType = 'NATIVE';
    } else {
      adType = 'STICKY_BOTTOM';
    }

    // Parse timeSlots
    List<String> slots = ['ALL_DAY'];
    if (json['timeSlots'] != null) {
      slots = List<String>.from(json['timeSlots']);
    } else if (json['type'] != null &&
        !['STICKY_BOTTOM', 'NATIVE'].contains(json['type'])) {
      // Vecchio formato: type era il time slot
      final oldType = json['type'].toString().toUpperCase();
      if (oldType == 'ALL') {
        slots = ['ALL_DAY'];
      } else {
        slots = [oldType];
      }
    }

    return Ad(
      id: json['id']?.toString() ??
          'ad_${DateTime.now().millisecondsSinceEpoch}',
      clientName: json['clientName']?.toString() ?? 'Sponsor',
      imageUrl: json['imageUrl'] ?? '',
      linkUrl: json['linkUrl'] ?? '',
      type: adType,
      timeSlots: slots,
    );
  }

  bool get isSticky => type == 'STICKY_BOTTOM';
  bool get isNative => type == 'NATIVE';

  /// Verifica se l'ad deve essere mostrato in base all'ora corrente
  bool shouldShowNow() {
    if (timeSlots.contains('ALL_DAY')) return true;

    final hour = DateTime.now().hour;

    if (timeSlots.contains('MORNING') && hour >= 6 && hour < 11) return true;
    if (timeSlots.contains('LUNCH') && hour >= 11 && hour < 15) return true;
    if (timeSlots.contains('DINNER') && hour >= 19 && hour < 24) return true;

    return false;
  }
}
