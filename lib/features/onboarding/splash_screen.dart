import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';

class SplashScreen extends StatefulWidget {
  final bool second;

  const SplashScreen({
    super.key,
    this.second = false,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;

  late final AnimationController _scooterController;
  late final AnimationController _logoController;
  late final AnimationController _decorationController;

  late final Animation<Offset> _scooterAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: widget.second ? 1 : 0,
    );

    // Мотоциклийн animation
    _scooterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Логоны animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Чимэглэлийн animation
    _decorationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Мотоцикл зүүн талаас орж ирнэ
    _scooterAnimation = Tween<Offset>(
      begin: const Offset(-1.8, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _scooterController,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        startAnimation();
      }
    });
  }

  // =====================================
  // АВТОМАТААР ДЭЛГЭЦ ШИЛЖҮҮЛЭХ
  // =====================================

  Future<void> startAnimation() async {
    if (!widget.second) {
      _scooterController.forward();
      _logoController.forward();

      await Future.delayed(
        const Duration(milliseconds: 2500),
      );

      if (!mounted) return;
      if (!_pageController.hasClients) return;

      // Splash 02 руу шилжих
      _decorationController.forward();

      await _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 1100),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _logoController.forward();
      _decorationController.forward();
    }

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    // Onboarding руу шилжих
    context.go(Routes.onboarding);
  }

  // =====================================
  // FOOD ОРИГИНАЛ ЛОГО
  // =====================================

  Widget buildLogo(double scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Food логоны зураг
        Image.asset(
          'assets/images/splash_2.png',
          width: 135 * scale,
          fit: BoxFit.contain,
        ),

        SizedBox(height: 10 * scale),

        // Уриа
        Text(
          'Амттай хоол, хурдан хүргэлт',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12 * scale,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF929292),
          ),
        ),
      ],
    );
  }

  // =====================================
  // SPLASH PAGE 01
  // =====================================

  Widget buildFirstPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 390;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Хүргэлтийн мотоцикл
              SlideTransition(
                position: _scooterAnimation,
                child: FadeTransition(
                  opacity: _scooterController,
                  child: Image.asset(
                    'assets/images/splash_1.png',
                    width: 185 * scale,
                    height: 185 * scale,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: 28 * scale),

              // Food лого
              FadeTransition(
                opacity: _logoController,
                child: buildLogo(scale),
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================
  // SPLASH PAGE 02
  // =====================================

  Widget buildSecondPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 390;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Зүүн дээд булангийн цайвар хээ
            Positioned(
              top: 0,
              left: 0,
              child: RotatedBox(
                quarterTurns: 2,
                child: CustomPaint(
                  size: Size(
                    185 * scale,
                    110 * scale,
                  ),
                  painter: FanPainter(
                    light: true,
                  ),
                ),
              ),
            ),

            // Баруун доод булангийн ногоон хээ
            Positioned(
              bottom: 0,
              right: 0,
              child: FadeTransition(
                opacity: _decorationController,
                child: CustomPaint(
                  size: Size(
                    225 * scale,
                    260 * scale,
                  ),
                  painter: FanPainter(),
                ),
              ),
            ),

            // Дэлгэцийн төвд байрлах лого
            Center(
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.8,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: _decorationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: FadeTransition(
                  opacity: _decorationController,
                  child: buildLogo(scale),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =====================================
  // ҮНДСЭН ДЭЛГЭЦ
  // =====================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness:
            Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,

          // Автоматаар шилжих учраас swipe хийхгүй
          physics: const NeverScrollableScrollPhysics(),

          children: [
            buildFirstPage(),
            buildSecondPage(),
          ],
        ),
      ),
    );
  }

  // =====================================
  // CONTROLLER ЧӨЛӨӨЛӨХ
  // =====================================

  @override
  void dispose() {
    _pageController.dispose();
    _scooterController.dispose();
    _logoController.dispose();
    _decorationController.dispose();

    super.dispose();
  }
}

// =======================================
// БУЛАНГИЙН НОГООН ХЭЭ
// =======================================

class FanPainter extends CustomPainter {
  final bool light;

  FanPainter({
    this.light = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(
      size.width,
      size.height,
    );

    const int lines = 28;

    for (int i = 0; i < lines; i++) {
      final ratio = i / (lines - 1);

      final angle =
          math.pi + ratio * math.pi / 2;

      final paint = Paint()
        ..color = light
            ? const Color(0xFFF0F2EF)
            : Color.lerp(
                const Color(0xFF345F3D),
                const Color(0xFF98BD59),
                ratio,
              )!
        ..strokeWidth = size.width * 0.018
        ..style = PaintingStyle.stroke;

      final end = Offset(
        origin.dx + math.cos(angle) * size.width,
        origin.dy + math.sin(angle) * size.height,
      );

      final path = Path()
        ..moveTo(
          origin.dx,
          origin.dy,
        )
        ..quadraticBezierTo(
          origin.dx - size.width * 0.13 * (1 - ratio),
          origin.dy - size.height * 0.05,
          end.dx,
          end.dy,
        );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FanPainter oldDelegate) {
    return oldDelegate.light != light;
  }
}