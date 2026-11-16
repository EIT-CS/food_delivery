import 'package:cloud_firestore/cloud_firestore.dart'
    show
        FieldValue,
        FirebaseFirestore,
        SetOptions,
        Timestamp;

import '../data/models.dart';

/// Хэрэглэгчийн хувийн тохиргоо (хаяг, дуртай, амт) болон нийтийн
/// сэтгэгдлийг Firestore-д хадгалах үйлдлүүд.
///
/// Бүтэц:
///   users/{uid}/prefs/main  → { addresses, selectedAddress, favFoods,
///                               favRestaurants, tastes }   (зөвхөн эзэмшигч)
///   reviews/{id}            → { foodId, authorId, author, rating, text,
///                               photos, createdAt }        (хүн бүр уншина)
class UserDataService {
  UserDataService._();

  static final UserDataService instance = UserDataService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // ---------------- Тохиргоо ----------------
  Future<Map<String, dynamic>?> loadPrefs(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('prefs')
        .doc('main')
        .get();
    return snap.data();
  }

  Future<void> savePrefs(String uid, Map<String, dynamic> data) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('prefs')
        .doc('main')
        .set(data, SetOptions(merge: false));
  }

  // ---------------- Сэтгэгдэл ----------------
  static String _dateLabel(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}/${two(d.month)}/${two(d.day)}';
  }

  /// Бүх сэтгэгдэл (realtime). `mine` нь authorId == uid эсэхээр тодорно.
  Stream<List<Review>> watchReviews(String uid) {
    return _db.collection('reviews').snapshots().map((snap) {
      final rows = <_Row>[];
      for (final d in snap.docs) {
        try {
          final m = d.data();
          final ts = m['createdAt'];
          final at = ts is Timestamp ? ts.toDate() : DateTime.now();
          rows.add(_Row(
            at,
            Review(
              id: d.id,
              foodId: m['foodId'] as String,
              author: m['author'] as String? ?? 'Хэрэглэгч',
              rating: (m['rating'] as num).toInt(),
              text: m['text'] as String? ?? '',
              date: ts is Timestamp ? _dateLabel(at) : 'Дөнгөж сая',
              photos: (m['photos'] as num?)?.toInt() ?? 0,
              mine: m['authorId'] == uid,
            ),
          ));
        } catch (_) {
          // Буруу бүтэцтэй баримтыг алгасна.
        }
      }
      rows.sort((a, b) => b.at.compareTo(a.at));
      return [for (final r in rows) r.review];
    });
  }

  Future<void> addReview({
    required String uid,
    required String author,
    required String foodId,
    required int rating,
    required String text,
    int photos = 0,
  }) {
    return _db.collection('reviews').add({
      'foodId': foodId,
      'authorId': uid,
      'author': author,
      'rating': rating,
      'text': text,
      'photos': photos,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class _Row {
  _Row(this.at, this.review);
  final DateTime at;
  final Review review;
}
