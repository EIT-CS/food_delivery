import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';

/// Хэрэглэгчдийн үнэлгээгээр эрэмбэлсэн хамгийн амттай хоол, ресторанууд.
class TopFoodsScreen extends StatelessWidget {
  const TopFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final foods = app.topFoods;
    final restaurants = app.topRestaurants;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const PageHeader(title: 'ТОП жагсаалт'),
              const TabBar(
                labelColor: AppColors.orange,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.orange,
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
                tabs: [Tab(text: 'Хоол'), Tab(text: 'Ресторан')],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: foods.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, i) => _FoodRow(
                        rank: i + 1,
                        food: foods[i],
                      ),
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: restaurants.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, i) => _RestaurantRow(
                        rank: i + 1,
                        restaurant: restaurants[i],
                      ),
                    ),
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

/// 1–3 нь алт, мөнгө, хүрэл өнгөтэй.
class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final color = switch (rank) {
      1 => const Color(0xFFF2B600),
      2 => const Color(0xFFA7B0BC),
      3 => const Color(0xFFC98B4E),
      _ => AppColors.field,
    };
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        '$rank',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: rank <= 3 ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({required this.rank, required this.food});

  final int rank;
  final Food food;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final restaurant = MockData.restaurantById(food.restaurantId);
    final count = app.reviewCountOf(food);

    return InkWell(
      onTap: () => context.push(Routes.foodPath(food.id)),
      child: Row(
        children: [
          RankBadge(rank: rank),
          const SizedBox(width: 12),
          FoodImage(
            icon: food.icon,
            color: food.color,
            imageAsset: food.image,
            size: 60,
            radius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    RatingBadge(rating: app.ratingOf(food)),
                    const SizedBox(width: 6),
                    Text(
                      '($count үнэлгээ)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            formatPrice(food.price),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantRow extends StatelessWidget {
  const _RestaurantRow({required this.rank, required this.restaurant});

  final int rank;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final count = app.reviewCountOfRestaurant(restaurant);

    return InkWell(
      onTap: () => context.push(Routes.restaurantPath(restaurant.id)),
      child: Row(
        children: [
          RankBadge(rank: rank),
          const SizedBox(width: 12),
          FoodImage(
            icon: restaurant.icon,
            color: restaurant.color,
            imageAsset: restaurant.image,
            size: 60,
            radius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  restaurant.cuisine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    RatingBadge(rating: app.ratingOfRestaurant(restaurant)),
                    const SizedBox(width: 6),
                    Text(
                      '($count үнэлгээ)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
