import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/food_image.dart';
import '../../data/chef_data.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import 'chef_widgets.dart';

/// Chef Food Details: тогоочийн хоолны дэлгэрэнгүй.
class ChefFoodDetailsScreen extends StatelessWidget {
  const ChefFoodDetailsScreen({super.key, required this.foodId});

  final String foodId;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final Food food = MockData.foodById(foodId);
    final restaurant = MockData.restaurantById(food.restaurantId);
    final names = app.ingredientsOf(food.id);
    final all = [...ChefData.mainIngredients, ...ChefData.extraIngredients];
    final ingredients = [
      for (final n in names)
        all.firstWhere(
          (i) => i.name == n,
          orElse: () => Ingredient(n, Icons.restaurant),
        ),
    ];

    return ChefScaffold(
      tab: ChefTab.foods,
      body: Column(
        children: [
          ChefHeader(
            title: 'Хоолны дэлгэрэнгүй',
            actionLabel: 'ЗАСАХ',
            onAction: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Засах боломж удахгүй нэмэгдэнэ')),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              children: [
                Stack(
                  children: [
                    FoodImage(
                      icon: food.icon,
                      color: food.color,
                      imageAsset: food.image,
                      width: double.infinity,
                      height: 220,
                      radius: 22,
                    ),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      child: _Chip(label: food.meal),
                    ),
                    const Positioned(
                      right: 14,
                      bottom: 12,
                      child: _Chip(label: 'Хүргэлт'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      formatPrice(food.price),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        restaurant.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(Icons.star_rounded, size: 15, color: AppColors.star),
                    const SizedBox(width: 2),
                    Text(
                      app.ratingOf(food).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => context.push(Routes.chefReviews),
                      child: Text(
                        '${app.reviewCountOf(food)} сэтгэгдэл',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'ОРЦЫН ЖАГСААЛТ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: [
                    for (final i in ingredients)
                      IngredientBubble(name: i.name, icon: i.icon),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'ДЭЛГЭРЭНГҮЙ ТАЙЛБАР',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  food.description,
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
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
