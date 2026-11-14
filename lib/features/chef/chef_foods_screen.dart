import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/food_image.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import 'chef_widgets.dart';

/// My Food: тогоочийн хоолны жагсаалт (Бүгд / Өглөө / Өдөр / Орой).
class ChefFoodsScreen extends StatelessWidget {
  const ChefFoodsScreen({super.key});

  static const _tabs = ['Бүгд', 'Өглөө', 'Өдөр', 'Орой'];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final all = app.chefFoods;

    return DefaultTabController(
      length: _tabs.length,
      child: ChefScaffold(
        tab: ChefTab.foods,
        body: Column(
          children: [
            const ChefHeader(title: 'Миний хоолны жагсаалт'),
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
                tabs: [for (final t in _tabs) Tab(text: t)],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (final t in _tabs)
                    _FoodList(
                      foods: t == 'Бүгд'
                          ? all
                          : all.where((f) => f.meal == t).toList(),
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

class _FoodList extends StatelessWidget {
  const _FoodList({required this.foods});

  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      children: [
        Text(
          'Нийт ${foods.length.toString().padLeft(2, '0')} хоол',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        if (foods.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                'Энэ цагт хоол алга.\nДоорх (+) товчоор нэмнэ үү.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ),
        for (final f in foods) ...[
          _FoodTile(food: f),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FoodTile extends StatelessWidget {
  const _FoodTile({required this.food});

  final Food food;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final count = app.reviewCountOf(food);

    return ChefCard(
      padding: const EdgeInsets.all(10),
      onTap: () => context.push(Routes.chefFoodPath(food.id)),
      child: Row(
        children: [
          FoodImage(
            icon: food.icon,
            color: food.color,
            imageAsset: food.image,
            size: 76,
            radius: 14,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_horiz, size: 18),
                      onSelected: (v) {
                        if (v == 'details') {
                          context.push(Routes.chefFoodPath(food.id));
                        } else {
                          context.push(Routes.foodPath(food.id));
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'details', child: Text('Дэлгэрэнгүй')),
                        PopupMenuItem(
                          value: 'customer',
                          child: Text('Хэрэглэгчид харагдах байдал'),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3D2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    food.meal,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatPrice(food.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                    const SizedBox(width: 2),
                    Text(
                      app.ratingOf(food).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$count сэтгэгдэл',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Очиж авах',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
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
