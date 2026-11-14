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
import '../top_foods/top_foods_screen.dart' show RankBadge;
import 'offer_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// Урамшууллын цонхыг аппыг ажиллуулахад нэг л удаа үзүүлнэ.
  static bool _offerShown = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (!HomeScreen._offerShown) {
      HomeScreen._offerShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showOfferDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final popular = MockData.allFoods.take(6).toList();

    return Scaffold(
      bottomNavigationBar: const _BottomBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // Дээд мөр: профайл + хаяг + сагс
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.push(Routes.menu),
                  child: const Avatar(radius: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push(Routes.addresses),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ХҮРГЭХ ХАЯГ',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.orange,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                app.currentAddress.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                        Text(
                          app.currentAddress.text,
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
                ),
                const SizedBox(width: 12),
                RoundIconButton(
                  icon: Icons.shopping_bag_outlined,
                  background: AppColors.dark,
                  iconColor: Colors.white,
                  badge: app.cartCount,
                  onPressed: () => context.push(Routes.cart),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Сайн байна уу, ${app.profile.name}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            const Text(
              'Өнөөдөр юу идмээр байна?',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            // Хайлтын талбар (товшоход хайлтын хуудас руу)
            GestureDetector(
              onTap: () => context.push(Routes.search),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search,
                        color: AppColors.textSecondary, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Хоол, ресторан хайх...',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            SectionHeader(
              title: 'Бүх категори',
              actionLabel: 'Бүгдийг харах',
              onAction: () => context.push(Routes.foods),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final c = MockData.categories[i];
                  return GestureDetector(
                    onTap: () => context.push(
                      Routes.foodsPath(category: i == 0 ? null : c.name),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: i == 0 ? AppColors.lime : AppColors.field,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            c.icon,
                            size: 18,
                            color: i == 0 ? Colors.white : AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            c.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  i == 0 ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const _TasteSection(),
            SectionHeader(
              title: 'Алдартай хоолнууд',
              actionLabel: 'Бүгдийг харах',
              onAction: () => context.push(Routes.foods),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 245,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: popular.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) =>
                    FoodCard(food: popular[i], width: 160),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'ТОП хоолнууд',
              actionLabel: 'Бүгдийг харах',
              onAction: () => context.push(Routes.topFoods),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < 3; i++)
              _TopTile(rank: i + 1, food: app.topFoods[i]),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Нээлттэй рестораанууд',
              actionLabel: 'Бүгдийг харах',
              onAction: () => context.push(Routes.search),
            ),
            const SizedBox(height: 12),
            for (final r in MockData.restaurants) ...[
              RestaurantCard(restaurant: r),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              const _BarItem(
                icon: Icons.home_filled,
                label: 'Нүүр',
                selected: true,
              ),
              _BarItem(
                icon: Icons.receipt_long_outlined,
                label: 'Захиалга',
                onTap: () => context.push(Routes.orders),
              ),
              _BarItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Сагс',
                badge: app.cartCount,
                onTap: () => context.push(Routes.cart),
              ),
              _BarItem(
                icon: Icons.person_outline,
                label: 'Профайл',
                onTap: () => context.push(Routes.menu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (badge != null && badge! > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Танд тохирох хоол": амт сонгосон бол санал болгоно, үгүй бол сонгохыг урина.
class _TasteSection extends StatelessWidget {
  const _TasteSection();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    if (!app.hasTastes) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: GestureDetector(
          onTap: () => context.push(Routes.taste),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3D2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.restaurant_menu, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Амтаа сонгоорой',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Танд тохирсон хоолыг санал болгоно',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.primary),
              ],
            ),
          ),
        ),
      );
    }

    final foods = app.recommended.take(6).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Танд тохирох хоол',
            actionLabel: 'Өөрчлөх',
            onAction: () => context.push(Routes.taste),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: [
              for (final t in app.tastes)
                Chip(
                  avatar: Icon(t.icon, size: 14, color: AppColors.primary),
                  label: Text(t.label, style: const TextStyle(fontSize: 11)),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFFE7F3D2),
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 245,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) =>
                  FoodCard(food: foods[i], width: 160),
            ),
          ),
        ],
      ),
    );
  }
}

/// ТОП жагсаалтын мөр (нүүрэнд эхний 3).
class _TopTile extends StatelessWidget {
  const _TopTile({required this.rank, required this.food});

  final int rank;
  final Food food;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final restaurant = MockData.restaurantById(food.restaurantId);
    return InkWell(
      onTap: () => context.push(Routes.foodPath(food.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            RankBadge(rank: rank),
            const SizedBox(width: 12),
            FoodImage(
              icon: food.icon,
              color: food.color,
              imageAsset: food.image,
              size: 52,
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
                      fontSize: 13,
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
                ],
              ),
            ),
            RatingBadge(rating: app.ratingOf(food)),
          ],
        ),
      ),
    );
  }
}
