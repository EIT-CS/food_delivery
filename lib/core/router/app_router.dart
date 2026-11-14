import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/address/add_address_screen.dart';
import '../../features/address/addresses_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/sign_up_screen.dart';
import '../../features/auth/success_screen.dart';
import '../../features/auth/verification_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/foods/food_details_screen.dart';
import '../../features/foods/food_list_screen.dart';
import '../../features/chef/chef_add_food_screen.dart';
import '../../features/chef/chef_dashboard_screen.dart';
import '../../features/chef/chef_food_details_screen.dart';
import '../../features/chef/chef_foods_screen.dart';
import '../../features/chef/chef_menu_screen.dart';
import '../../features/chef/chef_notifications_screen.dart';
import '../../features/chef/chef_orders_screen.dart';
import '../../features/chef/chef_reviews_screen.dart';
import '../../features/chef/chef_withdraw_success_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/foods/restaurant_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/payment/add_card_screen.dart';
import '../../features/payment/payment_screen.dart';
import '../../features/payment/payment_success_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/menu_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reviews/reviews_screen.dart';
import '../../features/reviews/write_review_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/taste/taste_screen.dart';
import '../../features/top_foods/top_foods_screen.dart';
import '../../features/tracking/delivery_call_screen.dart';
import '../../features/tracking/delivery_chat_screen.dart';
import '../../features/tracking/tracking_details_screen.dart';
import '../../features/tracking/tracking_screen.dart';
import 'routes.dart';

/// Аппын бүх навигацын тодорхойлолт.
///
/// Урсгал:
///  Splash → Splash 2 → Onboarding → Login ⇄ Sign Up / Forgot → Verify → Success → Home
///  Home → Search / Foods / Restaurant → Food Details → Cart → Payment → (Add Card) →
///  Payment Success → Tracking → Tracking Details → Call / Chat
///  Home → Orders / Menu → Profile → Edit Profile / Addresses → Add Address
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.splash2,
      builder: (context, state) => const SplashScreen(second: true),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: Routes.forgot,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: Routes.verify,
      builder: (context, state) => const VerificationScreen(),
    ),
    GoRoute(
      path: Routes.success,
      builder: (context, state) => const SuccessScreen(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: Routes.foods,
      builder: (context, state) => FoodListScreen(
        key: ValueKey(state.uri.toString()),
        category: state.uri.queryParameters['category'],
      ),
    ),
    GoRoute(
      path: Routes.food,
      builder: (context, state) =>
          FoodDetailsScreen(foodId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: Routes.restaurant,
      builder: (context, state) =>
          RestaurantScreen(restaurantId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: Routes.cart,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: Routes.cartEdit,
      builder: (context, state) => const CartScreen(editing: true),
    ),
    GoRoute(
      path: Routes.payment,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: Routes.addCard,
      builder: (context, state) => const AddCardScreen(),
    ),
    GoRoute(
      path: Routes.paymentSuccess,
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
    GoRoute(
      path: Routes.tracking,
      builder: (context, state) => const TrackingScreen(),
    ),
    GoRoute(
      path: Routes.trackingDetails,
      builder: (context, state) => const TrackingDetailsScreen(),
    ),
    GoRoute(
      path: Routes.deliveryCall,
      builder: (context, state) => const DeliveryCallScreen(),
    ),
    GoRoute(
      path: Routes.deliveryChat,
      builder: (context, state) => const DeliveryChatScreen(),
    ),
    GoRoute(
      path: Routes.orders,
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: Routes.menu,
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: Routes.profileEdit,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: Routes.addresses,
      builder: (context, state) => const AddressesScreen(),
    ),
    GoRoute(
      path: Routes.addAddress,
      builder: (context, state) => const AddAddressScreen(),
    ),
    GoRoute(
      path: Routes.favorites,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: Routes.topFoods,
      builder: (context, state) => const TopFoodsScreen(),
    ),
    GoRoute(
      path: Routes.taste,
      builder: (context, state) => const TasteScreen(),
    ),
    GoRoute(
      path: Routes.myReviews,
      builder: (context, state) => const ReviewsScreen(),
    ),
    GoRoute(
      path: Routes.foodReviews,
      builder: (context, state) =>
          ReviewsScreen(foodId: state.pathParameters['id']),
    ),
    GoRoute(
      path: Routes.writeReview,
      builder: (context, state) =>
          WriteReviewScreen(foodId: state.pathParameters['id']!),
    ),
    // ----- Тогооч (Chef) -----
    GoRoute(
      path: Routes.chefHome,
      builder: (context, state) => const ChefDashboardScreen(),
    ),
    GoRoute(
      path: Routes.chefOrders,
      builder: (context, state) => const ChefOrdersScreen(),
    ),
    GoRoute(
      path: Routes.chefFoods,
      builder: (context, state) => const ChefFoodsScreen(),
    ),
    GoRoute(
      path: Routes.chefAddFood,
      builder: (context, state) => const ChefAddFoodScreen(),
    ),
    GoRoute(
      path: Routes.chefFood,
      builder: (context, state) =>
          ChefFoodDetailsScreen(foodId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: Routes.chefMenu,
      builder: (context, state) => const ChefMenuScreen(),
    ),
    GoRoute(
      path: Routes.chefWithdrawSuccess,
      builder: (context, state) => const ChefWithdrawSuccessScreen(),
    ),
    GoRoute(
      path: Routes.chefNotifications,
      builder: (context, state) => ChefNotificationsScreen(
        initialTab: state.uri.queryParameters['tab'] == 'messages' ? 1 : 0,
      ),
    ),
    GoRoute(
      path: Routes.chefReviews,
      builder: (context, state) => const ChefReviewsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Хуудас олдсонгүй: ${state.uri}')),
  ),
);
