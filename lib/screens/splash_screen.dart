
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _firstController;
  late AnimationController _secondController;

  late Animation<Offset> _deliverySlide;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  bool _showSecond = false;

  @override
  void initState() {
    super.initState();

    // Эхний дэлгэцийн animation
    _firstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Хүргэлтийн ажилтан зүүнээс орж ирнэ
    _deliverySlide = Tween<Offset>(
      begin: const Offset(-1.8, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _firstController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Лого аажмаар тодорно
    _logoFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _firstController,
        curve: const Interval(
          0.3,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Хоёр дахь дэлгэцийн animation
    _secondController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _secondController,
        curve: Curves.elasticOut,
      ),
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    // Splash 01 animation
    await _firstController.forward();

    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

    // Splash 02 руу шилжих
    setState(() {
      _showSecond = true;
    });

    await _secondController.forward();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _showSecond
              ? _buildSecondSplash()
              : _buildFirstSplash(),
        ),
      ),
    );
  }

  // SPLASH SCREEN 01
  Widget _buildFirstSplash() {
    final size = MediaQuery.sizeOf(context);

    return SizedBox.expand(
      key: const ValueKey('splash1'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _deliverySlide,
            child: Image.asset(
              'assets/images/delivery.png',
              width: size.width * 0.55,
              height: size.height * 0.25,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),

          FadeTransition(
            opacity: _logoFade,
            child: _buildLogo(size.width),
          ),
        ],
      ),
    );
  }

  // SPLASH SCREEN 02
  Widget _buildSecondSplash() {
    final size = MediaQuery.sizeOf(context);

    return SizedBox.expand(
      key: const ValueKey('splash2'),
      child: Stack(
        children: [
          // Дээд талын цагаан цацраг
          Positioned(
            top: -95,
            left: -95,
            child: Opacity(
              opacity: 0.13,
              child: _buildDecoration(
                color: const Color(0xFF8BC34A),
                dimension: 240,
              ),
            ),
          ),

          // Голын Food лого
          Center(
            child: ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _secondController,
                child: _buildLogo(size.width),
              ),
            ),
          ),

          // Доод баруун ногоон цацраг
          Positioned(
            bottom: -90,
            right: -90,
            child: RotationTransition(
              turns: Tween<double>(
                begin: -0.08,
                end: 0,
              ).animate(_secondController),
              child: _buildDecoration(
                color: const Color(0xFF548B45),
                dimension: size.width * 0.68,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FOOD LOGO + УРИА
  Widget _buildLogo(double screenWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: screenWidth * 0.32,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 7),

        const Text(
          'Амттай хоол, хурдан хүргэлт',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  Widget _buildDecoration({
    required Color color,
    required double dimension,
  }) {
    return SizedBox(
      width: dimension,
      height: dimension,
      child: CustomPaint(
        painter: RayPainter(color: color),
      ),
    );
  }
}

// Ногоон цацраг зурах
class RayPainter extends CustomPainter {
  final Color color;

  RayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2;

    for (int i = 0; i < 36; i++) {
      final angle = (i * 10) * math.pi / 180;

      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RayPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
