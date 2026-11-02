import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';
import '../theme/app_colors.dart';

/// Буцах үйлдэл: өмнөх хуудас байвал pop, үгүй бол нүүр рүү.
void goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(Routes.home);
  }
}

/// Дугуй дүрстэй товч (буцах, дуртай, хайлт гэх мэт).
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.background = AppColors.field,
    this.iconColor = AppColors.textPrimary,
    this.size = 40,
    this.badge,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color background;
  final Color iconColor;
  final double size;
  final int? badge;

  /// Буцах товч.
  factory RoundIconButton.back(
    BuildContext context, {
    Color background = AppColors.field,
    Color iconColor = AppColors.textPrimary,
  }) {
    return RoundIconButton(
      icon: Icons.arrow_back_ios_new,
      background: background,
      iconColor: iconColor,
      onPressed: () => goBack(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: background,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, size: size * 0.45, color: iconColor),
            ),
          ),
        ),
        if (badge != null && badge! > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Дээд талдаа харанхуй толгойтой, доор нь бөөрөнхий цагаан хэсэгтэй хуудас
/// (Нэвтрэх, Бүртгүүлэх, Нууц үг сэргээх, Баталгаажуулалт).
class DarkHeaderScaffold extends StatelessWidget {
  const DarkHeaderScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
    this.headerHeight = 190,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Column(
        children: [
          SizedBox(
            height: headerHeight,
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  if (showBack)
                    Positioned(
                      left: 20,
                      top: 12,
                      child: RoundIconButton.back(
                        context,
                        background: Colors.white.withValues(alpha: 0.12),
                        iconColor: Colors.white,
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Хуудасны дээд мөр: буцах + гарчиг + (нэмэлт) баруун талын widget.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.trailing,
    this.dark = false,
    this.showBack = true,
  });

  final String title;
  final Widget? trailing;
  final bool dark;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : AppColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          if (showBack)
            RoundIconButton.back(
              context,
              background:
                  dark ? Colors.white.withValues(alpha: 0.12) : AppColors.field,
              iconColor: color,
            )
          else
            const SizedBox(width: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: trailing == null
                ? null
                : Align(alignment: Alignment.centerRight, child: trailing),
          ),
        ],
      ),
    );
  }
}

/// "Бүх категори ... Бүгдийг харах" гэх мэт хэсгийн гарчиг.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Од + үнэлгээ.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Хүргэлтийн хугацаа (цагны дүрстэй).
class TimeBadge extends StatelessWidget {
  const TimeBadge({super.key, required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(
          '$minutes мин',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Сонгох боломжтой chip (ангилал, хэмжээ гэх мэт).
class SelectChip extends StatelessWidget {
  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor = AppColors.lime,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? selectedColor : AppColors.field,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// ( − 1 + ) тоо ширхэг сонгогч.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.dark = true,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark ? AppColors.dark : AppColors.field;
    final fg = dark ? Colors.white : AppColors.textPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(icon: Icons.remove, color: fg, onTap: onMinus),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          _StepBtn(icon: Icons.add, color: fg, onTap: onPlus),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn(
      {required this.icon, required this.color, required this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 16,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

/// Жижиг дугуй "+" товч (хоолны карт дээр).
class AddCircleButton extends StatelessWidget {
  const AddCircleButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.lime,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, size: 18, color: Colors.white),
      ),
    );
  }
}
