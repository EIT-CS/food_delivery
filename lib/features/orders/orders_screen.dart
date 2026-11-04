import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

/// Миний захиалга: "Идэвхтэй" ба "Түүх" табтай.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ongoing =
        MockData.orders.where((o) => o.status == OrderStatus.ongoing).toList();
    final history =
        MockData.orders.where((o) => o.status != OrderStatus.ongoing).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const PageHeader(title: 'Миний захиалга'),
              const TabBar(
                labelColor: AppColors.orange,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.orange,
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
                tabs: [
                  Tab(text: 'Идэвхтэй захиалга'),
                  Tab(text: 'Түүх'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _OrderList(orders: ongoing),
                    _OrderList(orders: history),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Захиалга байхгүй байна',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (context, i) => _OrderTile(order: orders[i]),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final ongoing = order.status == OrderStatus.ongoing;
    final cancelled = order.status == OrderStatus.cancelled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              order.restaurant,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              ongoing
                  ? 'ИДЭВХТЭЙ'
                  : cancelled
                      ? 'ЦУЦЛАГДСАН'
                      : 'ДУУССАН',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: ongoing
                    ? AppColors.orange
                    : cancelled
                        ? AppColors.danger
                        : AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            FoodImage(
              icon: order.icon,
              color: order.color,
              size: 56,
              radius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${formatPrice(order.total)} · ${order.itemsCount} бүтээгдэхүүн',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.date}  ·  ${order.id}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallButton(
                label: ongoing ? 'ХЯНАХ' : 'ДАХИН ЗАХИАЛАХ',
                filled: true,
                onTap: () {
                  if (ongoing) {
                    context.push(Routes.tracking);
                  } else {
                    context.push(Routes.foods);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SmallButton(
                label: ongoing ? 'ЦУЦЛАХ' : 'ҮНЭЛЭХ',
                filled: false,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ongoing
                            ? 'Захиалга ${order.id} цуцлах хүсэлт илгээгдлээ'
                            : 'Үнэлгээ өгсөнд баярлалаа!',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: filled
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.orange,
                side: const BorderSide(color: AppColors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
    );
  }
}
