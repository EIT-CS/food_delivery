import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_cards.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import 'filter_dialog.dart';

/// Хоолны жагсаалт (Food - List). `?category=Бургер` гэж ангилал шүүнэ.
class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key, this.category});

  final String? category;

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  FoodFilter _filter = const FoodFilter(maxPrice: 100000, rating: 1);

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final foods = MockData.foods.where((f) {
      final okCategory =
          widget.category == null || f.category == widget.category;
      return okCategory &&
          f.price <= _filter.maxPrice &&
          f.rating >= _filter.rating;
    }).toList();

    final title = widget.category == null
        ? 'Алдартай хоолнууд'
        : 'Алдартай ${widget.category}';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  RoundIconButton.back(context),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  RoundIconButton(
                    icon: Icons.search,
                    background: AppColors.dark,
                    iconColor: Colors.white,
                    onPressed: () => context.push(Routes.search),
                  ),
                  const SizedBox(width: 8),
                  RoundIconButton(
                    icon: Icons.tune,
                    onPressed: () async {
                      final result =
                          await showFilterDialog(context, initial: _filter);
                      if (result != null) setState(() => _filter = result);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: foods.isEmpty
                  ? const Center(
                      child: Text(
                        'Тохирох хоол олдсонгүй',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: foods.length,
                      itemBuilder: (context, i) => FoodCard(food: foods[i]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: app.cartCount == 0
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => context.push(Routes.cart),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text('Сагс (${app.cartCount})'),
            ),
    );
  }
}
