/// Нэвтэрсэн хэрэглэгчийн дүр.
enum UserRole { customer, chef }

/// Жишиг бүртгэлүүд. Жинхэнэ апп-д энэ нь сервер (backend)-ээс ирнэ.
class Accounts {
  Accounts._();

  /// Тогоочийн имэйлүүд. Эдгээрээр нэвтэрвэл Chef талд орно.
  static const Set<String> chefEmails = {
    'chef@food.mn',
    'chef@gmail.com',
  };

  /// Демо нэвтрэлтэд харуулах тогоочийн имэйл.
  static const String demoChefEmail = 'chef@food.mn';

  static UserRole roleOf(String email) =>
      chefEmails.contains(email.trim().toLowerCase())
          ? UserRole.chef
          : UserRole.customer;
}
