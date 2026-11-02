class Validators {
  Validators._();

  static String? required(String? v, [String field = 'Энэ талбар']) {
    if (v == null || v.trim().isEmpty) return '$field хоосон байна';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'И-мэйл хаягаа оруулна уу';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'И-мэйл хаяг буруу байна';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Нууц үгээ оруулна уу';
    if (v.length < 6) return 'Нууц үг хамгийн багадаа 6 тэмдэгт байна';
    return null;
  }
}
