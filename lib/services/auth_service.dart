// In lib/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/services/google_auth_service.dart';
import 'package:store/services/apple_auth_service.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userNameKey = 'userName';
  static const String _userPhoneKey = 'userPhone';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream للاستماع لتغيرات حالة تسجيل الدخول في كل التطبيق
  // هذا الـ Stream سيخبرنا فورًا عند تسجيل الدخول أو الخروج
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // جلب المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    final googleService = GoogleAuthService();
    return await googleService.signInWithGoogle();
  }

  // Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    final appleService = AppleAuthService();
    return await appleService.signInWithApple();
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await GoogleAuthService().signOut(); // Sign out from Google if signed in
    await AppleAuthService().signOut(); // Sign out from Apple if signed in
    await _auth.signOut(); // Sign out from Firebase
  }

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
