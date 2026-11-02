import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../router/routes.dart';
import '../theme/app_colors.dart';
import 'common_widgets.dart';
import 'food_image.dart';

/// Хоолны жижиг карт (2 баганат grid, хэвтээ жагсаалтад).
class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food, this.width});

  final Food food;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final restaurant = MockData.restaurantById(food.restaurantId);
    return GestureDetector(
      onTap: () => context.push(Routes.foodPath(food.id)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.25,
              child: FoodImage(
                icon: food.icon,
                color: food.color,
                radius: 10,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              food.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatPrice(food.price),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                AddCircleButton(
                  onTap: () {
                    AppScope.of(context).addToCart(food);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('"${food.name}" сагсанд нэмэгдлээ'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'САГС',
                            onPressed: () => context.push(Routes.cart),
                          ),
                        ),
                      );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Рестораны том карт (нүүр, хайлт хуудас).
class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.restaurantPath(restaurant.id)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoodImage(
              icon: restaurant.icon,
              color: restaurant.color,
              width: double.infinity,
              height: 130,
              radius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBadge(rating: restaurant.rating),
                      const SizedBox(width: 14),
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
                      const SizedBox(width: 14),
                      TimeBadge(minutes: restaurant.minutes),
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
}
