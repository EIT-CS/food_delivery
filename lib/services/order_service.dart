import 'package:cloud_firestore/cloud_firestore.dart'
    show
        FieldValue,
        FirebaseFirestore,
        QueryDocumentSnapshot,
        QuerySnapshot,
        Timestamp;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/chef_data.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import 'geo_service.dart';

/// Захиалгын шат (Firestore-ын `status` талбар).
class OrderStage {
  OrderStage._();

  static const created = 'new'; // шинэ, хүлээгдэж байна
  static const preparing = 'preparing'; // тогооч бэлтгэж байна
  static const ready = 'ready'; // бэлэн болсон, хүргэгч хүлээж байна
  static const delivering = 'delivering'; // хүргэлтэд гарсан
  static const completed = 'completed'; // хүргэгдсэн
  static const cancelled = 'cancelled';

  static bool isActive(String s) =>
      s == created || s == preparing || s == ready || s == delivering;

  /// Хэрэглэгчийн талд харагдах шошго.
  static String label(String s) => switch (s) {
        created => 'ХҮЛЭЭГДЭЖ БАЙНА',
        preparing => 'БЭЛТГЭЖ БАЙНА',
        ready => 'ХҮРГЭГЧ ХҮЛЭЭЖ БАЙНА',
        delivering => 'ХҮРГЭЛТЭД ГАРСАН',
        completed => 'ДУУССАН',
        _ => 'ЦУЦЛАГДСАН',
      };

  /// Тогоочийн дараагийн үйлдлийн товчны нэр.
  static String chefAction(String s) => switch (s) {
        created => 'Хүлээн авах',
        preparing => 'Бэлэн болсон',
        _ => 'Хүргэгч хүлээж байна',
      };

  /// Тогоочийн дараагийн шат.
  static String next(String s) => switch (s) {
        created => preparing,
        preparing => ready,
        _ => s,
      };

  /// 0..3 — хяналтын дэлгэцийн алхам.
  static int step(String s) => switch (s) {
        created => 0,
        preparing => 1,
        ready => 1,
        delivering => 2,
        completed => 3,
        _ => 0,
      };

  static String etaMinutes(String s) => switch (s) {
        created => '30',
        preparing => '20',
        ready => '15',
        delivering => '10',
        _ => '0',
      };
}

/// Firestore-ын `orders/{id}` баримт. Нэг баримт = нэг хоолны мөр.
class OrderRecord {
  const OrderRecord({
    required this.docId,
    required this.orderNo,
    required this.customerId,
    required this.customerName,
    required this.foodId,
    required this.foodName,
    required this.restaurantId,
    required this.restaurantName,
    required this.size,
    required this.quantity,
    required this.total,
    required this.meal,
    required this.address,
    required this.payment,
    required this.stage,
    required this.createdAt,
    required this.updatedAt,
    this.originLat,
    this.originLng,
    this.destLat,
    this.destLng,
    this.courierId,
    this.courierName,
    this.courierPhone,
    this.courierLat,
    this.courierLng,
    this.locAt,
  });

  final String docId;
  final String orderNo;
  final String customerId;
  final String customerName;
  final String foodId;
  final String foodName;
  final String restaurantId;
  final String restaurantName;
  final int size;
  final int quantity;
  final int total;
  final String meal;
  final String address;
  final String payment;
  final String stage;
  final DateTime createdAt;

  /// Сүүлд шат өөрчлөгдсөн цаг (хүргэлт эхэлсэн цаг гэж тооцно).
  final DateTime updatedAt;

  /// Рестораны байршил (хүргэлт эхлэх цэг) ба хүргэх хаягийн байршил.
  final double? originLat;
  final double? originLng;
  final double? destLat;
  final double? destLng;

  /// Захиалгыг авсан хүргэгч (ready үед хоосон).
  final String? courierId;
  final String? courierName;
  final String? courierPhone;

  /// Хүргэгчийн бодит GPS байршил (хүргэлтийн үед).
  final double? courierLat;
  final double? courierLng;
  final DateTime? locAt;

