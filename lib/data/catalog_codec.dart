import 'package:flutter/material.dart';

import 'models.dart';

/// Хоол, рестораныг Firestore-ын Map болон буцааж хөрвүүлнэ.
///
/// `IconData`-г Firestore-д хадгалах боломжгүй тул нэрээр (`restaurant`,
/// `local_pizza` гэх мэт) хадгалж, доорх жагсаалтаас буцааж олно.
class CatalogCodec {
  CatalogCodec._();

  static const Map<String, IconData> icons = {
    'restaurant': Icons.restaurant,
    'restaurant_menu': Icons.restaurant_menu,
    'local_pizza': Icons.local_pizza,
    'lunch_dining': Icons.lunch_dining,
    'ramen_dining': Icons.ramen_dining,
    'dinner_dining': Icons.dinner_dining,
    'fastfood': Icons.fastfood,
    'eco': Icons.eco,
    'cake': Icons.cake,
    'cookie': Icons.cookie,
    'local_drink': Icons.local_drink,
    'coffee': Icons.coffee,
    'local_fire_department': Icons.local_fire_department,
    'bakery_dining': Icons.bakery_dining,
    'icecream': Icons.icecream,
    'set_meal': Icons.set_meal,
  };

  static String iconName(IconData icon) {
    for (final e in icons.entries) {
      if (e.value == icon) return e.key;
    }
    return 'restaurant';
  }

  static IconData iconOf(Object? name) =>
      icons[name] ?? Icons.restaurant;

  static int _colorValue(Color c) => c.toARGB32();

  // ------------------------------------------------------------------ Food
  static Map<String, dynamic> foodToMap(
    Food f, {
    List<String>? ingredients,
  }) =>
      {
        'name': f.name,
        'restaurantId': f.restaurantId,
        'category': f.category,
        'price': f.price,
        'rating': f.rating,
        'minutes': f.minutes,
        'icon': iconName(f.icon),
        'color': _colorValue(f.color),
        'description': f.description,
        'image': f.image,
        'tags': [for (final t in f.tags) t.name],
        'meal': f.meal,
        if (ingredients != null) 'ingredients': ingredients,
      };

  /// Баримт эвдэрсэн (талбар дутуу) бол null буцааж алгасна.
  static Food? foodFromMap(String id, Map<String, dynamic> m) {
    try {
      final tagMap = Taste.values.asNameMap();
      return Food(
        id: id,
        name: m['name'] as String,
        restaurantId: m['restaurantId'] as String,
        category: m['category'] as String? ?? 'Бусад',
        price: (m['price'] as num).toInt(),
        rating: (m['rating'] as num?)?.toDouble() ?? 4.5,
        minutes: (m['minutes'] as num?)?.toInt() ?? 20,
        icon: iconOf(m['icon']),
        color: Color((m['color'] as num?)?.toInt() ?? 0xFFE59A4B),
        description: m['description'] as String? ?? '',
        image: m['image'] as String?,
        tags: [
          for (final t in (m['tags'] as List? ?? const []))
            if (tagMap[t] != null) tagMap[t]!,
        ],
        meal: m['meal'] as String? ?? 'Өдөр',
      );
    } catch (_) {
      return null;
    }
  }

  static List<String> ingredientsFromMap(Map<String, dynamic> m) =>
      [for (final e in (m['ingredients'] as List? ?? const [])) e.toString()];

  // ------------------------------------------------------------ Restaurant
  static Map<String, dynamic> restaurantToMap(Restaurant r) => {
        'name': r.name,
        'cuisine': r.cuisine,
        'rating': r.rating,
        'minutes': r.minutes,
        'icon': iconName(r.icon),
        'color': _colorValue(r.color),
        'image': r.image,
        if (r.lat != null) 'lat': r.lat,
        if (r.lng != null) 'lng': r.lng,
      };

  static Restaurant? restaurantFromMap(String id, Map<String, dynamic> m) {
    try {
      return Restaurant(
        id: id,
        name: m['name'] as String,
        cuisine: m['cuisine'] as String? ?? '',
        rating: (m['rating'] as num?)?.toDouble() ?? 4.5,
        minutes: (m['minutes'] as num?)?.toInt() ?? 20,
        icon: iconOf(m['icon']),
        color: Color((m['color'] as num?)?.toInt() ?? 0xFFE9A96B),
        image: m['image'] as String?,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
