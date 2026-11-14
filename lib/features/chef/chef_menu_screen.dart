import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import 'chef_widgets.dart';

/// Menu (Миний профайл): боломжит үлдэгдэл, мөнгө татах, тохиргоо.
class ChefMenuScreen extends StatelessWidget {
  const ChefMenuScreen({super.key});

  void _withdraw(BuildContext context) {
    final app = AppScope.of(context);
    if (app.withdrawAll()) {
      context.push(Routes.chefWithdrawSuccess);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Татах боломжтой үлдэгдэл алга')),
      );
    }
  }

  void _history(BuildContext context) {
    final list = AppScope.of(context).withdrawals;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Мөнгө таталтын түүх',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (list.isEmpty)
              const Text(
                'Одоогоор мөнгө татаагүй байна.',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              for (final w in list)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.south_west, color: AppColors.primary),
                  title: Text(formatPrice(w.amount)),
                  subtitle: Text(w.date),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      backgroundColor: chefBg,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Ногоон толгой
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 8,
                16,
                24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Row(
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
                      const Text(
                        'Миний профайл',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Боломжит үлдэгдэл',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(app.chefBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => _withdraw(context),
                    child: const Text(
                      'МӨНГӨ ТАТАХ',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _Group(children: [
                    _Row(
                      icon: Icons.person_outline,
                      color: const Color(0xFFFF7A45),
                      label: 'Хувийн мэдээлэл',
                      onTap: () => context.push(Routes.profileEdit),
                    ),
                    _Row(
                      icon: Icons.settings_outlined,
                      color: const Color(0xFF5B5BD6),
                      label: 'Тохиргоо',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Тохиргоо удахгүй нэмэгдэнэ')),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Group(children: [
                    _Row(
                      icon: Icons.account_balance_wallet_outlined,
                      color: const Color(0xFFE08A3C),
                      label: 'Мөнгө таталтын түүх',
                      onTap: () => _history(context),
                    ),
                    _Row(
                      icon: Icons.receipt_long_outlined,
                      color: const Color(0xFF2BA5C7),
                      label: 'Захиалгын тоо',
                      trailing: '29K',
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Group(children: [
                    _Row(
                      icon: Icons.bubble_chart_outlined,
                      color: const Color(0xFF1FB5C6),
                      label: 'Хэрэглэгчийн сэтгэгдэл',
                      onTap: () => context.push(Routes.chefReviews),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Group(children: [
                    _Row(
                      icon: Icons.logout,
                      color: AppColors.danger,
                      label: 'Гарах',
                      onTap: () => context.go(Routes.login),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 13)),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              )
            else
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
