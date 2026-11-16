import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Төхөөрөмжийн GPS байршил.
///
///  • [current]: "Миний байршил" (хаяг сонгоход).
///  • [trackDeliveries]: хүргэгч хүргэлт хийж байх үед байршлаа захиалгын
///    баримт руу (courierLat/courierLng/locAt) тогтмол бичнэ. Хэрэглэгчийн
///    газрын зураг бодит байршлыг энэ мэдээллээс авна.
class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  StreamSubscription<Position>? _sub;
  Set<String> _orderIds = {};
  DateTime _lastWrite = DateTime.fromMillisecondsSinceEpoch(0);

  /// Зөвшөөрөл, үйлчилгээг шалгана. Боломжгүй бол шалтгаан (текст) буцаана.
  Future<String?> _ensure() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return 'Төхөөрөмжийн байршлын үйлчилгээг (GPS) асаана уу';
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return 'Байршлын зөвшөөрөл өгөөгүй байна';
      }
      return null;
    } catch (e) {
      return 'Байршил тодорхойлох боломжгүй ($e)';
    }
  }

  /// Одоогийн байршил. Амжилтгүй бол (null, шалтгаан).
  Future<(LatLng?, String?)> current() async {
    final err = await _ensure();
    if (err != null) return (null, err);
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return (LatLng(p.latitude, p.longitude), null);
    } catch (_) {
      return (null, 'Байршил олдсонгүй. Дахин оролдоно уу');
    }
  }

  /// Хүргэж буй захиалгуудын ID-г шинэчилнэ. Хоосон бол GPS-г зогсооно.
  Future<void> trackDeliveries(Set<String> orderIds) async {
    _orderIds = orderIds;
    if (orderIds.isEmpty) {
      await stop();
      return;
    }
    if (_sub != null) return;
    final err = await _ensure();
    if (err != null) {
      debugPrint('GPS: $err');
      return;
    }
    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 8, // метр
      ),
    ).listen(_onPosition, onError: (Object e) => debugPrint('GPS алдаа: $e'));
  }

  void _onPosition(Position p) {
    final now = DateTime.now();
    if (now.difference(_lastWrite).inSeconds < 4) return;
    _lastWrite = now;
    for (final id in _orderIds) {
      FirebaseFirestore.instance.collection('orders').doc(id).update({
        'courierLat': p.latitude,
        'courierLng': p.longitude,
        'locAt': FieldValue.serverTimestamp(),
      }).catchError((Object e) => debugPrint('Байршил бичих алдаа: $e'));
    }
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }
}
