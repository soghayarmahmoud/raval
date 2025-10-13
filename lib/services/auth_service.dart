// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  // Keys for saving user data locally
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userNameKey = 'userName';
  static const String _userPhoneKey = 'userPhone';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to listen for authentication state changes throughout the app
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Verify password strength
  String? validatePassword(String password) {
    if (password.length < 6) {
      return 'weak-password';
    }
    return null;
  }

  // Verify email format
  String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'invalid-email';
    }
    return null;
  }

  // Complete sign-out from the app
  Future<void> signOut() async {
    try {
      // 1. Sign out from Google first (if the user was signed in with it)
      await _googleSignIn.signOut();

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
    // Prefer server-side auth state when available
    final user = _auth.currentUser;
    if (user != null) return true;

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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint('Error during Apple Sign-In: $e');
      rethrow;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }
}
