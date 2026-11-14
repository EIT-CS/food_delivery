import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';

const _couponCode = '#1243CD2';

/// "Онцгой урамшуулал" купон цонх (Figma: Offer).
///
/// "АВЧ АШИГЛАХ" дарахад купон код clipboard руу хуулагдаж, хоолны жагсаалт
/// руу шилжинэ.
Future<void> showOfferDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    // Figma-ийн цэнхэрдүү саарал дэвсгэр
    barrierColor: const Color(0xBF566782),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8DC63F), Color(0xFF2E4D2A)],
                ),
              ),
              child: Stack(
                children: [
                  // Чимэглэл (текстийн ард)
                  const Positioned.fill(
                    child: CustomPaint(painter: _ConfettiPainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 54, 22, 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Онцгой\nУрамшуулал!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          _couponCode,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Энэ купоныг ашиглаад 25%\nхөнгөлөлт аваарай.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.28),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              final messenger = ScaffoldMessenger.of(context);
                              Clipboard.setData(
                                const ClipboardData(text: _couponCode),
                              );
                              Navigator.of(dialogContext).pop();
                              messenger
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Купон $_couponCode хуулагдлаа',
                                    ),
                                  ),
                                );
                              context.push(Routes.foods);
                            },
                            child: const Text(
                              'АВЧ АШИГЛАХ',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Хаах товч: баруун дээд буланд, картын хүрээнээс бага зэрэг гарсан
          Positioned(
            right: -6,
            top: -10,
            child: GestureDetector(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.dark,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Алтлаг гурвалжин, мушгиа зураас (confetti).
class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void triangle(double fx, double fy, double s, double rot, Color color) {
      canvas.save();
      canvas.translate(w * fx, h * fy);
      canvas.rotate(rot);
      final path = Path()
        ..moveTo(0, -s)
        ..lineTo(s * 0.9, s * 0.7)
        ..lineTo(-s * 0.9, s * 0.7)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
      canvas.restore();
    }

    const gold = Color(0xFFE9D44A);
    const light = Color(0xFFF6E97A);

    triangle(0.17, 0.13, 17, -0.45, light);
    triangle(0.40, 0.07, 9, 0.2, gold);
    triangle(0.70, 0.17, 15, 0.9, gold);
    triangle(0.16, 0.39, 10, -1.0, light);
    triangle(0.52, 0.42, 7, 2.4, gold);

    // Баруун талын мушгиа зураас
    final squiggle = Path();
    final x = w * 0.93;
    final y0 = h * 0.34;
    squiggle.moveTo(x, y0);
    for (var i = 1; i <= 4; i++) {
      squiggle.lineTo(x + (i.isOdd ? 5 : -5), y0 + i * 9);
    }
    canvas.drawPath(
      squiggle,
      Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => false;
}