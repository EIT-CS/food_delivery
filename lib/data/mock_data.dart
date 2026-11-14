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
      image: 'assets/images/restaurants/rest1.jpg',
    ),
    Restaurant(
      id: 'r2',
      name: 'Rose Garden Restaurant',
      cuisine: 'Стейк · Паста · Салат',
      rating: 4.7,
      minutes: 20,
      icon: Icons.dinner_dining,
      color: Color(0xFFB98A5B),
      image: 'assets/images/restaurants/rest2.jpg',
    ),
    Restaurant(
      id: 'r3',
      name: 'Буфало Бургер',
      cuisine: 'Бургер · Фри · Ундаа',
      rating: 4.5,
      minutes: 15,
      icon: Icons.lunch_dining,
      color: Color(0xFFD9A441),
      image: 'assets/images/restaurants/rest3.jpg',
    ),
    Restaurant(
      id: 'r4',
      name: 'Утгэр Кофе Хаус',
      cuisine: 'Кофе · Амттан · Бургер',
      rating: 4.3,
      minutes: 25,
      icon: Icons.coffee,
      color: Color(0xFF9C7A5B),
      image: 'assets/images/restaurants/rest4.jpg',
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
      image: 'assets/images/foods/pizza.jpg',
      meal: 'Өглөө',
      description:
          'Шинэхэн улаан лоолийн соус, моцарелла бяслаг, үнэрт ногоон өвсөөр бэлтгэсэн уламжлалт Италийн пицца. Халуунаар нь хүргэнэ.',
      tags: [Taste.healthy],
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
      image: 'assets/images/foods/burger.jpg',
      description:
          'Шарсан үхрийн махтай, шинэхэн хүнсний ногоо болон тусгай соустай том бургер.',
    ),
    Food(
      id: 'f3',
      name: 'Тахианы Сэндвич',
      restaurantId: 'r3',
      category: 'Бургер',
      price: 24000,
      rating: 4.5,
      minutes: 15,
      icon: Icons.fastfood,
      color: Color(0xFFD9A441),
      image: 'assets/images/foods/sendvich.jpg',
      description:
          'Шаржигнасан тахианы махтай бургер, хажуугаар нь алтлаг төмсөн фри.',
      tags: [Taste.spicy],
    ),
    Food(
      id: 'f4',
      name: 'Мексик Буррито',
      restaurantId: 'r3',
      category: 'Бургер',
      price: 29000,
      rating: 4.4,
      minutes: 20,
      icon: Icons.lunch_dining,
      color: Color(0xFFC98B4E),
      image: 'assets/images/foods/burrito.jpg',
      description:
          'Давхар шарсан мах, чедар бяслаг, карамель сонгинотой бургер.',
      tags: [Taste.spicy],
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
      image: 'assets/images/foods/pasta.jpg',
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
      tags: [Taste.healthy],
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
      image: 'assets/images/foods/pizza.jpg',
      meal: 'Орой',
      description: 'Халуун ногоотой пепперони, моцарелла бяслагтай пицца.',
      tags: [Taste.spicy],
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

  /// Тогоочийн (Chef) нэмсэн хоолнууд. Хэрэглэгчийн талд бас харагдана.
  static final List<Food> extraFoods = [];

  /// Үндсэн хоол + тогоочийн нэмсэн хоолнууд.
  static List<Food> get allFoods => [...foods, ...extraFoods];

  static Food foodById(String id) =>
      allFoods.firstWhere((f) => f.id == id, orElse: () => foods.first);

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
      foodId: 'f8',
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
      foodId: 'f2',
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
      foodId: 'f6',
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
      foodId: 'f7',
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
      foodId: 'f10',
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

  static const List<Review> reviews = [
    Review(
      id: 'rv1',
      foodId: 'f1',
      author: 'Бат-Эрдэнэ',
      rating: 5,
      text: 'Хямдхан ч маш амттай пицца байлаа. Бяслаг нь сунаж, шингэн халуун ирсэн.',
      date: '2 өдрийн өмнө',
      photos: 2,
    ),
    Review(
      id: 'rv2',
      foodId: 'f1',
      author: 'Оюунаа',
      rating: 4,
      text: 'Амт сайн, гэхдээ хүргэлт бага зэрэг удсан.',
      date: '1 долоо хоногийн өмнө',
    ),
    Review(
      id: 'rv3',
      foodId: 'f2',
      author: 'Тэмүүлэн',
      rating: 5,
      text: 'Мах нь шүүслэг, талх нь зөөлөн. Дахин захиална!',
      date: 'Өчигдөр',
      photos: 1,
    ),
    Review(
      id: 'rv4',
      foodId: 'f2',
      author: 'Саруул',
      rating: 4,
      text: 'Порц том, үнэ ямар ч гэсэн боломжийн.',
      date: '3 өдрийн өмнө',
    ),
    Review(
      id: 'rv5',
      foodId: 'f5',
      author: 'Ганаа',
      rating: 5,
      text: 'Стейк яг дундаж шарагдсан, төмс нь гайхалтай.',
      date: '4 өдрийн өмнө',
      photos: 3,
    ),
    Review(
      id: 'rv6',
      foodId: 'f6',
      author: 'Номин',
      rating: 5,
      text: 'Соус нь баялаг, гэрийн амттай.',
      date: '5 өдрийн өмнө',
    ),
    Review(
      id: 'rv7',
      foodId: 'f7',
      author: 'Хулан',
      rating: 4,
      text: 'Шинэхэн, хөнгөн. Өдрийн хоолонд яг тохиромжтой.',
      date: '6 өдрийн өмнө',
    ),
    Review(
      id: 'rv8',
      foodId: 'f9',
      author: 'Дулмаа',
      rating: 5,
      text: 'Шоколад нь урсаж байна, үнэхээр амттай!',
      date: 'Өчигдөр',
      photos: 2,
    ),
    Review(
      id: 'rv9',
      foodId: 'f9',
      author: 'Анужин',
      rating: 5,
      text: 'Хамгийн дуртай амттан минь болчихлоо.',
      date: '2 өдрийн өмнө',
    ),
    Review(
      id: 'rv10',
      foodId: 'f8',
      author: 'Мөнх',
      rating: 4,
      text: 'Халуун ногоо нь тохиромжтой, пепперони их.',
      date: '1 долоо хоногийн өмнө',
    ),
    Review(
      id: 'rv11',
      foodId: 'f3',
      author: 'Билгүүн',
      rating: 4,
      text: 'Тахиа нь шаржигнасан, фри нь халуун ирсэн.',
      date: '3 өдрийн өмнө',
    ),
  ];
}
