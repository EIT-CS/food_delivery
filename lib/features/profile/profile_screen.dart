
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../state/app_state.dart';

/// Хувийн мэдээлэл харах (Personal Info)
/// "ЗАСАХ" товч дарвал Edit Profile рүү шилжинэ.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = AppScope.of(context).profile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Дээд хэсэг
            PageHeader(
              title: 'Хувийн мэдээлэл',
              trailing: GestureDetector(
                onTap: () => context.push(Routes.profileEdit),
                child: const Center(
                  child: Text(
                    'ЗАСАХ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  // Профайлын зураг болон нэр
                  Row(
                    children: [
                      const Avatar(radius: 45),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              profile.bio,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Хувийн мэдээллийн карт
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.person_outline,
                          iconColor: AppColors.orange,
                          label: 'БҮТЭН НЭР',
                          value: profile.name,
                        ),

                        const SizedBox(height: 22),

                        _InfoRow(
                          icon: Icons.mail_outline,
                          iconColor: const Color(0xFF8B7CF6),
                          label: 'И-МЭЙЛ',
                          value: profile.email,
                        ),

                        const SizedBox(height: 22),

                        _InfoRow(
                          icon: Icons.phone_outlined,
                          iconColor: const Color(0xFF48B5F5),
                          label: 'УТАСНЫ ДУГААР',
                          value: profile.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Хувийн мэдээллийн нэг мөр
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: 19,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
