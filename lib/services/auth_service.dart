// In lib/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userNameKey = 'userName';
  static const String _userPhoneKey = 'userPhone';

  // التحقق مما إذا كان المستخدم قد سجل الدخول من قبل
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // حفظ بيانات المستخدم بعد إنشاء الحساب
  Future<void> signUp(String name, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userPhoneKey, phone);
  }

  // جلب اسم المستخدم المحفوظ
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // تسجيل الخروج (للمستقبل)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // حذف كل البيانات المحفوظة
  }
}