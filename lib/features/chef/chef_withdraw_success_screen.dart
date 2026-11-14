import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';

/// Payment Withdraw Success: мөнгө амжилттай татагдсан.
class ChefWithdrawSuccessScreen extends StatelessWidget {
  const ChefWithdrawSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: 180,
                height: 140,
                child: CustomPaint(
                  painter: _SparklePainter(),
                  child: Center(
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2BBE5B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 44),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Мөнгө амжилттай татагдлаа!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              AppButton(
                label: 'ОЙЛГОЛОО',
                onPressed: () => context.go(Routes.chefMenu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Дугуйн эргэн тойрны жижиг одод, цэгүүд.
class _SparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final green = Paint()..color = const Color(0xFF2BBE5B).withValues(alpha: 0.55);
    final soft = Paint()..color = AppColors.lime.withValues(alpha: 0.35);

    void star(Offset c, double r, Paint p) {
      final path = Path()
        ..moveTo(c.dx, c.dy - r)
        ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
        ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
        ..close();
      canvas.drawPath(path, p);
    }

    star(Offset(size.width * 0.2, size.height * 0.15), 9, green);
    star(Offset(size.width * 0.85, size.height * 0.05), 7, green);
    star(Offset(size.width * 0.92, size.height * 0.72), 6, green);
    canvas.drawCircle(Offset(size.width * 0.08, size.height * 0.62), 3, soft);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.3), 4, soft);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.85), 2.5, soft);
  }

  @override
  bool shouldRepaint(_SparklePainter old) => false;
}
