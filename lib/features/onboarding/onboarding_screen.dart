import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';

class _OnboardPage {
  const _OnboardPage(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

/// 4 хуудастай onboarding (PageView). Сүүлийн хуудсанд "ЭХЛЭХ" → Нэвтрэх.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = [
    _OnboardPage(
      Icons.phone_iphone,
      'Таны дуртай бүх хоол',
      'Дуртай хоолоо апп дотроос хайж, хэдхэн товшилтоор захиалаарай. Сонголт олон, үнэ хямд.',
    ),
    _OnboardPage(
      Icons.restaurant,
      'Амт бүрийг дэргэдээ',
      'Ойр орчмын шилдэг ресторанууд таны сонголтыг шинэхэн бэлтгэн хүргэнэ.',
    ),
    _OnboardPage(
      Icons.soup_kitchen,
      'Шилдэг тогооч нар',
      'Туршлагатай тогооч нарын гараар бэлтгэсэн амттай хоолыг амт, чанартай нь таашаан идээрэй.',
    ),
    _OnboardPage(
      Icons.delivery_dining,
      'Үнэгүй хүргэлт',
      'Тодорхой дүнгээс дээш захиалгад хүргэлт үнэгүй. Хоол чинь халуунаараа ирнэ.',
    ),
  ];

  final _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  void _next() {
    if (_isLast) {
      context.go(Routes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 220,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF4DA),
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(p.icon, size: 110, color: AppColors.primary),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.lime : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: AppButton(
                label: _isLast ? 'ЭХЛЭХ' : 'ДАРАХ',
                onPressed: _next,
              ),
            ),
            SizedBox(
              height: 44,
              child: _isLast
                  ? null
                  : TextButton(
                      onPressed: () => context.go(Routes.login),
                      child: const Text(
                        'АЛГАСАХ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
