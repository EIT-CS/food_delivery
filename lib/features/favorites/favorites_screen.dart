import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_cards.dart';
import '../../state/app_state.dart';

/// Дуртай хоол, рестораны жагсаалт (зүрхэн товчоор хадгалсан).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final foods = app.favoriteFoods;
    final restaurants = app.favoriteRestaurants;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const PageHeader(title: 'Дуртай'),
              TabBar(
                labelColor: AppColors.orange,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.orange,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                tabs: [
                  Tab(text: 'Хоол (${foods.length})'),
                  Tab(text: 'Ресторан (${restaurants.length})'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    foods.isEmpty
                        ? const _Empty(
                            text: 'Дуртай хоол алга.\nХоолны зураг дээрх ♡ дарж хадгална уу.',
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: foods.length,
                            itemBuilder: (context, i) =>
                                FoodCard(food: foods[i]),
                          ),
                    restaurants.isEmpty
                        ? const _Empty(
                            text: 'Дуртай ресторан алга.\nРестораны зураг дээрх ♡ дарж хадгална уу.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                            itemCount: restaurants.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, i) =>
                                RestaurantCard(restaurant: restaurants[i]),
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

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 56,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Хоол үзэх'),
            ),
          ],
        ),
      ),
    );
  }
}
