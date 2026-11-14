import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 5 одтой үнэлгээ. [onChanged] өгвөл товшиж сонгох боломжтой болно.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    this.size = 18,
    this.onChanged,
  });

  /// 0–5 (бутархай утга зөвхөн харуулахад).
  final double value;
  final double size;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onChanged == null ? null : () => onChanged!(i),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: onChanged == null ? 0 : 3),
              child: Icon(
                value >= i
                    ? Icons.star_rounded
                    : value >= i - 0.5
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded,
                size: size,
                color: value >= i - 0.5 ? AppColors.star : AppColors.border,
              ),
            ),
          ),
      ],
    );
  }
}
