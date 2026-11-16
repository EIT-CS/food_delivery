import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FirebaseFirestore, Timestamp;

import '../data/chef_data.dart';

/// Тогоочийн мөнгө таталт (Firestore: withdrawals/{id}).
///
/// Орлого нь захиалгуудаас тооцогдоно, татсан дүн энд хадгалагдана.
/// Боломжит үлдэгдэл = орлого − нийт татсан дүн.
class WalletService {
  WalletService._();

  static final WalletService instance = WalletService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  static String _label(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}/${two(d.month)}/${two(d.day)} '
        '${two(d.hour)}:${two(d.minute)}';
  }

  /// Тогоочийн таталтууд (шинэ нь дээр, realtime).
  Stream<List<Withdrawal>> watch(String uid) {
    return _db
        .collection('withdrawals')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snap) {
      final rows = <(DateTime, Withdrawal)>[];
      for (final d in snap.docs) {
        final m = d.data();
        final ts = m['createdAt'];
        final at = ts is Timestamp ? ts.toDate() : DateTime.now();
        rows.add((
          at,
          Withdrawal(
            amount: (m['amount'] as num?)?.toInt() ?? 0,
            date: ts is Timestamp ? _label(at) : 'Дөнгөж сая',
          ),
        ));
      }
      rows.sort((a, b) => b.$1.compareTo(a.$1));
      return [for (final r in rows) r.$2];
    });
  }

  Future<void> withdraw({
    required String uid,
    required String restaurantId,
    required int amount,
  }) {
    return _db.collection('withdrawals').add({
      'ownerId': uid,
      'restaurantId': restaurantId,
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