  /// Хүргэлт эхэлснээс хойш өнгөрсөн хугацаагаар тооцсон явцын хувь (0..1).
  double get deliveryProgress {
    if (stage == OrderStage.completed) return 1;
    if (stage != OrderStage.delivering) return 0;
    final sec = DateTime.now().difference(updatedAt).inSeconds;
    return (sec / GeoService.simulatedDeliverySeconds).clamp(0.0, 1.0);
  }

  /// Хүрэх хүртэл үлдсэн минут (хамгийн багадаа 1).
  int get etaMinutesLeft {
    final left = GeoService.simulatedDeliverySeconds *
        (1 - deliveryProgress);
    final m = (left / 60).ceil();
    return m < 1 ? 1 : m;
  }

  static OrderRecord? fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    try {
      final m = d.data();
      final ts = m['createdAt'];
      return OrderRecord(
        docId: d.id,
        orderNo: (m['orderNo'] ?? d.id).toString(),
        customerId: m['customerId'] as String,
        customerName: m['customerName'] as String? ?? '',
        foodId: m['foodId'] as String,
        foodName: m['foodName'] as String? ?? '',
        restaurantId: m['restaurantId'] as String,
        restaurantName: m['restaurantName'] as String? ?? '',
        size: (m['size'] as num?)?.toInt() ?? 14,
        quantity: (m['quantity'] as num?)?.toInt() ?? 1,
        total: (m['total'] as num).toInt(),
        meal: m['meal'] as String? ?? 'Өдөр',
        address: m['address'] as String? ?? '',
        payment: m['payment'] as String? ?? 'cash',
        stage: m['status'] as String? ?? OrderStage.created,
        // serverTimestamp ирэхээс өмнө null байдаг тул одоогийн цагийг ашиглана.
        createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
        updatedAt: m['updatedAt'] is Timestamp
            ? (m['updatedAt'] as Timestamp).toDate()
            : (ts is Timestamp ? ts.toDate() : DateTime.now()),
        originLat: (m['originLat'] as num?)?.toDouble(),
        originLng: (m['originLng'] as num?)?.toDouble(),
        destLat: (m['destLat'] as num?)?.toDouble(),
        destLng: (m['destLng'] as num?)?.toDouble(),
        courierId: m['courierId'] as String?,
        courierName: m['courierName'] as String?,
        courierPhone: m['courierPhone'] as String?,
        courierLat: (m['courierLat'] as num?)?.toDouble(),
        courierLng: (m['courierLng'] as num?)?.toDouble(),
        locAt: m['locAt'] is Timestamp ? (m['locAt'] as Timestamp).toDate() : null,
      );
    } catch (_) {
      return null;
    }
  }

  String get dateLabel {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(createdAt.month)}/${two(createdAt.day)} '
        '${two(createdAt.hour)}:${two(createdAt.minute)}';
  }

  /// Хэрэглэгчийн "Миний захиалга" дэлгэцийн мөр.
  Order toOrder() {
    Food? food;
    for (final f in MockData.allFoods) {
      if (f.id == foodId) {
        food = f;
        break;
      }
    }
    return Order(
      id: orderNo,
      docId: docId,
      stage: stage,
      foodId: foodId,
      title: foodName,
      restaurant: restaurantName,
      itemsCount: quantity,
      total: total,
      date: dateLabel,
      status: switch (stage) {
        OrderStage.completed => OrderStatus.completed,
        OrderStage.cancelled => OrderStatus.cancelled,
        _ => OrderStatus.ongoing,
      },
      icon: food?.icon ?? Icons.restaurant,
      color: food?.color ?? const Color(0xFFE59A4B),
    );
  }

  /// Тогоочийн "Явагдаж буй захиалга" дэлгэцийн мөр.
  ChefOrder toChefOrder() => ChefOrder(
        id: orderNo,
        docId: docId,
        foodId: foodId,
        price: total,
        meal: meal,
        isNew: stage == OrderStage.created,
        stage: stage,
        customerName: customerName,
        quantity: quantity,
      );
}

