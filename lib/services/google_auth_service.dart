// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:store/services/google_auth_service.dart';

// class GoogleAuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
//       if (googleUser == null) return null; // The user canceled the sign-in

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Once signed in, return the UserCredential
//       return await FirebaseAuth.instance.signInWithCredential(credential);
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await FirebaseAuth.instance.signOut();
//     } catch (e) {
//       print('Error signing out: $e');
//     }
//   }
// }

// class standard {
// }

// extension on GoogleSignInAuthentication {
//   String? get accessToken => null;
// }
