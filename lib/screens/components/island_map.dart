import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/beach.dart';

/// Widget che visualizza la mappa dell'isola di Favignana con:
/// - Immagine mappa di sfondo
/// - Marker colorati per ogni spiaggia (verde/giallo/rosso)
/// - Animazione del vento con particelle
/// - Indicatore del Nord
class IslandMapWidget extends StatefulWidget {
  final List<Beach> beaches;
  final double windSpeed;
  final double windDirection;
  final Function(Beach)? onBeachTap;

  const IslandMapWidget({
    super.key,
    required this.beaches,
    required this.windSpeed,
    required this.windDirection,
    this.onBeachTap,
  });

  @override
  State<IslandMapWidget> createState() => _IslandMapWidgetState();
}

class _IslandMapWidgetState extends State<IslandMapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mappa con overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // 1. Mappa di sfondo
                  Image.asset(
                    'assets/mappaOK.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),

                  // 2. Overlay animazione vento
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: WindParticlesPainter(
                            windDirection: widget.windDirection,
                            windSpeed: widget.windSpeed,
                            animationValue: _animationController.value,
                          ),
                        );
                      },
                    ),
                  ),

                  // 3. Marker spiagge
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: widget.beaches.map((beach) {
                            return Positioned(
                              left: beach.mapX * constraints.maxWidth - 10,
                              top: beach.mapY * constraints.maxHeight - 10,
                              child: _BeachMarker(
                                beach: beach,
                                onTap: () => widget.onBeachTap?.call(beach),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                  // 4. Indicatore Vento (più trasparente)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _WindCompass(
                      windDirection: widget.windDirection,
                      windSpeed: widget.windSpeed,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Legenda sotto la mappa in riga orizzontale
          const SizedBox(height: 8),
          const _MapLegend(),
        ],
      ),
    );
  }
}

/// Marker per una singola spiaggia sulla mappa
class _BeachMarker extends StatelessWidget {
  final Beach beach;
  final VoidCallback? onTap;

  const _BeachMarker({required this.beach, this.onTap});

  Color get _color {
    switch (beach.status) {
      case BeachStatus.green:
        return Colors.green;
      case BeachStatus.yellow:
        return Colors.amber; // Giallo vero invece di arancione
      case BeachStatus.red:
        return Colors.red;
    }
  }

  IconData get _icon {
    switch (beach.status) {
      case BeachStatus.green:
        return Icons.check_circle;
      case BeachStatus.yellow:
        return Icons.warning;
      case BeachStatus.red:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: beach.name,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _color.withValues(alpha: 0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            _icon,
            color: Colors.white,
            size: 11,
          ),
        ),
      ),
    );
  }
}

/// Indicatore direzione e velocità del vento
class _WindCompass extends StatelessWidget {
  final double windDirection;
  final double windSpeed;

  const _WindCompass({
    required this.windDirection,
    required this.windSpeed,
  });

  String get _windLabel {
    if (windDirection >= 337.5 || windDirection < 22.5) return 'Tramontana';
    if (windDirection >= 22.5 && windDirection < 67.5) return 'Grecale';
    if (windDirection >= 67.5 && windDirection < 112.5) return 'Levante';
    if (windDirection >= 112.5 && windDirection < 157.5) return 'Scirocco';
    if (windDirection >= 157.5 && windDirection < 202.5) return 'Mezzogiorno';
    if (windDirection >= 202.5 && windDirection < 247.5) return 'Libeccio';
    if (windDirection >= 247.5 && windDirection < 292.5) return 'Ponente';
    return 'Maestrale';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icona vento con freccia rotante
          SizedBox(
            width: 28,
            height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cerchio di sfondo
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade100,
                        Colors.blue.shade50,
                      ],
                    ),
                    border: Border.all(color: Colors.blue.shade200, width: 1),
                  ),
                ),
                // Freccia vento che indica DA DOVE viene il vento
                Transform.rotate(
                  angle: windDirection * pi / 180,
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.blue.shade700,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          // Nome vento italiano
          Text(
            _windLabel,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 1),
          // Velocità
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${windSpeed.toInt()} km/h',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Legenda della mappa - riga orizzontale sotto la mappa
class _MapLegend extends StatelessWidget {
  const _MapLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.green, 'Mare Calmo'),
        const SizedBox(width: 16),
        _legendItem(Colors.amber, 'Accettabile'),
        const SizedBox(width: 16),
        _legendItem(Colors.red, 'Mare Mosso'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// CustomPainter per le particelle del vento animate
class WindParticlesPainter extends CustomPainter {
  final double windDirection;
  final double windSpeed;
  final double animationValue;

  WindParticlesPainter({
    required this.windDirection,
    required this.windSpeed,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (windSpeed < 3) return; // Non mostrare particelle se vento molto debole

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final random = Random(42); // Seed fisso per consistenza
    // Aumentato numero particelle: minimo 25, massimo 80 in base al vento
    final particleCount = (windSpeed * 2.5).clamp(25, 80).toInt();

    // IMPORTANTE: windDirection indica DA DOVE viene il vento
    // Le particelle devono muoversi nella direzione OPPOSTA (verso dove VA il vento)
    // Esempio: vento da Nord (0°) → particelle vanno verso Sud (si muovono verso il basso)
    //
    // Inoltre, nella convenzione grafica Flutter/schermo:
    // - Y cresce verso il BASSO (non verso l'alto come in matematica)
    // - X cresce verso destra
    //
    // Quindi per un vento da Nord (0°):
    // - Le particelle devono andare verso il basso (Y positivo)
    // - moveAngle = windDirection (0°) in gradi, ma dobbiamo convertire per lo schermo
    //
    // Conversione: in Flutter, 0° = destra, 90° = basso, 180° = sinistra, 270° = alto
    // Ma windDirection usa: 0° = Nord, 90° = Est, 180° = Sud, 270° = Ovest
    //
    // Per convertire: moveAngleScreen = windDirection + 90° (per ruotare il sistema di riferimento)
    // Poi le particelle vanno VERSO quella direzione (non da quella direzione)
    final moveAngle = (windDirection + 90) *
        pi /
        180; // +90 per convertire da meteo a schermo

    for (int i = 0; i < particleCount; i++) {
      // Posizione iniziale casuale con distribuzione su tutta la mappa
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;

      // Offset basato sull'animazione con sfasamento per ogni particella
      final phaseOffset = (i * 0.037) % 1.0; // Sfasamento unico per particella
      final progress = (animationValue + phaseOffset) % 1.0;
      final distance = progress * 120 * (windSpeed / 15).clamp(0.6, 2.5);

      // Calcola posizione della particella
      // cos(angle) = movimento orizzontale, sin(angle) = movimento verticale
      final x = startX + cos(moveAngle) * distance;
      final y = startY + sin(moveAngle) * distance;

      // Lunghezza della linea (particella) proporzionale al vento
      // La coda della particella è nella direzione opposta al movimento
      final lineLength = 18 * (windSpeed / 15).clamp(0.5, 2.0);
      final endX = x - cos(moveAngle) * lineLength;
      final endY = y - sin(moveAngle) * lineLength;

      // Opacità con fade in/out più morbido
      final fadeIn = (progress * 3).clamp(0.0, 1.0);
      final fadeOut = ((1 - progress) * 2).clamp(0.0, 1.0);
      final opacity = fadeIn * fadeOut * 0.65;
      paint.color = Colors.white.withValues(alpha: opacity);

      canvas.drawLine(
        Offset(x, y),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WindParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.windDirection != windDirection ||
        oldDelegate.windSpeed != windSpeed;
  }
}
