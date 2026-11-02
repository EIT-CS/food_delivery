import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_cards.dart';
import '../../core/widgets/food_image.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';

/// Рестораны дэлгэрэнгүй: мэдээлэл + ангилал chip + хоолны grid.
class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  String _category = 'Бүгд';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final restaurant = MockData.restaurantById(widget.restaurantId);
    final all =
        MockData.foods.where((f) => f.restaurantId == restaurant.id).toList();
    final categories = [
      'Бүгд',
      ...{for (final f in all) f.category}
    ];
    final foods = _category == 'Бүгд'
        ? all
        : all.where((f) => f.category == _category).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                FoodImage(
                  icon: restaurant.icon,
                  color: restaurant.color,
                  width: double.infinity,
                  height: 240,
                  radius: 0,
                  iconSize: 120,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      children: [
                        RoundIconButton.back(context, background: Colors.white),
                        const Spacer(),
                        RoundIconButton(
                          icon: Icons.shopping_bag_outlined,
                          background: Colors.white,
                          badge: app.cartCount,
                          onPressed: () => context.push(Routes.cart),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingBadge(rating: restaurant.rating),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.delivery_dining,
                        size: 16,
                        color: AppColors.lime,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        'Үнэгүй',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      TimeBadge(minutes: restaurant.minutes),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => SelectChip(
                        label: categories[i],
                        selected: categories[i] == _category,
                        onTap: () => setState(() => _category = categories[i]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_category (${foods.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: foods.isEmpty
                ? const SliverToBoxAdapter(
                    child: Text(
                      'Хоол олдсонгүй',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => FoodCard(food: foods[i]),
                      childCount: foods.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
