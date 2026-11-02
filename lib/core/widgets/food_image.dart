import 'package:flutter/material.dart';

/// Figma-ийн хоолны зургийн орыг түр орлох widget.
///
/// Жинхэнэ зургаа `assets/images/`-д хийсний дараа `imageAsset` өгвөл
/// автоматаар `Image.asset` болж солигдоно.
class FoodImage extends StatelessWidget {
  const FoodImage({
    super.key,
    required this.icon,
    required this.color,
    this.size,
    this.width,
    this.height,
    this.radius = 14,
    this.iconSize,
    this.imageAsset,
  });

  final IconData icon;
  final Color color;
  final double? size;
  final double? width;
  final double? height;
  final double radius;
  final double? iconSize;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final w = width ?? size;
    final h = height ?? size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: w,
        height: h,
        child: imageAsset != null
            ? Image.asset(imageAsset!, fit: BoxFit.cover)
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.55),
                      color,
                    ],
                  ),
                ),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final base = (w ?? c.maxWidth);
                      final bound = base.isFinite ? base : 120.0;
                      return Icon(
                        icon,
                        size: iconSize ?? (bound * 0.5).clamp(20.0, 110.0),
                        color: Colors.white.withValues(alpha: 0.92),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

/// Дугуй профайл зураг.
class Avatar extends StatelessWidget {
  const Avatar({super.key, this.radius = 28, this.icon = Icons.person});

  final double radius;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFFFD9A8),
      child: Icon(icon, size: radius * 1.1, color: const Color(0xFF8A5A2B)),
    );
  }
}
