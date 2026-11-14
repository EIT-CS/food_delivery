import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';

/// "Танд ямар хоол таалагддаг вэ?" — амтаа сонгоход нүүрэнд тохирох хоол гарна.
/// Бүртгүүлсний дараа болон цэснээс нээгдэнэ.
class TasteScreen extends StatefulWidget {
  const TasteScreen({super.key});

  @override
  State<TasteScreen> createState() => _TasteScreenState();
}

class _TasteScreenState extends State<TasteScreen> {
  static const _hints = {
    Taste.spicy: 'Халуун, амттай ногоотой хоол',
    Taste.healthy: 'Шинэхэн, хөнгөн, эрүүл',
    Taste.cheap: '24,000₮ хүртэлх үнэтэй',
    Taste.fast: '15 минутанд хүргэнэ',
  };

  late Set<Taste> _selected;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _selected = {...AppScope.of(context).tastes};
    }
  }

  void _toHome() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  void _save() {
    AppScope.of(context).setTastes(_selected);
    _toHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _toHome,
                  child: const Text('Алгасах'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Танд ямар хоол\nтаалагддаг вэ?',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Хэд хэдийг сонгож болно. Бид танд тохирсон хоолыг нүүр хуудсанд санал болгоно.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                  children: [
                    for (final t in Taste.values)
                      _TasteTile(
                        taste: t,
                        hint: _hints[t]!,
                        selected: _selected.contains(t),
                        onTap: () => setState(() {
                          if (!_selected.remove(t)) _selected.add(t);
                        }),
                      ),
                  ],
                ),
              ),
              AppButton(
                label: _selected.isEmpty ? 'ХАДГАЛАХ' : 'ХАДГАЛАХ (${_selected.length})',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TasteTile extends StatelessWidget {
  const _TasteTile({
    required this.taste,
    required this.hint,
    required this.selected,
    required this.onTap,
  });

  final Taste taste;
  final String hint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.field,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.18)
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    taste.icon,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                ),
                const Spacer(),
                if (selected)
                  const Icon(Icons.check_circle, color: Colors.white),
              ],
            ),
            const Spacer(),
            Text(
              taste.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              style: TextStyle(
                fontSize: 11,
                height: 1.3,
                color: selected
                    ? Colors.white.withValues(alpha: 0.85)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
