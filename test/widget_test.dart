import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/data/models.dart';
import 'package:food_delivery_app/state/app_state.dart';
import 'package:food_delivery_app/data/mock_data.dart';

void main() {
  test('formatPrice groups thousands', () {
    expect(formatPrice(28000), '₮28,000');
    expect(formatPrice(1234567), '₮1,234,567');
    expect(formatPrice(0), '₮0');
  });

  test('cart totals and merging identical items', () {
    final app = AppState();
    app.clearCart();
    final food = MockData.foods.first;
    app.addToCart(food, size: 14, quantity: 1);
    app.addToCart(food, size: 14, quantity: 2);
    expect(app.cart.length, 1);
    expect(app.cartCount, 3);
    expect(app.subtotal, food.price * 3);
    expect(app.total, app.subtotal + app.deliveryFee);
  });
}
