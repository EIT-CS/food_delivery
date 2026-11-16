import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FieldValue, FirebaseFirestore, Timestamp;

import '../data/models.dart';

/// Хэрэглэгч ↔ хүргэгчийн чат (Firestore: orders/{orderId}/messages/{id}).
/// Зөвхөн тухайн захиалгын хэрэглэгч болон түүнийг авсан хүргэгч уншиж бичнэ.
class ChatService {
  ChatService._();

  static final ChatService instance = ChatService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String orderId) =>
      _db.collection('orders').doc(orderId).collection('messages');

  static String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}';
  }

  Stream<List<ChatMessage>> watch(String orderId, String myUid) {
    return _col(orderId).snapshots().map((snap) {
      final rows = <(DateTime, ChatMessage)>[];
      for (final d in snap.docs) {
        final m = d.data();
        final ts = m['createdAt'];
        final at = ts is Timestamp ? ts.toDate() : DateTime.now();
        rows.add((
          at,
          ChatMessage(
            text: m['text'] as String? ?? '',
            fromMe: m['senderId'] == myUid,
            time: _time(at),
          ),
        ));
      }
      rows.sort((a, b) => a.$1.compareTo(b.$1));
      return [for (final r in rows) r.$2];
    });
  }

  Future<void> send({
    required String orderId,
    required String senderId,
    required String text,
  }) {
    return _col(orderId).add({
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
