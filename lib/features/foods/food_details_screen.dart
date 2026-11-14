import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../reviews/review_tile.dart';

/// Хоолны дэлгэрэнгүй (Food Details): хэмжээ, тоо ширхэг, сагсанд нэмэх.
class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key, required this.foodId});

  final String foodId;

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  static const _sizes = [10, 14, 16];
  int _size = 14;
  int _quantity = 1;

  // Хэмжээнээс хамаарсан үнийн коэффициент.
  double get _sizeFactor => switch (_size) {
        10 => 0.8,
        16 => 1.25,
        _ => 1.0,
      };

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final Food food = MockData.foodById(widget.foodId);
    final reviews = app.reviewsFor(food.id);
    final foodTastes = Taste.values.where(food.matches).toList();
    final restaurant = MockData.restaurantById(food.restaurantId);
    final unitPrice = (food.price * _sizeFactor).round();
    final showSizes = food.category == 'Пицца' || food.category == 'Бургер';

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              FoodImage(
                icon: food.icon,
                color: food.color,
                imageAsset: food.image,
                width: double.infinity,
                height: 330,
                radius: 0,
                iconSize: 175,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      RoundIconButton.back(context, background: Colors.white),
                      const Spacer(),
                      RoundIconButton(
                        icon: app.isFavoriteFood(food.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        background: Colors.white,
                        iconColor: app.isFavoriteFood(food.id)
                            ? AppColors.danger
                            : AppColors.textPrimary,
                        onPressed: () => app.toggleFavoriteFood(food.id),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () =>
                          context.push(Routes.restaurantPath(restaurant.id)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.storefront_outlined,
                            size: 16,
                            color: AppColors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        RatingBadge(rating: app.ratingOf(food)),
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
                        TimeBadge(minutes: food.minutes),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      food.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (foodTastes.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in foodTastes)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                // Хэрэглэгчийн сонгосон амт бол ногооноор тодруулна.
                                color: app.tastes.contains(t)
                                    ? const Color(0xFFE7F3D2)
                                    : AppColors.field,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    t.icon,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    t.label,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (showSizes) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Text(
                            'ХЭМЖЭЭ:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          for (final s in _sizes) ...[
                            GestureDetector(
                              onTap: () => setState(() => _size = s),
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _size == s
                                      ? AppColors.lime
                                      : AppColors.field,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$s"',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _size == s
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    SectionHeader(
                      title: 'Сэтгэгдэл (${reviews.length})',
                      actionLabel: 'Бүгдийг харах',
                      onAction: () =>
                          context.push(Routes.foodReviewsPath(food.id)),
                    ),
                    const SizedBox(height: 12),
                    if (reviews.isEmpty)
                      const Text(
                        'Одоогоор сэтгэгдэл алга.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      for (final r in reviews.take(2)) ...[
                        ReviewTile(review: r),
                        const SizedBox(height: 16),
                      ],
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        formatPrice(unitPrice * _quantity),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      QuantityStepper(
                        value: _quantity,
                        onMinus: () => setState(() {
                          if (_quantity > 1) _quantity--;
                        }),
                        onPlus: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'САГСАНД НЭМЭХ',
                    onPressed: () {
                      AppScope.of(context).addToCart(
                        food,
                        size: _size,
                        quantity: _quantity,
                      );
                      context.push(Routes.cart);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
