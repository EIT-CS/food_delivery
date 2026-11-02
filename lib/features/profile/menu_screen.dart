import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../state/app_state.dart';

/// Хувийн мэдээлэл ба тохиргооны цэс (Menu).
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = AppScope.of(context).profile;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Хувийн мэдээлэл'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      const Avatar(radius: 38),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.bio,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Group(
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        color: AppColors.orange,
                        label: 'Хувийн мэдээлэл',
                        onTap: () => context.push(Routes.profile),
                      ),
                      _MenuItem(
                        icon: Icons.map_outlined,
                        color: Colors.blue,
                        label: 'Хаяг',
                        onTap: () => context.push(Routes.addresses),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _Group(
                    items: [
                      _MenuItem(
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.blue,
                        label: 'Сагс',
                        onTap: () => context.push(Routes.cart),
                      ),
                      _MenuItem(
                        icon: Icons.favorite_border,
                        color: Colors.pink,
                        label: 'Дуртай хоол',
                        onTap: () => context.push(Routes.foods),
                      ),
                      _MenuItem(
                        icon: Icons.receipt_long_outlined,
                        color: Colors.deepOrange,
                        label: 'Миний захиалга',
                        onTap: () => context.push(Routes.orders),
                      ),
                      _MenuItem(
                        icon: Icons.credit_card,
                        color: Colors.indigo,
                        label: 'Төлбөрийн арга',
                        onTap: () => context.push(Routes.payment),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _Group(
                    items: [
                      _MenuItem(
                        icon: Icons.help_outline,
                        color: Colors.teal,
                        label: 'Түгээмэл асуулт',
                        onTap: () => _soon(context),
                      ),
                      _MenuItem(
                        icon: Icons.star_outline,
                        color: Colors.amber,
                        label: 'Хэрэглэгчийн сэтгэгдэл',
                        onTap: () => _soon(context),
                      ),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        color: Colors.deepPurple,
                        label: 'Тохиргоо',
                        onTap: () => _soon(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _Group(
                    items: [
                      _MenuItem(
                        icon: Icons.logout,
                        color: AppColors.danger,
                        label: 'Гарах',
                        onTap: () => context.go(Routes.login),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Удахгүй нэмэгдэнэ')),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: items),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 18,
        color: AppColors.textSecondary,
      ),
    );
  }
}
