import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../data/models.dart';

enum PaymentMethod { cash, visa, mastercard, paypal }

/// Аппын нэгдсэн төлөв: сагс, карт, хаяг, профайл.
class AppState extends ChangeNotifier {
  AppState() {
    // Дизайны жишээ шиг сагсанд 2 бүтээгдэхүүнтэй эхэлнэ.
    _cart.add(CartItem(food: MockData.foods[0], size: 14, quantity: 1));
    _cart.add(CartItem(food: MockData.foods[1], size: 14, quantity: 2));
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
