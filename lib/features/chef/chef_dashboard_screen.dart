import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/food_image.dart';
import '../../data/chef_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import 'chef_widgets.dart';

/// Seller Dashboard Home: захиалгын тоо, орлогын график, сэтгэгдэл, алдартай хоол.
class ChefDashboardScreen extends StatefulWidget {
  const ChefDashboardScreen({super.key});

  @override
  State<ChefDashboardScreen> createState() => _ChefDashboardScreenState();
}

class _ChefDashboardScreenState extends State<ChefDashboardScreen> {
  String _period = 'Өдөр';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final series = ChefData.revenue[_period]!;
    final reviews = app.chefReviews;
    final popular = [...app.chefFoods]
      ..sort((a, b) => app.ratingOf(b).compareTo(app.ratingOf(a)));

    return ChefScaffold(
      tab: ChefTab.dashboard,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          // Толгой: цэс, байршил, профайл
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go(Routes.chefMenu),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_rounded, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'БАЙРШИЛ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            app.currentAddress.label,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go(Routes.chefMenu),
                child: const Avatar(radius: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Захиалгын тоо
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '${app.chefOrders.length}'.padLeft(2, '0'),
                  label: 'ИДЭВХТЭЙ ЗАХИАЛГА',
                  onTap: () => context.push(Routes.chefOrders),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: '${app.newChefOrderCount}'.padLeft(2, '0'),
                  label: 'ШИНЭ ЗАХИАЛГА',
                  onTap: () => context.push(Routes.chefOrders),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Орлого + график
          ChefCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Нийт орлого',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      initialValue: _period,
                      onSelected: (v) => setState(() => _period = v),
                      itemBuilder: (_) => [
                        for (final p in ChefData.revenue.keys)
                          PopupMenuItem(value: p, child: Text(p)),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _period,
                              style: const TextStyle(fontSize: 11),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => context.go(Routes.chefMenu),
                      child: const Text(
                        'Дэлгэрэнгүй',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  formatPrice(app.chefRevenue),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                RevenueChart(key: ValueKey(_period), series: series),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Сэтгэгдэл
          ChefCard(
            onTap: () => context.push(Routes.chefReviews),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Сэтгэгдэл',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Text(
                      'Бүх сэтгэгдлийг харах',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.star, size: 26),
                    const SizedBox(width: 6),
                    Text(
                      app.chefRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Нийт ${reviews.length} сэтгэгдэл',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Алдартай хоол
          ChefCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Энэ долоо хоногийн алдартай хоол',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(Routes.chefFoods),
                      child: const Text(
                        'Бүгдийг харах',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: popular.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final f = popular[i];
                      return GestureDetector(
                        onTap: () => context.push(Routes.chefFoodPath(f.id)),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FoodImage(
                                icon: f.icon,
                                color: f.color,
                                imageAsset: f.image,
                                width: 130,
                                height: 100,
                                radius: 14,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                f.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                formatPrice(f.price),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.onTap});

  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChefCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Орлогын шугаман график. Дарж эсвэл чирж цэг сонгоход тайлбар (tooltip) гарна.
class RevenueChart extends StatefulWidget {
  const RevenueChart({super.key, required this.series});

  final RevenueSeries series;

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  late int _selected = widget.series.values.length ~/ 2;

  void _pick(double dx, double width) {
    final n = widget.series.values.length;
    final step = width / (n - 1);
    final i = (dx / step).round().clamp(0, n - 1);
    if (i != _selected) setState(() => _selected = i);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.series;
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, c) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _pick(d.localPosition.dx, c.maxWidth),
            onHorizontalDragUpdate: (d) => _pick(d.localPosition.dx, c.maxWidth),
            child: SizedBox(
              height: 130,
              width: double.infinity,
              child: CustomPaint(
                painter: _ChartPainter(values: s.values, selected: _selected),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final l in s.labels)
              Text(
                l,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.values, required this.selected});

  final List<int> values;
  final int selected;

  static const _orange = Color(0xFFFF7A45);

  @override
  void paint(Canvas canvas, Size size) {
    const topPad = 34.0; // tooltip-д зай
    const bottomPad = 6.0;
    final n = values.length;
    final minV = values.reduce((a, b) => a < b ? a : b).toDouble();
    final maxV = values.reduce((a, b) => a > b ? a : b).toDouble();
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);

    final pts = <Offset>[
      for (var i = 0; i < n; i++)
        Offset(
          size.width * i / (n - 1),
          topPad +
              (size.height - topPad - bottomPad) *
                  (1 - (values[i] - minV) / range),
        ),
    ];

    // Жигд муруй
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < n - 1; i++) {
      final mid = (pts[i].dx + pts[i + 1].dx) / 2;
      line.cubicTo(mid, pts[i].dy, mid, pts[i + 1].dy, pts[i + 1].dx, pts[i + 1].dy);
    }

    // Доод талын градиент дүүргэлт
    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_orange.withValues(alpha: 0.22), _orange.withValues(alpha: 0.0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    // Сонгосон цэг: босоо тасархай шугам, цэг, tooltip
    final p = pts[selected];
    final dash = Paint()
      ..color = _orange.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (var y = p.dy; y < size.height; y += 6) {
      canvas.drawLine(Offset(p.dx, y), Offset(p.dx, y + 3), dash);
    }
    canvas.drawCircle(p, 6, Paint()..color = Colors.white);
    canvas.drawCircle(
      p,
      6,
      Paint()
        ..color = _orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: formatPrice(values[selected]),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final w = tp.width + 16;
    final left = (p.dx - w / 2).clamp(0.0, size.width - w);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, p.dy - 34, w, 22),
      const Radius.circular(7),
    );
    canvas.drawRRect(rect, Paint()..color = AppColors.dark);
    tp.paint(canvas, Offset(left + 8, p.dy - 34 + (22 - tp.height) / 2));
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.selected != selected || old.values != values;
}
