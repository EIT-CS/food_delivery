import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/food_image.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/models.dart';

/// Нэг сэтгэгдлийн мөр: аватар, нэр, од, текст, зураг.
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review, this.foodName});

  final Review review;

  /// Өгвөл (миний сэтгэгдэл жагсаалтад) аль хоолонд бичсэнийг харуулна.
  final String? foodName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Avatar(radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.mine ? '${review.author} (Та)' : review.author,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    review.date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            StarRating(value: review.rating.toDouble(), size: 16),
          ],
        ),
        if (foodName != null) ...[
          const SizedBox(height: 8),
          Text(
            foodName!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.orange,
            ),
          ),
        ],
        if (review.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            review.text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        if (review.photos > 0) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < review.photos; i++) ...[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.field,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
