import 'package:flutter/material.dart';

import '../data/accounts.dart';
import '../data/chef_data.dart';
import '../data/mock_data.dart';
import '../data/models.dart';

enum PaymentMethod { cash, visa, mastercard, paypal }

/// Аппын нэгдсэн төлөв: сагс, карт, хаяг, профайл.
class AppState extends ChangeNotifier {
  AppState() {
    // Дизайны жишээ шиг сагсанд 2 бүтээгдэхүүнтэй эхэлнэ.
    _cart.add(CartItem(food: MockData.allFoods[0], size: 14, quantity: 1));
    _cart.add(CartItem(food: MockData.allFoods[1], size: 14, quantity: 2));
  }

  // ----- Сагс -----
  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);
  int get cartCount => _cart.fold(0, (sum, i) => sum + i.quantity);
  int get subtotal => _cart.fold(0, (sum, i) => sum + i.total);
  int get deliveryFee => _cart.isEmpty ? 0 : 3000;
  int get total => subtotal + deliveryFee;

  void addToCart(Food food, {int size = 14, int quantity = 1}) {
    final existing = _cart.where((i) => i.food.id == food.id && i.size == size);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _cart.add(CartItem(food: food, size: size, quantity: quantity));
    }
    notifyListeners();
  }

  void increment(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // ----- Төлбөр -----
  PaymentMethod paymentMethod = PaymentMethod.cash;
  final List<PaymentCard> _cards = [];
  List<PaymentCard> get cards => List.unmodifiable(_cards);

  void selectPayment(PaymentMethod method) {
    paymentMethod = method;
    notifyListeners();
  }

  void addCard(PaymentCard card) {
    _cards.add(card);
    paymentMethod = PaymentMethod.mastercard;
    notifyListeners();
  }

  // ----- Хаяг -----
  final List<Address> _addresses = [
    const Address(
      label: 'ГЭР',
      text: 'Улаанбаатар хот, Сүхбаатар дүүрэг, 1-р хороо, 12-р байр',
      icon: Icons.home_outlined,
    ),
    const Address(
      label: 'АЖИЛ',
      text: 'Улаанбаатар хот, Чингэлтэй дүүрэг, Барилгачдын талбай',
      icon: Icons.work_outline,
    ),
  ];
  List<Address> get addresses => List.unmodifiable(_addresses);
  int selectedAddress = 0;
  Address get currentAddress => _addresses[selectedAddress];

  void addAddress(Address address) {
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(int index) {
    if (_addresses.length <= 1) return;
    _addresses.removeAt(index);
    if (selectedAddress >= _addresses.length) {
      selectedAddress = _addresses.length - 1;
    }
    notifyListeners();
  }

  void selectAddress(int index) {
    selectedAddress = index;
    notifyListeners();
  }

  // ----- Дуртай хоол, ресторан -----
  final Set<String> _favFoods = {};
  final Set<String> _favRestaurants = {};

  bool isFavoriteFood(String id) => _favFoods.contains(id);
  bool isFavoriteRestaurant(String id) => _favRestaurants.contains(id);
  int get favoritesCount => _favFoods.length + _favRestaurants.length;

  List<Food> get favoriteFoods =>
      MockData.allFoods.where((f) => _favFoods.contains(f.id)).toList();
  List<Restaurant> get favoriteRestaurants => MockData.restaurants
      .where((r) => _favRestaurants.contains(r.id))
      .toList();

  void toggleFavoriteFood(String id) {
    if (!_favFoods.remove(id)) _favFoods.add(id);
    notifyListeners();
  }

  void toggleFavoriteRestaurant(String id) {
    if (!_favRestaurants.remove(id)) _favRestaurants.add(id);
    notifyListeners();
  }

  // ----- Миний амт -----
  final Set<Taste> _tastes = {};
  Set<Taste> get tastes => Set.unmodifiable(_tastes);
  bool get hasTastes => _tastes.isNotEmpty;

  void setTastes(Set<Taste> tastes) {
    _tastes
      ..clear()
      ..addAll(tastes);
    notifyListeners();
  }

  /// Сонгосон амтуудаас хамгийн олныг нь хангасан хоолнууд (дараа нь үнэлгээгээр).
  List<Food> get recommended {
    if (_tastes.isEmpty) return const [];
    int score(Food f) => _tastes.where(f.matches).length;
    final list = MockData.allFoods.where((f) => score(f) > 0).toList()
      ..sort((a, b) {
        final byScore = score(b).compareTo(score(a));
        return byScore != 0 ? byScore : ratingOf(b).compareTo(ratingOf(a));
      });
    return list;
  }

  /// Хоол тухайн хэрэглэгчийн амтад хэдэн удаа таарч байгааг харуулна.
  List<Taste> matchedTastes(Food food) =>
      _tastes.where(food.matches).toList();

  // ----- Үнэлгээ, сэтгэгдэл -----
  final List<Review> _reviews = [...MockData.reviews];
  List<Review> get allReviews => List.unmodifiable(_reviews);

  List<Review> reviewsFor(String foodId) =>
      _reviews.where((r) => r.foodId == foodId).toList();

  List<Review> get myReviews => _reviews.where((r) => r.mine).toList();

  bool hasReviewed(String foodId) =>
      _reviews.any((r) => r.mine && r.foodId == foodId);

  int reviewCountOf(Food food) => reviewsFor(food.id).length;

  /// Сэтгэгдэл байвал тэдгээрийн дундаж, үгүй бол хоолны анхны үнэлгээ.
  double ratingOf(Food food) {
    final list = reviewsFor(food.id);
    if (list.isEmpty) return food.rating;
    final sum = list.fold<int>(0, (s, r) => s + r.rating);
    return sum / list.length;
  }

  void addReview({
    required String foodId,
    required int rating,
    required String text,
    int photos = 0,
  }) {
    _reviews.insert(
      0,
      Review(
        id: 'me${_reviews.length}',
        foodId: foodId,
        author: profile.name,
        rating: rating,
        text: text.trim(),
        date: 'Дөнгөж сая',
        photos: photos,
        mine: true,
      ),
    );
    notifyListeners();
  }

  /// ТОП хоол: үнэлгээ өндрөөс нь, тэнцвэл сэтгэгдлийн тоогоор.
  List<Food> get topFoods {
    final list = [...MockData.allFoods];
    list.sort((a, b) {
      final byRating = ratingOf(b).compareTo(ratingOf(a));
      return byRating != 0
          ? byRating
          : reviewCountOf(b).compareTo(reviewCountOf(a));
    });
    return list;
  }

  List<Food> foodsOf(Restaurant r) =>
      MockData.allFoods.where((f) => f.restaurantId == r.id).toList();

  int reviewCountOfRestaurant(Restaurant r) =>
      foodsOf(r).fold(0, (s, f) => s + reviewCountOf(f));

  /// Рестораны үнэлгээ: хоолнуудын үнэлгээний дундаж (сэтгэгдэлгүй бол анхных).
  double ratingOfRestaurant(Restaurant r) {
    final rated = foodsOf(r).where((f) => reviewCountOf(f) > 0).toList();
    if (rated.isEmpty) return r.rating;
    return rated.fold<double>(0, (s, f) => s + ratingOf(f)) / rated.length;
  }

  List<Restaurant> get topRestaurants {
    final list = [...MockData.restaurants];
    list.sort((a, b) {
      final byRating = ratingOfRestaurant(b).compareTo(ratingOfRestaurant(a));
      return byRating != 0
          ? byRating
          : reviewCountOfRestaurant(b).compareTo(reviewCountOfRestaurant(a));
    });
    return list;
  }

  // ===================== Нэвтрэлт, дүр =====================
  UserRole _role = UserRole.customer;
  UserRole get role => _role;
  bool get isChef => _role == UserRole.chef;

  /// Имэйлээр дүрийг тодорхойлно: тогоочийн имэйл бол Chef, бусад нь хэрэглэгч.
  void signIn(String email) {
    _role = Accounts.roleOf(email);
    profile.email = email.trim();
    notifyListeners();
  }

  // ===================== Тогооч (Chef) =====================
  /// Тогоочийн ресторан (хэрэглэгчийн талд ч харагдана).
  static const String chefRestaurantId = 'r1';

  final List<ChefOrder> _chefOrders = [...ChefData.orders];
  List<ChefOrder> get chefOrders => List.unmodifiable(_chefOrders);
  int get newChefOrderCount => _chefOrders.where((o) => o.isNew).length;

  int _chefRevenue = 2241000;
  int get chefRevenue => _chefRevenue;

  int _chefBalance = 500000;
  int get chefBalance => _chefBalance;

  final List<Withdrawal> _withdrawals = [];
  List<Withdrawal> get withdrawals => List.unmodifiable(_withdrawals);

  /// "Болсон": захиалга хүргэгдэж, орлого болон үлдэгдэлд нэмэгдэнэ.
  void completeChefOrder(ChefOrder order) {
    if (_chefOrders.remove(order)) {
      _chefRevenue += order.price;
      _chefBalance += order.price;
      notifyListeners();
    }
  }

  void cancelChefOrder(ChefOrder order) {
    if (_chefOrders.remove(order)) notifyListeners();
  }

  /// Бүх үлдэгдлийг татна. Үлдэгдэл 0 бол false.
  bool withdrawAll() {
    if (_chefBalance <= 0) return false;
    _withdrawals.insert(
      0,
      Withdrawal(amount: _chefBalance, date: 'Дөнгөж сая'),
    );
    _chefBalance = 0;
    notifyListeners();
    return true;
  }

  List<Food> get chefFoods => MockData.allFoods
      .where((f) => f.restaurantId == chefRestaurantId)
      .toList();

  final Map<String, List<String>> _ingredients = {};

  /// Хоолны орц (тогооч сонгоогүй хоолонд үндсэн 6 орц).
  List<String> ingredientsOf(String foodId) =>
      _ingredients[foodId] ??
      ChefData.mainIngredients.take(6).map((e) => e.name).toList();

  /// Тогоочийн шинэ хоол: хэрэглэгчийн Нүүр, Хайлтад шууд гарна.
  void addChefFood({
    required String name,
    required int price,
    required String meal,
    required List<String> ingredients,
    String description = '',
  }) {
    final id = 'cf${MockData.extraFoods.length + 1}';
    MockData.extraFoods.add(
      Food(
        id: id,
        name: name,
        restaurantId: chefRestaurantId,
        category: 'Бусад',
        price: price,
        rating: 4.5,
        minutes: 20,
        icon: Icons.restaurant,
        color: const Color(0xFFE59A4B),
        description: description.isEmpty
            ? 'Тогоочийн шинэ хоол.'
            : description,
        meal: meal,
      ),
    );
    _ingredients[id] = ingredients;
    notifyListeners();
  }

  /// Тогоочийн хоолнуудад ирсэн сэтгэгдлүүд.
  List<Review> get chefReviews => _reviews
      .where((r) =>
          MockData.foodById(r.foodId).restaurantId == chefRestaurantId)
      .toList();

  double get chefRating {
    final list = chefReviews;
    if (list.isEmpty) return 0;
    return list.fold<int>(0, (s, r) => s + r.rating) / list.length;
  }

  // ----- Профайл -----
  final UserProfile profile = UserProfile(
    name: 'Anno',
    bio: 'Би хоол хийх дуртай',
    email: 'hello@example.mn',
    phone: '+976 9911 2233',
  );

  void updateProfile({
    required String name,
    required String bio,
    required String email,
    required String phone,
  }) {
    profile
      ..name = name
      ..bio = bio
      ..email = email
      ..phone = phone;
    notifyListeners();
  }
}

/// `AppScope.of(context)` гэж дуудаж төлөвт хандана.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope олдсонгүй');
    return scope!.notifier!;
  }
}
