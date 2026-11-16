import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FirebaseException, FirebaseFirestore, SetOptions;
import 'package:firebase_auth/firebase_auth.dart';

import '../data/accounts.dart';
import 'geo_service.dart';

/// Дэлгэц дээр шууд харуулах монгол алдааны мессеж агуулсан алдаа.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Нэвтэрсэн хэрэглэгчийн мэдээлэл (Firebase Auth + Firestore `users/{uid}`).
class AuthProfile {
  const AuthProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.photo,
    this.restaurantId,
    this.phone,
    this.vehicle,
  });

  final String uid;
  final String name;
  final String email;
  final UserRole role;

  /// Профайл зураг (base64) эсвэл null.
  final String? photo;

  /// Тогоочийн ресторан (restaurants/{id}). Хэрэглэгчид null.
  final String? restaurantId;

  /// Хүргэгчийн утас, тээврийн хэрэгсэл (бусад дүрд null).
  final String? phone;
  final String? vehicle;
}

/// Firebase Authentication + Firestore-той ажилладаг цорын ганц газар.
///
/// Firestore бүтэц:  users/{uid} → { name, email, role, createdAt }
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  /// true бол имэйлээ баталгаажуулаагүй хэрэглэгчийг оруулахгүй.
  /// Хөгжүүлэлтийн үед түр false болгож болно.
  static const bool requireEmailVerification = true;

  static const int resendCooldownSeconds = 30;

  DateTime? _verificationSentAt;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Firebase эхлээгүй (алдаа гарсан) үед ч апп унахгүй.
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  bool get isVerified {
    final user = currentUser;
    if (user == null) return false;
    return !requireEmailVerification || user.emailVerified;
  }

  /// Баталгаажуулах имэйлийг дахин илгээхээс өмнө үлдсэн секунд.
  int get resendWaitSeconds {
    final sent = _verificationSentAt;
    if (sent == null) return 0;
    final left =
        resendCooldownSeconds - DateTime.now().difference(sent).inSeconds;
    return left > 0 ? left : 0;
  }

  // ------------------------------------------------------------------
  // Бүртгүүлэх
  // ------------------------------------------------------------------
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? restaurantName,
    String? cuisine,
    String? phone,
    String? vehicle,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      await user.updateDisplayName(name.trim());

      // Дүр (customer / chef) болон нэрийг Firestore-д хадгална.
      // Тогооч бол өөрийн рестораны ID-г хамт хадгална.
      final restaurantId = role == UserRole.chef ? 'rest_${user.uid}' : null;
      try {
        await _db.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'role': role.name,
          if (restaurantId != null) 'restaurantId': restaurantId,
          if (role == UserRole.courier) ...{
            'phone': (phone ?? '').trim(),
            'vehicle': (vehicle ?? '').trim(),
          },
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Тогоочийн ресторан (users баримт үүссэний дараа бичнэ: Rules шалгана).
        if (restaurantId != null) {
          final p = GeoService.pointForText(user.uid);
          final rName = (restaurantName ?? '').trim();
          await _db.collection('restaurants').doc(restaurantId).set({
            'name': rName.isEmpty ? '${name.trim()}-ийн ресторан' : rName,
            'cuisine': (cuisine ?? '').trim(),
            'rating': 4.5,
            'minutes': 25,
            'icon': 'restaurant',
            'color': 0xFFE9A96B,
            'lat': p.latitude,
            'lng': p.longitude,
            'ownerId': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      } on FirebaseException catch (e) {
        throw AuthException(_firestoreMessage(e));
      }

      if (requireEmailVerification) {
        await user.sendEmailVerification();
        _verificationSentAt = DateTime.now();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  // ------------------------------------------------------------------
  // Нэвтрэх / гарах
  // ------------------------------------------------------------------
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // Гарах үед алдаа гарсан ч апп талд гарсан гэж тооцно.
    }
  }

  // ------------------------------------------------------------------
  // Нууц үг сэргээх
  // ------------------------------------------------------------------
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  // ------------------------------------------------------------------
  // Имэйл баталгаажуулалт
  // ------------------------------------------------------------------
  Future<void> resendVerification() async {
    final user = currentUser;
    if (user == null) throw const AuthException('Нэвтрээгүй байна');
    try {
      await user.sendEmailVerification();
      _verificationSentAt = DateTime.now();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  /// Хэрэглэгчийн мэдээллийг серверээс дахин уншиж, баталгаажсан эсэхийг буцаана.
  Future<bool> refreshVerified() async {
    final user = currentUser;
    if (user == null) return false;
    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
    return isVerified;
  }

  // ------------------------------------------------------------------
  // Профайл (дүр)
  // ------------------------------------------------------------------
  Future<AuthProfile> loadProfile() async {
    final user = currentUser;
    if (user == null) throw const AuthException('Нэвтрээгүй байна');

    final email = (user.email ?? '').trim();
    String? name;
    String? photo;
    String? restaurantId;
    String? phone;
    String? vehicle;
    UserRole? role;

    try {
      final snap = await _db.collection('users').doc(user.uid).get();
      final data = snap.data();
      if (data != null) {
        name = data['name'] as String?;
        role = UserRole.values.asNameMap()[data['role']];
        photo = data['photo'] as String?;
        restaurantId = data['restaurantId'] as String?;
        phone = data['phone'] as String?;
        vehicle = data['vehicle'] as String?;
      }
    } catch (_) {
      // Firestore-оос уншиж чадаагүй бол доорх нөөц утгыг ашиглана.
    }

    role ??= Accounts.roleOf(email);
    name ??= user.displayName;
    if (name == null || name.trim().isEmpty) {
      name = email.contains('@') ? email.split('@').first : 'Хэрэглэгч';
    }
    return AuthProfile(
      uid: user.uid,
      name: name,
      email: email,
      role: role,
      photo: photo,
      restaurantId: restaurantId,
      phone: phone,
      vehicle: vehicle,
    );
  }

  /// Профайл зургийг Firestore-д (users/{uid}.photo) хадгална. null бол устгана.
  Future<void> savePhoto(String? base64Photo) async {
    final user = currentUser;
    if (user == null) throw const AuthException('Нэвтрээгүй байна');
    try {
      await _db.collection('users').doc(user.uid).set(
        {'photo': base64Photo ?? FieldValue.delete()},
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw AuthException(_firestoreMessage(e));
    }
  }

  // ------------------------------------------------------------------
  // Алдааны мессежүүд (монголоор)
  // ------------------------------------------------------------------
  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'И-мэйл хаяг буруу байна';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'И-мэйл эсвэл нууц үг буруу байна';
      case 'email-already-in-use':
        return 'Энэ и-мэйл хаяг аль хэдийн бүртгэлтэй байна';
      case 'weak-password':
        return 'Нууц үг хэт сул байна (хамгийн багадаа 6 тэмдэгт)';
      case 'user-disabled':
        return 'Энэ бүртгэлийг түр хаасан байна';
      case 'too-many-requests':
        return 'Хэт олон оролдлоо. Хэсэг хүлээгээд дахин оролдоно уу';
      case 'network-request-failed':
        return 'Интернет холболтоо шалгана уу';
      case 'operation-not-allowed':
        return 'Firebase дээр Email/Password нэвтрэлт идэвхжээгүй байна';
      case 'requires-recent-login':
        return 'Аюулгүй байдлын үүднээс дахин нэвтэрч орно уу';
      default:
        return 'Алдаа гарлаа (${e.code}). Дахин оролдоно уу';
    }
  }

  String _firestoreMessage(FirebaseException e) {
    if (e.code == 'permission-denied') {
      return 'Өгөгдлийн санд бичих эрх алга (Firestore Rules-ийг шалгана уу)';
    }
    return 'Өгөгдлийн сангийн алдаа (${e.code})';
  }
}
