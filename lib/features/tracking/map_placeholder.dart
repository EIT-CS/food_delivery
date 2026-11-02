import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Газрын зургийн түр орлуулагч. Жинхэнэ газрын зураг (google_maps_flutter,
/// flutter_map гэх мэт) холбох хүртэл замын шугам, байршлын тэмдэгтэй зурна.
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.showRoute = true, this.showPin = true});

  final bool showRoute;
  final bool showPin;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(showRoute: showRoute),
              ),
            ),
            if (showRoute) ...[
              Positioned(
                left: c.maxWidth * 0.72 - 14,
                top: c.maxHeight * 0.22 - 14,
                child: const _Marker(
                  icon: Icons.restaurant,
                  color: AppColors.orange,
                ),
              ),
              Positioned(
                left: c.maxWidth * 0.22 - 14,
                top: c.maxHeight * 0.72 - 14,
                child: const _Marker(
                  icon: Icons.home,
                  color: AppColors.primary,
                ),
              ),
            ],
            if (showPin && !showRoute)
              Align(
                alignment: const Alignment(0, -0.15),
                child: const Icon(
                  Icons.location_on,
                  size: 44,
                  color: AppColors.orange,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(icon, size: 14, color: Colors.white),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.showRoute});

  final bool showRoute;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.mapBackground,
    );

    final road = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    // Хотын гудамжууд (хийсвэр тор).
    for (var i = 1; i < 6; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x + 20, size.height), road);
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 16), road);
    }

    if (!showRoute) return;

    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.72)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.45,
        size.width * 0.72,
        size.height * 0.55,
        size.width * 0.72,
        size.height * 0.22,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.orange
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      oldDelegate.showRoute != showRoute;
}
