// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Keys for saving user data locally
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userNameKey = 'userName';
  static const String _userPhoneKey = 'userPhone';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen for authentication state changes throughout the app
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Complete sign-out from the app
  Future<void> signOut() async {
    try {
      // 1. Sign out from Google first (if the user was signed in with it)
      await GoogleSignIn.instance.signOut();

      // 2. Sign out from Firebase (applies to all sign-in methods)
      await _auth.signOut();

      // 3. Clear the local session data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Print any error that might occur during sign-out
      print("Error during sign out: $e");
    }
  }

  // Check if the user was previously logged in (via local data)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Save user data to SharedPreferences after a successful sign-up/login
  Future<void> saveUserSession(String name, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userPhoneKey, phone);
  }

  // Get the saved user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }
}

