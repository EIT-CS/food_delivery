import 'package:flutter/material.dart';

/// Хоолны орц (Chef: Шинэ хоол нэмэх, Хоолны дэлгэрэнгүй).
class Ingredient {
  const Ingredient(this.name, this.icon);

  final String name;
  final IconData icon;
}

/// Тогоочид ирсэн идэвхтэй захиалга.
class ChefOrder {
  const ChefOrder({
    required this.id,
    required this.foodId,
    required this.price,
    required this.meal,
    this.isNew = false,
  });

  final String id;
  final String foodId;
  final int price;
  final String meal; // Өглөө / Өдөр / Орой
  final bool isNew;
}

class ChefNotification {
  const ChefNotification({
    required this.name,
    required this.text,
    required this.time,
    required this.foodId,
  });

  final String name;
  final String text;
  final String time;
  final String foodId;
}

class ChefMessage {
  const ChefMessage({
    required this.name,
    required this.preview,
    required this.time,
    this.unread = 0,
    this.online = false,
  });

  final String name;
  final String preview;
  final String time;
  final int unread;
  final bool online;
}

class Withdrawal {
  const Withdrawal({required this.amount, required this.date});

  final int amount;
  final String date;
}

/// Орлогын график: үе тус бүрийн цэгүүд ба x тэнхлэгийн шошго.
class RevenueSeries {
  const RevenueSeries(this.labels, this.values);

  final List<String> labels;
  final List<int> values;
}

/// Chef талын жишиг өгөгдөл.
class ChefData {
  ChefData._();

  static const List<String> meals = ['Өглөө', 'Өдөр', 'Орой'];

  static String mealTitle(String meal) => switch (meal) {
        'Өглөө' => 'Өглөөний хоол',
        'Өдөр' => 'Өдрийн хоол',
        _ => 'Оройн хоол',
      };

  static const List<Ingredient> mainIngredients = [
    Ingredient('Давс', Icons.grain),
    Ingredient('Татна', Icons.spa),
    Ingredient('Сонгино', Icons.lens),
    Ingredient('Сармис', Icons.eco),
    Ingredient('Перец', Icons.local_fire_department),
    Ingredient('Цагаан гаа', Icons.grass),
    Ingredient('Брокколи', Icons.park),
    Ingredient('Жүрж', Icons.bubble_chart),
  ];

  static const List<Ingredient> extraIngredients = [
    Ingredient('Авокадо', Icons.energy_savings_leaf),
    Ingredient('Алим', Icons.circle),
    Ingredient('Нэрс', Icons.bubble_chart),
    Ingredient('Самар', Icons.cookie),
    Ingredient('Жимс', Icons.nature),
    Ingredient('Ус', Icons.water_drop),
  ];

  static const List<ChefOrder> orders = [
    ChefOrder(id: '12053', foodId: 'f1', price: 30000, meal: 'Өглөө', isNew: true),
    ChefOrder(id: '15253', foodId: 'f2', price: 30000, meal: 'Өглөө', isNew: true),
    ChefOrder(id: '21200', foodId: 'f8', price: 30000, meal: 'Өдөр'),
    ChefOrder(id: '53241', foodId: 'f2', price: 30000, meal: 'Өдөр'),
    ChefOrder(id: '58464', foodId: 'f1', price: 30000, meal: 'Орой'),
    ChefOrder(id: '60112', foodId: 'f8', price: 30000, meal: 'Орой', isNew: true),
  ];

  static const List<ChefNotification> notifications = [
    ChefNotification(name: 'Тэмүүлэн', text: 'шинэ захиалга өглөө', time: '20 минутын өмнө', foodId: 'f1'),
    ChefNotification(name: 'Саруул', text: '5 одтой сэтгэгдэл үлдээлээ', time: '30 минутын өмнө', foodId: 'f2'),
    ChefNotification(name: 'Оюунаа', text: 'захиалгаа цуцлахыг хүслээ', time: '1 цагийн өмнө', foodId: 'f8'),
    ChefNotification(name: 'Бат-Эрдэнэ', text: 'шинэ захиалга өглөө', time: '2 цагийн өмнө', foodId: 'f1'),
  ];

  static const List<ChefMessage> messages = [
    ChefMessage(name: 'Тэмүүлэн', preview: 'Гоё амттай байна!', time: '09:27', unread: 1, online: true),
    ChefMessage(name: 'Саруул', preview: 'Хурдан ирээрэй, бага зэрэг бачимдаж байна', time: '09:27', unread: 2, online: true),
    ChefMessage(name: 'Ганаа', preview: 'Баярлалаа.', time: '09:27'),
    ChefMessage(name: 'Номин', preview: 'Яаж байна даа?', time: '09:27'),
    ChefMessage(name: 'Хулан', preview: 'Амттай хоолны төлөө баярлалаа.', time: '09:27'),
  ];

  static const Map<String, RevenueSeries> revenue = {
    'Өдөр': RevenueSeries(
      ['10AM', '11AM', '12PM', '1PM', '2PM', '3PM', '4PM'],
      [120000, 260000, 180000, 500000, 320000, 540000, 610000],
    ),
    '7 хоног': RevenueSeries(
      ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'],
      [800000, 640000, 910000, 1200000, 1100000, 1500000, 1320000],
    ),
    'Сар': RevenueSeries(
      ['1-р', '2-р', '3-р', '4-р', '5-р', '6-р', '7-р'],
      [2100000, 1800000, 2600000, 2241000, 3000000, 2800000, 3300000],
    ),
  };
}
