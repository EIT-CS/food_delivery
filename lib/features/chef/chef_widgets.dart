import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';

/// Тогоочийн хуудсуудын арын өнгө.
const Color chefBg = Color(0xFFF3F4F6);

enum ChefTab { dashboard, foods, notifications, menu }

/// Chef-ийн бүх хуудсанд нийтлэг: саарал дэвсгэр, SafeArea, (сонголтоор) доод цэс.
class ChefScaffold extends StatelessWidget {
  const ChefScaffold({super.key, required this.body, this.tab});

  final Widget body;

  /// Өгвөл доод цэс гарч, тухайн таб идэвхтэй болно.
  final ChefTab? tab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chefBg,
      body: SafeArea(bottom: tab == null, child: body),
      bottomNavigationBar: tab == null ? null : ChefBottomBar(current: tab!),
    );
  }
}

/// Хөвөгч цагаан доод цэс: Dashboard, Хоол, (+), Мэдэгдэл, Профайл.
class ChefBottomBar extends StatelessWidget {
  const ChefBottomBar({super.key, required this.current});

  final ChefTab current;

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, ChefTab tab, String route) {
      final active = current == tab;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(route),
          child: SizedBox(
            height: 56,
            child: Icon(
              icon,
              size: 24,
              color: active ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              item(Icons.grid_view_rounded, ChefTab.dashboard, Routes.chefHome),
              item(Icons.format_list_bulleted, ChefTab.foods, Routes.chefFoods),
              GestureDetector(
                onTap: () => context.push(Routes.chefAddFood),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEDEA),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE9A99F)),
                  ),
                  child: const Icon(
                    Icons.add_box_outlined,
                    color: Color(0xFFE5604F),
                  ),
                ),
              ),
              item(
                Icons.notifications_none,
                ChefTab.notifications,
                Routes.chefNotifications,
              ),
              item(Icons.person_outline, ChefTab.menu, Routes.chefMenu),
            ],
          ),
        ),
      ),
    );
  }
}

/// Буцах товч + гарчиг + (сонголтоор) баруун талын үйлдэл.
class ChefHeader extends StatelessWidget {
  const ChefHeader({super.key, required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => chefBack(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Өмнөх хуудас байвал pop, үгүй бол Chef Dashboard руу.
void chefBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(Routes.chefHome);
  }
}

/// Цагаан, дугуй булантай карт.
class ChefCard extends StatelessWidget {
  const ChefCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Дугуй орцны дүрс (сонгогдсон бол ногоон).
class IngredientBubble extends StatelessWidget {
  const IngredientBubble({
    super.key,
    required this.name,
    required this.icon,
    this.selected = true,
    this.onTap,
  });

  final String name;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE7F3D2) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.lime : AppColors.border,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
