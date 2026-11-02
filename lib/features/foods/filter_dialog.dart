import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';

/// Шүүлтүүрийн сонголт.
class FoodFilter {
  const FoodFilter({
    this.offer = 'Хүргэлт',
    this.time = '15-30 мин',
    this.maxPrice = 50000,
    this.rating = 4,
  });

  final String offer;
  final String time;
  final int maxPrice;
  final int rating;
}

/// Шүүлтүүр (Filter) цонх. "ХУУЛЖ" дарвал сонгосон утгыг буцаана.
Future<FoodFilter?> showFilterDialog(
  BuildContext context, {
  FoodFilter initial = const FoodFilter(),
}) {
  return showDialog<FoodFilter>(
    context: context,
    builder: (dialogContext) {
      var offer = initial.offer;
      var time = initial.time;
      var price = initial.maxPrice.toDouble();
      var rating = initial.rating;

      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Шүүлтүүр',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _Label('ЗАХИАЛГЫН ТӨРӨЛ'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final o in ['Хүргэлт', 'Очиж авах', 'Урамшуулал'])
                        SelectChip(
                          label: o,
                          selected: offer == o,
                          onTap: () => setState(() => offer = o),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _Label('ХҮРГЭЛТИЙН ХУГАЦАА'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in ['10-15 мин', '15-30 мин', '30-45 мин'])
                        SelectChip(
                          label: t,
                          selected: time == t,
                          onTap: () => setState(() => time = t),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Label('ҮНЭ  (хамгийн ихдээ ${price.round()}₮)'),
                  Slider(
                    value: price,
                    min: 5000,
                    max: 100000,
                    divisions: 19,
                    activeColor: AppColors.lime,
                    onChanged: (v) => setState(() => price = v),
                  ),
                  const _Label('ҮНЭЛГЭЭ'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () => setState(() => rating = i),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.star_rounded,
                              size: 30,
                              color: i <= rating
                                  ? AppColors.orange
                                  : AppColors.border,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'ХУУЛЖ',
                    onPressed: () => Navigator.of(dialogContext).pop(
                      FoodFilter(
                        offer: offer,
                        time: time,
                        maxPrice: price.round(),
                        rating: rating,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textSecondary,
      ),
    );
  }
}
