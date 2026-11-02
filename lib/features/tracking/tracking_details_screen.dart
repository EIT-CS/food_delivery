import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import 'map_placeholder.dart';

/// Захиалга хянах — 2-р төлөв: ETA, шат дараалал, хүргэгч (залгах/чат).
class TrackingDetailsScreen extends StatelessWidget {
  const TrackingDetailsScreen({super.key});

  static const _steps = [
    ('Захиалга хүлээн авагдлаа', true),
    ('Ресторан хоолыг бэлтгэж байна', true),
    ('Хүргэгч хоолыг авч явж байна', false),
    ('Таны хаягт хүрсэн', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: MapPlaceholder(showRoute: true),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: RoundIconButton.back(
                      context,
                      background: AppColors.dark,
                      iconColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            '20 МИН',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'ОЙРОЛЦООГООР ХҮРЭХ ХУГАЦАА',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < _steps.length; i++)
                      _StepRow(
                        label: _steps[i].$1,
                        done: _steps[i].$2,
                        last: i == _steps.length - 1,
                      ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.field,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Avatar(radius: 24, icon: Icons.delivery_dining),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Robert F.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Таны хүргэгч',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RoundIconButton(
                            icon: Icons.call,
                            background: AppColors.orange,
                            iconColor: Colors.white,
                            onPressed: () => context.push(Routes.deliveryCall),
                          ),
                          const SizedBox(width: 10),
                          RoundIconButton(
                            icon: Icons.chat_bubble_outline,
                            background: AppColors.orange,
                            iconColor: Colors.white,
                            onPressed: () => context.push(Routes.deliveryChat),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        FoodImage(
                          icon: Icons.coffee,
                          color: Color(0xFF9C7A5B),
                          size: 48,
                          radius: 10,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Утгэр Кофе Хаус',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '2× Бургер · 1× Сэндвич',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go(Routes.home),
                      child: const Text('Нүүр хуудас руу буцах'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.done,
    required this.last,
  });

  final String label;
  final bool done;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.orange : AppColors.border;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: done ? color : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                ),
                if (!last) Expanded(child: Container(width: 2, color: color)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                  color: done ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
