import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';

/// Захиалсан хоолондоо 1–5 од өгч, сэтгэгдэл бичих, зураг хавсаргах.
///
/// Зураг хавсаргах хэсэг одоогоор жишиг (placeholder). Жинхэнэ зураг сонгохдоо
/// `image_picker` багц нэмж, `_photos` жагсаалтыг файлын замаар солино.
class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.foodId});

  final String foodId;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  static const _maxPhotos = 3;
  static const _labels = {
    1: 'Муу байлаа',
    2: 'Дунд зэрэг',
    3: 'Боломжийн',
    4: 'Сайн байлаа',
    5: 'Гайхалтай амттай!',
  };

  final _controller = TextEditingController();
  int _rating = 0;
  int _photos = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final app = AppScope.of(context);
    app.addReview(
      foodId: widget.foodId,
      rating: _rating,
      text: _controller.text,
      photos: _photos,
    );
    goBack(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Үнэлгээ өгсөнд баярлалаа!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = MockData.foodById(widget.foodId);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Үнэлгээ өгөх'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  Row(
                    children: [
                      FoodImage(
                        icon: food.icon,
                        color: food.color,
                        size: 64,
                        radius: 14,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          food.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Center(
                    child: Text(
                      'Хоол ямар байсан бэ?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: StarRating(
                      value: _rating.toDouble(),
                      size: 40,
                      onChanged: (v) => setState(() => _rating = v),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      _labels[_rating] ?? 'Од дарж үнэлнэ үү',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _rating == 0
                            ? AppColors.textSecondary
                            : AppColors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'СЭТГЭГДЭЛ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    maxLength: 300,
                    decoration: const InputDecoration(
                      hintText: 'Амт, хүргэлт, порцын талаар бичнэ үү...',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'ЗУРАГ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 0; i < _photos; i++) ...[
                        _PhotoTile(
                          onRemove: () => setState(() => _photos--),
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (_photos < _maxPhotos)
                        GestureDetector(
                          onTap: () => setState(() => _photos++),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: AppButton(
                label: 'ИЛГЭЭХ',
                onPressed: _rating == 0 ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.photo, color: AppColors.textSecondary),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.dark,
              child: Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
