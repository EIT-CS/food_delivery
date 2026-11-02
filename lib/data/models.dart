import 'package:flutter/material.dart';

class Food {
  const Food({
    required this.id,
    required this.name,
    required this.restaurantId,
    required this.category,
    required this.price,
    required this.rating,
    required this.minutes,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String id;
  final String name;
  final String restaurantId;
  final String category;
  final int price;
  final double rating;
  final int minutes;
  final IconData icon;
  final Color color;
  final String description;
}

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.minutes,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int minutes;
  final IconData icon;
  final Color color;
}

class FoodCategory {
  const FoodCategory(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}

class CartItem {
  CartItem({required this.food, this.size = 14, this.quantity = 1});

  final Food food;
  final int size;
  int quantity;

  int get total => food.price * quantity;
}

enum OrderStatus { ongoing, completed, cancelled }

class Order {
  const Order({
    required this.id,
    required this.title,
    required this.restaurant,
    required this.itemsCount,
    required this.total,
    required this.date,
    required this.status,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String restaurant;
  final int itemsCount;
  final int total;
  final String date;
  final OrderStatus status;
  final IconData icon;
  final Color color;
}

class Address {
  const Address({
    required this.label,
    required this.text,
    required this.icon,
  });

  final String label;
  final String text;
  final IconData icon;
}

class PaymentCard {
  const PaymentCard({
    required this.holder,
    required this.number,
    required this.expiry,
  });

  final String holder;
  final String number;
  final String expiry;

  String get masked {
    final digits = number.replaceAll(' ', '');
    final last =
        digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
    return '**** **** **** $last';
  }
}

class ChatMessage {
  const ChatMessage(
      {required this.text, required this.fromMe, required this.time});

  final String text;
  final bool fromMe;
  final String time;
}

class UserProfile {
  UserProfile({
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
  });

  String name;
  String bio;
  String email;
  String phone;
}

/// 1234567 -> "₮1,234,567"
String formatPrice(int value) {
  final s = value.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '${value < 0 ? '-' : ''}₮$buf';
}
