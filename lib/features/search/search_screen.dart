import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_cards.dart';
import '../../core/widgets/food_image.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../foods/filter_dialog.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final q = _query.trim().toLowerCase();

    final foods = q.isEmpty
        ? <Food>[]
        : MockData.foods
            .where((f) =>
                f.name.toLowerCase().contains(q) ||
                f.category.toLowerCase().contains(q))
            .toList();
    final restaurants = MockData.restaurants
        .where((r) =>
            q.isEmpty ||
            r.name.toLowerCase().contains(q) ||
            r.cuisine.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: 'Хайлт',
              trailing: RoundIconButton(
                icon: Icons.shopping_bag_outlined,
                background: AppColors.dark,
                iconColor: Colors.white,
                badge: app.cartCount,
                onPressed: () => context.push(Routes.cart),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                controller: _controller,
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Хоол, ресторан хайх...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, size: 20),
                    onPressed: () => showFilterDialog(context),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  if (q.isEmpty) ...[
                    const SectionHeader(title: 'Сүүлд хайсан'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final s in MockData.recentSearches)
                          SelectChip(
                            label: s,
                            selected: false,
                            onTap: () => _setQuery(s),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                  ],
                  SectionHeader(
                    title: q.isEmpty
                        ? 'Санал болгох рестораанууд'
                        : 'Рестораны үр дүн (${restaurants.length})',
                  ),
                  const SizedBox(height: 12),
                  if (restaurants.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Ресторан олдсонгүй',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  for (final r in restaurants) _RestaurantTile(restaurant: r),
                  const SizedBox(height: 18),
                  SectionHeader(
                    title: q.isEmpty
                        ? 'Алдартай хоолнууд'
                        : 'Хоолны үр дүн (${foods.length})',
                    actionLabel: q.isEmpty ? 'Бүгдийг харах' : null,
                    onAction: () => context.push(Routes.foods),
                  ),
                  const SizedBox(height: 12),
                  if (q.isNotEmpty && foods.isEmpty)
                    const Text(
                      'Хоол олдсонгүй',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                      children: [
                        for (final f in (q.isEmpty
                            ? MockData.foods.take(4).toList()
                            : foods))
                          FoodCard(food: f),
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

class _RestaurantTile extends StatelessWidget {
  const _RestaurantTile({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.restaurantPath(restaurant.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            FoodImage(
              icon: restaurant.icon,
              color: restaurant.color,
              size: 56,
              radius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBadge(rating: restaurant.rating),
                      const SizedBox(width: 12),
                      TimeBadge(minutes: restaurant.minutes),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
