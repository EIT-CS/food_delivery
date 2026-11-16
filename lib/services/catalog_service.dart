import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, QuerySnapshot, SetOptions;
import 'package:flutter/foundation.dart';

import '../data/accounts.dart';
import '../data/catalog_codec.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import 'auth_service.dart';

/// Хоол, рестораны өгөгдлийг Firestore-оос realtime уншина.
///
/// Firestore бүтэц:
///   foods/{foodId}              → Food (CatalogCodec.foodToMap)
///   restaurants/{restaurantId}  → Restaurant
///
/// Firestore хоосон эсвэл холбогдоогүй үед апп `MockData`-ын жишээ өгөгдлөөр
/// ажиллана. Анхны өгөгдлийг тогооч нэвтэрмэгц нэг удаа Firestore руу хуулна.
class CatalogService {
  CatalogService._();

  static final CatalogService instance = CatalogService._();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _foodsSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _restaurantsSub;
  VoidCallback? _onChanged;
  bool _seeding = false;

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Апп эхлэхэд нэг удаа дуудна. Өгөгдөл өөрчлөгдөх бүрт `onChanged` дуудагдана.
  void start({required VoidCallback onChanged}) {
    _onChanged = onChanged;
    _foodsSub?.cancel();
    _restaurantsSub?.cancel();

    try {
      _foodsSub = _db.collection('foods').snapshots().listen(
        (snap) {
          final foods = <Food>[];
          final ingredients = <String, List<String>>{};
          final deleted = <String>{};
          for (final doc in snap.docs) {
            if (doc.data()['deleted'] == true) {
              deleted.add(doc.id);
              continue;
            }
            final f = CatalogCodec.foodFromMap(doc.id, doc.data());
            if (f == null) continue;
            foods.add(f);
            final ing = CatalogCodec.ingredientsFromMap(doc.data());
            if (ing.isNotEmpty) ingredients[f.id] = ing;
          }
          MockData.applyRemoteFoods(foods, ingredients, deleted: deleted);
          _onChanged?.call();

          // Хоосон бол (анхны удаа) тогооч нэвтэрсэн үед үрлэнэ.
          if (snap.docs.isEmpty) seedIfEmpty();
        },
        onError: (Object e) => debugPrint('Foods stream алдаа: $e'),
      );

      _restaurantsSub = _db.collection('restaurants').snapshots().listen(
        (snap) {
          final list = <Restaurant>[];
          for (final doc in snap.docs) {
            final r = CatalogCodec.restaurantFromMap(doc.id, doc.data());
            if (r != null) list.add(r);
          }
          MockData.applyRemoteRestaurants(list);
          _onChanged?.call();
        },
        onError: (Object e) => debugPrint('Restaurants stream алдаа: $e'),
      );
    } catch (e) {
      debugPrint('CatalogService эхлүүлэхэд алдаа: $e');
    }
  }

  void stop() {
    _foodsSub?.cancel();
    _restaurantsSub?.cancel();
  }

  /// foods коллекц хоосон бөгөөд нэвтэрсэн хэрэглэгч тогооч бол
  /// MockData-ын жишээ хоол, рестораныг Firestore руу нэг удаа хуулна.
  Future<void> seedIfEmpty() async {
    if (_seeding) return;
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    _seeding = true;

    try {
      final profile = await AuthService.instance.loadProfile();
      if (profile.role != UserRole.chef) return;

      final existing = await _db.collection('foods').limit(1).get();
      if (existing.docs.isNotEmpty) return;

      final batch = _db.batch();
      for (final r in MockData.seedRestaurants) {
        batch.set(
          _db.collection('restaurants').doc(r.id),
          CatalogCodec.restaurantToMap(r),
        );
      }
      for (final f in MockData.foods) {
        batch.set(
          _db.collection('foods').doc(f.id),
          CatalogCodec.foodToMap(f),
        );
      }
      await batch.commit();
      debugPrint('✅ Анхны хоол, ресторан Firestore руу хуулагдлаа.');
    } catch (e) {
      debugPrint('Seed алдаа: $e');
    } finally {
      _seeding = false;
    }
  }

  /// Тогоочийн шинэ хоолыг хадгална.
  Future<void> saveFood(Food food, {List<String>? ingredients}) {
    return _db.collection('foods').doc(food.id).set(
          CatalogCodec.foodToMap(food, ingredients: ingredients),
        );
  }

  /// Хоолыг устгана (soft delete: `deleted: true`). Анхны жишээ хоол Firestore-д
  /// байхгүй байсан ч дахин гарч ирэхгүй байхын тулд баримтыг устгахгүй, тэмдэглэнэ.
  Future<void> hideFood(String id, String restaurantId) {
    return _db.collection('foods').doc(id).set(
      {'deleted': true, 'restaurantId': restaurantId},
      SetOptions(merge: true),
    );
  }
}
