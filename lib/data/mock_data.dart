import 'package:flutter/material.dart';

import 'models.dart';

/// Backend холбогдох хүртэл ашиглах түр өгөгдөл.
class MockData {
  MockData._();

  static const List<FoodCategory> categories = [
    FoodCategory('Бүгд', Icons.restaurant_menu, Color(0xFFE7F3D2)),
    FoodCategory('Пицца', Icons.local_pizza, Color(0xFFFFE9D6)),
    FoodCategory('Бургер', Icons.lunch_dining, Color(0xFFFFF0C9)),
    FoodCategory('Паста', Icons.ramen_dining, Color(0xFFFFE0DC)),
    FoodCategory('Салат', Icons.eco, Color(0xFFE1F5E1)),
    FoodCategory('Амттан', Icons.cake, Color(0xFFF6E1F2)),
    FoodCategory('Ундаа', Icons.local_drink, Color(0xFFDDEEFF)),
  ];

  static const List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Слайси Ресторан',
      cuisine: 'Бургер · Пицца · Сэндвич',
      rating: 4.7,
      minutes: 20,
      icon: Icons.restaurant,
      color: Color(0xFFE9A96B),
    ),
    Restaurant(
      id: 'r2',
      name: 'Rose Garden Restaurant',
      cuisine: 'Стейк · Паста · Салат',
      rating: 4.7,
      minutes: 20,
      icon: Icons.dinner_dining,
      color: Color(0xFFB98A5B),
    ),
    Restaurant(
      id: 'r3',
      name: 'Буфало Бургер',
      cuisine: 'Бургер · Фри · Ундаа',
      rating: 4.5,
      minutes: 15,
      icon: Icons.lunch_dining,
      color: Color(0xFFD9A441),
    ),
    Restaurant(
      id: 'r4',
      name: 'Утгэр Кофе Хаус',
      cuisine: 'Кофе · Амттан · Бургер',
      rating: 4.3,
      minutes: 25,
      icon: Icons.coffee,
      color: Color(0xFF9C7A5B),
    ),
  ];

  static const List<Food> foods = [
    Food(
      id: 'f1',
      name: 'Европын Маргарита Калзоне Пицца',
      restaurantId: 'r1',
      category: 'Пицца',
      price: 28000,
      rating: 4.7,
      minutes: 20,
      icon: Icons.local_pizza,
      color: Color(0xFFF2B26B),
      description:
          'Шинэхэн улаан лоолийн соус, моцарелла бяслаг, үнэрт ногоон өвсөөр бэлтгэсэн уламжлалт Италийн пицца. Халуунаар нь хүргэнэ.',
    ),
    Food(
      id: 'f2',
      name: 'Бургер Бистро',
      restaurantId: 'r1',
      category: 'Бургер',
      price: 26000,
      rating: 4.7,
      minutes: 15,
      icon: Icons.lunch_dining,
      color: Color(0xFFE59A4B),
      description:
          'Шарсан үхрийн махтай, шинэхэн хүнсний ногоо болон тусгай соустай том бургер.',
    ),
    Food(
      id: 'f3',
      name: 'Бүлэнцэг Фри Бургер',
      restaurantId: 'r3',
      category: 'Бургер',
      price: 24000,
      rating: 4.5,
      minutes: 15,
      icon: Icons.fastfood,
      color: Color(0xFFD9A441),
      description:
          'Шаржигнасан тахианы махтай бургер, хажуугаар нь алтлаг төмсөн фри.',
    ),
    Food(
      id: 'f4',
      name: 'Рокзан Бургер',
      restaurantId: 'r3',
      category: 'Бургер',
      price: 29000,
      rating: 4.4,
      minutes: 20,
      icon: Icons.lunch_dining,
      color: Color(0xFFC98B4E),
      description:
          'Давхар шарсан мах, чедар бяслаг, карамель сонгинотой бургер.',
    ),
    Food(
      id: 'f5',
      name: 'Стейк & Төмс',
      restaurantId: 'r2',
      category: 'Паста',
      price: 42000,
      rating: 4.8,
      minutes: 25,
      icon: Icons.dinner_dining,
      color: Color(0xFFB98A5B),
      description:
          'Ширхэгтэй шарсан стейк, нэхийн тос болон халуун ногоотой төмс.',
    ),
    Food(
      id: 'f6',
      name: 'Спагетти Болонез',
      restaurantId: 'r2',
      category: 'Паста',
      price: 22000,
      rating: 4.6,
      minutes: 18,
      icon: Icons.ramen_dining,
      color: Color(0xFFE8794F),
      description: 'Үхрийн махны хайлмал соустай уламжлалт Италийн спагетти.',
    ),
    Food(
      id: 'f7',
      name: 'Цезарь Салат',
      restaurantId: 'r4',
      category: 'Салат',
      price: 18000,
      rating: 4.3,
      minutes: 10,
      icon: Icons.eco,
      color: Color(0xFF8DBB5A),
      description:
          'Шинэхэн салат навч, тахианы мах, пармезан бяслагтай хөнгөн салат.',
    ),
    Food(
      id: 'f8',
      name: 'Пепперони Пицца',
      restaurantId: 'r1',
      category: 'Пицца',
      price: 30000,
      rating: 4.6,
      minutes: 22,
      icon: Icons.local_pizza,
      color: Color(0xFFE2744A),
      description: 'Халуун ногоотой пепперони, моцарелла бяслагтай пицца.',
    ),
    Food(
      id: 'f9',
      name: 'Шоколадтай Бялуу',
      restaurantId: 'r4',
      category: 'Амттан',
      price: 12000,
      rating: 4.9,
      minutes: 10,
      icon: Icons.cake,
      color: Color(0xFF8B5A3C),
      description: 'Зөөлөн бялуу, дулаан шоколадан дүүргэлттэй амттан.',
    ),
    Food(
      id: 'f10',
      name: 'Кока Кола 0.5л',
      restaurantId: 'r3',
      category: 'Ундаа',
      price: 3500,
      rating: 4.5,
      minutes: 5,
      icon: Icons.local_drink,
      color: Color(0xFFD64545),
      description: 'Хөргөсөн ундаа.',
    ),
  ];

  static Food foodById(String id) =>
      foods.firstWhere((f) => f.id == id, orElse: () => foods.first);

  static Restaurant restaurantById(String id) => restaurants
      .firstWhere((r) => r.id == id, orElse: () => restaurants.first);

  static const List<String> recentSearches = [
    'Бургер',
    'Сэндвич',
    'Пицца',
    'Салат',
  ];

  static const List<Order> orders = [
    Order(
      id: '#162432',
      title: 'Пепперони Пицца',
      restaurant: 'Слайси Ресторан',
      itemsCount: 3,
      total: 35250,
      date: '29 Окт, 18:15',
      status: OrderStatus.ongoing,
      icon: Icons.local_pizza,
      color: Color(0xFFF2B26B),
    ),
    Order(
      id: '#242432',
      title: 'Бургер Бистро',
      restaurant: 'Буфало Бургер',
      itemsCount: 2,
      total: 40000,
      date: '29 Окт, 17:40',
      status: OrderStatus.ongoing,
      icon: Icons.lunch_dining,
      color: Color(0xFFE59A4B),
    ),
    Order(
      id: '#240112',
      title: 'Спагетти Болонез',
      restaurant: 'Rose Garden Restaurant',
      itemsCount: 1,
      total: 22000,
      date: '24 Окт, 13:20',
      status: OrderStatus.completed,
      icon: Icons.ramen_dining,
      color: Color(0xFFE8794F),
    ),
    Order(
      id: '#239874',
      title: 'Цезарь Салат',
      restaurant: 'Утгэр Кофе Хаус',
      itemsCount: 2,
      total: 36000,
      date: '20 Окт, 12:05',
      status: OrderStatus.completed,
      icon: Icons.eco,
      color: Color(0xFF8DBB5A),
    ),
    Order(
      id: '#238001',
      title: 'Кока Кола 0.5л',
      restaurant: 'Буфало Бургер',
      itemsCount: 4,
      total: 14000,
      date: '12 Окт, 20:30',
      status: OrderStatus.cancelled,
      icon: Icons.local_drink,
      color: Color(0xFFD64545),
    ),
  ];

  static const List<ChatMessage> initialChat = [
    ChatMessage(
      text: 'Сайн байна уу, таны захиалгыг авлаа.',
      fromMe: false,
      time: '18:02',
    ),
    ChatMessage(
      text: 'Сайн байна уу! Хэзээ хүрч ирэх вэ?',
      fromMe: true,
      time: '18:03',
    ),
    ChatMessage(
      text: 'Ойролцоогоор 10 минутын дараа таны хаяганд очно.',
      fromMe: false,
      time: '18:03',
    ),
    ChatMessage(
      text: 'За, баярлалаа!',
      fromMe: true,
      time: '18:04',
    ),
  ];
}