/// Захиалгын Firestore үйлдлүүд.
class OrderService {
  OrderService._();

  static final OrderService instance = OrderService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  List<OrderRecord> _records(QuerySnapshot<Map<String, dynamic>> snap) {
    final list = <OrderRecord>[];
    for (final d in snap.docs) {
      final r = OrderRecord.fromDoc(d);
      if (r != null) list.add(r);
    }
    // Шинэ нь дээр (composite index шаардахгүйн тулд энд эрэмбэлнэ).
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Хэрэглэгчийн өөрийн захиалгууд (realtime).
  Stream<List<OrderRecord>> watchCustomer(String uid) => _db
      .collection('orders')
      .where('customerId', isEqualTo: uid)
      .snapshots()
      .map(_records);

  /// Тухайн рестораны захиалгууд (тогоочид, realtime).
  Stream<List<OrderRecord>> watchRestaurant(String restaurantId) => _db
      .collection('orders')
      .where('restaurantId', isEqualTo: restaurantId)
      .snapshots()
      .map(_records);

  /// Хүргэгчид: хүргэгч хүлээж буй (ready) бүх захиалга.
  Stream<List<OrderRecord>> watchAvailable() => _db
      .collection('orders')
      .where('status', isEqualTo: OrderStage.ready)
      .snapshots()
      .map(_records);

  /// Хүргэгчийн өөрийн авсан захиалгууд (идэвхтэй + хүргэсэн).
  Stream<List<OrderRecord>> watchCourier(String uid) => _db
      .collection('orders')
      .where('courierId', isEqualTo: uid)
      .snapshots()
      .map(_records);

  /// Хүргэгч захиалгыг авна. Хоёр хүргэгч зэрэг авбал Rules (status == ready
  /// шаардлага)-аар зөвхөн нэгний нь бичилт амжилттай болно.
  Future<void> acceptDelivery(
    String docId, {
    required String courierId,
    required String courierName,
    String? courierPhone,
  }) {
    return _db.collection('orders').doc(docId).update({
      'status': OrderStage.delivering,
      'courierId': courierId,
      'courierName': courierName,
      'courierPhone': courierPhone ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Сагсны мөр бүрийг тусдаа захиалга болгон нэг batch-аар бичнэ.
  Future<void> place({
    required String customerId,
    required String customerName,
    required String address,
    required String payment,
    required List<CartItem> items,
    double? destLat,
    double? destLng,
  }) async {
    final hour = DateTime.now().hour;
    final meal = hour < 11 ? 'Өглөө' : (hour < 17 ? 'Өдөр' : 'Орой');

    // Газрын зураг дээр сонгосон байршил байвал түүнийг, үгүй бол хаягийн
    // текстээс гаргасан демо цэгийг ашиглана.
    final dest = (destLat != null && destLng != null)
        ? LatLng(destLat, destLng)
        : GeoService.pointForText(address);

    final batch = _db.batch();
    var seq = 0;
    for (final item in items) {
      final food = item.food;
      final restaurant = MockData.restaurantById(food.restaurantId);
      final originLat = restaurant.lat ?? GeoService.center.latitude;
      final originLng = restaurant.lng ?? GeoService.center.longitude;
      final ref = _db.collection('orders').doc();
      final orderNo =
          (100000 + (DateTime.now().millisecondsSinceEpoch + seq++) % 900000)
              .toString();

      batch.set(ref, {
        'orderNo': orderNo,
        'customerId': customerId,
        'customerName': customerName,
        'foodId': food.id,
        'foodName': food.name,
        'restaurantId': food.restaurantId,
        'restaurantName': restaurant.name,
        'size': item.size,
        'quantity': item.quantity,
        'total': item.total,
        'meal': meal,
        'address': address,
        'originLat': originLat,
        'originLng': originLng,
        'destLat': dest.latitude,
        'destLng': dest.longitude,
        'payment': payment,
        'status': OrderStage.created,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> setStage(String docId, String stage) {
    return _db.collection('orders').doc(docId).update({
      'status': stage,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
