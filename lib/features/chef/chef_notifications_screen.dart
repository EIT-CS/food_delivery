import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/food_image.dart';
import '../../data/chef_data.dart';
import '../../data/mock_data.dart';
import 'chef_widgets.dart';

/// Notification + Massages: нэг дэлгэц, 2 таб (Мэдэгдлүүд / Зурвасууд).
/// `?tab=messages` гэж нээвэл Зурвасууд таб идэвхтэй эхэлнэ.
class ChefNotificationsScreen extends StatelessWidget {
  const ChefNotificationsScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    final unread = ChefData.messages.fold<int>(0, (s, m) => s + m.unread);

    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: ChefScaffold(
        tab: ChefTab.notifications,
        body: Column(
          children: [
            const ChefHeader(title: 'Мэдэгдэл'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  const Tab(text: 'Мэдэгдлүүд'),
                  Tab(text: 'Зурвасууд ($unread)'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(children: [_Notifications(), _Messages()]),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notifications extends StatelessWidget {
  const _Notifications();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      itemCount: ChefData.notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 20),
      itemBuilder: (context, i) {
        final n = ChefData.notifications[i];
        final food = MockData.foodById(n.foodId);
        return InkWell(
          onTap: () => context.push(Routes.chefOrders),
          child: Row(
            children: [
              const Avatar(radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: n.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                            text: ' ${n.text}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      n.time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FoodImage(
                icon: food.icon,
                color: food.color,
                imageAsset: food.image,
                size: 46,
                radius: 12,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      itemCount: ChefData.messages.length,
      separatorBuilder: (_, __) => const Divider(height: 20),
      itemBuilder: (context, i) {
        final m = ChefData.messages[i];
        return InkWell(
          // Жишиг чат дэлгэц (хүргэгчтэй чат) нээгдэнэ.
          onTap: () => context.push(Routes.deliveryChat),
          child: Row(
            children: [
              Stack(
                children: [
                  const Avatar(radius: 22),
                  if (m.online)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2BBE5B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    m.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (m.unread > 0)
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${m.unread}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
