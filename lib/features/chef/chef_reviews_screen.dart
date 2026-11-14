import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/food_image.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import 'chef_widgets.dart';

/// Review Screen: тогоочийн хоолнуудад хэрэглэгчдийн бичсэн сэтгэгдэл.
/// Хэрэглэгчийн талаас бичсэн сэтгэгдэл энд шууд гарна.
class ChefReviewsScreen extends StatelessWidget {
  const ChefReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = AppScope.of(context).chefReviews;

    return ChefScaffold(
      body: Column(
        children: [
          const ChefHeader(title: 'Хэрэглэгчийн сэтгэгдэл'),
          Expanded(
            child: reviews.isEmpty
                ? const Center(
                    child: Text(
                      'Сэтгэгдэл алга',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: reviews.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final r = reviews[i];
                      final food = MockData.foodById(r.foodId);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Avatar(radius: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${r.author} · ${r.date}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.more_horiz,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                StarRating(value: r.rating.toDouble(), size: 15),
                                const SizedBox(height: 8),
                                if (r.text.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      r.text,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        height: 1.45,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
