import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

// Хулгана болон хуруугаар swipe хийх
class MouseSwipeBehavior extends MaterialScrollBehavior {
  const MouseSwipeBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  // Үндсэн өнгөнүүд
  static const Color darkGreen = Color(0xFF345F3D);
  static const Color lightGreen = Color(0xFFD1E4C6);
  static const Color titleColor = Color(0xFF202333);
  static const Color textColor = Color(0xFF9297AB);

  // =====================================
  // ONBOARDING МЭДЭЭЛЭЛ
  // =====================================

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/intro1.png',
      'title': 'Таны дуртай бүх хоол',
      'description':
          'Дуртай хоолнуудаа нэг дороос сонгож, '
          'хүссэн үедээ хялбархан захиалаарай.',
    },
    {
      'image': 'assets/images/intro2.png',
      'title': 'Амт бүрийг нэг дороос',
      'description':
          'Олон төрлийн амттай хоолноос '
          'өөрийн хүссэн хоолыг сонгон захиалаарай.',
    },
    {
      'image': 'assets/images/intro3.png',
      'title': 'Шилдэг тогоочид',
      'description':
          'Өөрийн дуртай тогоочоо сонгож, '
          'тэдний бэлтгэсэн амттай хоолыг захиалаарай.',
    },
    {
      'image': 'assets/images/intro4.png',
      'title': 'Үнэгүй хүргэлт',
      'description':
          'Үнэгүй хүргэлтийн урамшууллыг ашиглан '
          'дуртай хоолоо илүү хэмнэлттэй захиалаарай.',
    },
  ];

  // =====================================
  // ДАРААГИЙН ДЭЛГЭЦ
  // =====================================

  void nextPage() {
    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOutCubic,
      );
    } else {
      openNextScreen();
    }
  }

  // Алгасах товч
  void skipPages() {
    _pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubic,
    );
  }

  // Login дэлгэц рүү шилжих
  void openNextScreen() {
    context.go(Routes.login);
  }

  // =====================================
  // ДӨРВӨН ЦЭГЭН ИНДИКАТОР
  // =====================================

  Widget buildIndicator(int index) {
    final selected = currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: selected ? 9 : 7,
      height: selected ? 9 : 7,
      decoration: BoxDecoration(
        color: selected ? darkGreen : lightGreen,
        shape: BoxShape.circle,
      ),
    );
  }

  // =====================================
  // ONBOARDING ДИЗАЙН
  // =====================================

  Widget buildPage(int index) {
    final page = pages[index];
    final isLast = index == pages.length - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        final scale = width / 390;
        final compact = height < 650;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 26 * scale,
          ),
          child: Column(
            children: [
              // Дээд талын хоосон зай
              Spacer(flex: compact ? 1 : 2),

              // Танилцуулгын зураг
              Flexible(
                flex: 8,
                child: Center(
                  child: Image.asset(
                    page['image']!,
                    width: 255 * scale,
                    height: 310 * scale,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(
                height: compact ? 24 : 45 * scale,
              ),

              // Гарчиг
              Text(
                page['title']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24 * scale,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                  letterSpacing: -0.4,
                ),
              ),

              SizedBox(height: 18 * scale),

              // Тайлбар
              SizedBox(
                height: 76 * scale,
                width: double.infinity,
                child: Text(
                  page['description']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15 * scale,
                    height: 1.6,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              SizedBox(height: 15 * scale),

              // Дөрвөн цэг
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  buildIndicator,
                ),
              ),

              const Spacer(flex: 3),

              // ДАРААХ / ЭХЛЭХ товч
              SizedBox(
                width: double.infinity,
                height: 60 * scale,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLast ? 'ЭХЛЭХ' : 'ДАРААХ',
                    style: TextStyle(
                      fontSize: 15 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8 * scale),

              // АЛГАСАХ товч
              SizedBox(
                height: 44 * scale,
                child: isLast
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: skipPages,
                        child: Text(
                          'АЛГАСАХ',
                          style: TextStyle(
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w400,
                            color: textColor,
                          ),
                        ),
                      ),
              ),

              SizedBox(height: 16 * scale),
            ],
          ),
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
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const MouseSwipeBehavior(),
            child: PageView.builder(
              controller: _pageController,
              physics: const PageScrollPhysics(),
              itemCount: pages.length,

              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },

              itemBuilder: (context, index) {
                return buildPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}