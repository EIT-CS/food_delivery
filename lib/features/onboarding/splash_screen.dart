import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';

/// Splash 1 (хүргэгчтэй лого) → Splash 2 (брэнд лого) → Onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.second = false});

  /// false = Splash 1, true = Splash 2
  final bool second;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      context.go(widget.second ? Routes.onboarding : Routes.splash2);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.second) ...[
              const Icon(
                Icons.delivery_dining,
                size: 96,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
            ],
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
                children: [
                  TextSpan(text: 'F'),
                  TextSpan(
                    text: 'oo',
                    style: TextStyle(color: AppColors.lime),
                  ),
                  TextSpan(text: 'd'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Амттай хоол, хурдан хүргэлт',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
