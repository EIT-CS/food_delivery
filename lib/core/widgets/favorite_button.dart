import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../theme/app_colors.dart';

/// Зураг дээр байрлах жижиг зүрхэн товч (хоол эсвэл ресторан).
class FavoriteButton extends StatelessWidget {
  const FavoriteButton.food(this.id, {super.key, this.size = 30})
      : isRestaurant = false;
  const FavoriteButton.restaurant(this.id, {super.key, this.size = 30})
      : isRestaurant = true;

  final String id;
  final bool isRestaurant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final active = isRestaurant
        ? app.isFavoriteRestaurant(id)
        : app.isFavoriteFood(id);

    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          if (isRestaurant) {
            app.toggleFavoriteRestaurant(id);
          } else {
            app.toggleFavoriteFood(id);
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1400),
                content: Text(
                  active ? 'Дуртайгаас хаслаа' : 'Дуртай жагсаалтад нэмлээ',
                ),
              ),
            );
        },
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            active ? Icons.favorite : Icons.favorite_border,
            size: size * 0.55,
            color: active ? AppColors.danger : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
