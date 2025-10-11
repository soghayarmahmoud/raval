import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class GoogleAuthService {
  // Access the singleton instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize Google Sign In (call this once when app starts)
  Future<void> initialize({String? serverClientId}) async {
    await _googleSignIn.initialize(
      serverClientId: serverClientId, // Optional: for backend verification
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Step 1: Authenticate the user (this shows the Google sign-in UI)
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      // User canceled the sign-in
      if (googleUser == null) return null;

      // Step 2: Get authentication tokens (use dynamic to avoid tight typing issues)
      final googleAuth = await googleUser.authentication;
      final accessToken = (googleAuth as dynamic).accessToken as String?;
      final idToken = (googleAuth as dynamic).idToken as String?;

      // Step 3: Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Step 4: Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      developer.log('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      developer.log('Error signing out: $e');
      rethrow;
    }
  }

  // Disconnect user completely (revokes access)
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (e) {
      developer.log('Error disconnecting: $e');
      rethrow;
    }
  }

  // Check if user is currently signed in
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
