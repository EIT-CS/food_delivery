/// Аппын бүх замууд (route path) нэг дор.
class Routes {
  Routes._();

  // Эхлэл
  static const splash = '/';
  static const splash2 = '/splash-2';
  static const onboarding = '/onboarding';

  // Нэвтрэлт
  static const login = '/login';
  static const forgot = '/forgot-password';
  static const verify = '/verification';
  static const signUp = '/sign-up';
  static const success = '/success';

  // Нүүр, хайлт, хоол
  static const home = '/home';
  static const search = '/search';
  static const foods = '/foods';
  static const food = '/food/:id';
  static const restaurant = '/restaurant/:id';

  // Сагс, төлбөр
  static const cart = '/cart';
  static const cartEdit = '/cart/edit';
  static const payment = '/payment';
  static const addCard = '/payment/add-card';
  static const paymentSuccess = '/payment/success';

  // Хүргэлт
  static const tracking = '/tracking';
  static const trackingDetails = '/tracking/details';
  static const deliveryCall = '/delivery/call';
  static const deliveryChat = '/delivery/chat';

  // Профайл
  static const orders = '/orders';
  static const menu = '/menu';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const addresses = '/addresses';
  static const addAddress = '/addresses/new';

  static String foodPath(String id) => '/food/$id';
  static String restaurantPath(String id) => '/restaurant/$id';
  static String foodsPath({String? category}) => category == null
      ? foods
      : '$foods?category=${Uri.encodeQueryComponent(category)}';
}
