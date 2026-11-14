import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import 'review_tile.dart';

/// Сэтгэгдлийн жагсаалт.
///  - [foodId] өгвөл тухайн хоолны бүх сэтгэгдэл + одны хуваарилалт.
///  - өгөөгүй бол хэрэглэгчийн өөрийн бичсэн сэтгэгдлүүд.
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, this.foodId});

  final String? foodId;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final food = foodId == null ? null : MockData.foodById(foodId!);
    final reviews = food == null ? app.myReviews : app.reviewsFor(food.id);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(title: food == null ? 'Миний сэтгэгдэл' : 'Сэтгэгдлүүд'),
            Expanded(
              child: reviews.isEmpty
                  ? _Empty(isMine: food == null)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: reviews.length + (food == null ? 0 : 1),
                      separatorBuilder: (_, __) => const Divider(height: 28),
                      itemBuilder: (context, i) {
                        if (food != null && i == 0) {
                          return _Summary(food: food, reviews: reviews);
                        }
                        final r = reviews[food == null ? i : i - 1];
                        return ReviewTile(
                          review: r,
                          foodName: food == null
                              ? MockData.foodById(r.foodId).name
                              : null,
                        );
                      },
                    ),
            ),
            if (food != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: AppButton(
                  label: 'СЭТГЭГДЭЛ БИЧИХ',
                  icon: Icons.edit_outlined,
                  onPressed: () =>
                      context.push(Routes.writeReviewPath(food.id)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.food, required this.reviews});

  final Food food;
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final avg = AppScope.of(context).ratingOf(food);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              avg.toStringAsFixed(1),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
            StarRating(value: avg, size: 16),
            const SizedBox(height: 4),
            Text(
              '${reviews.length} үнэлгээ',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              for (var star = 5; star >= 1; star--)
                _Bar(
                  star: star,
                  fraction:
                      reviews.where((r) => r.rating == star).length /
                          reviews.length,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.star, required this.fraction});

  final int star;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$star',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.field,
                color: AppColors.star,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.isMine});

  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.rate_review_outlined,
              size: 56,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              isMine
                  ? 'Та одоогоор сэтгэгдэл бичээгүй байна.\nЗахиалгын түүхээс хоолоо үнэлээрэй.'
                  : 'Энэ хоолонд сэтгэгдэл алга.\nАнхны сэтгэгдлийг та бичээрэй!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
