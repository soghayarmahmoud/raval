// In lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:store/screens/main_screen.dart';
import 'package:store/screens/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/services/google_auth_service.dart';
import 'package:store/services/apple_auth_service.dart';
import 'package:store/utils/auth_errors.dart';
import 'package:store/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final AppleAuthService _appleAuthService = AppleAuthService();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Validate inputs first
        final emailError = _authService.validateEmail(_emailController.text);
        final passwordError =
            _authService.validatePassword(_passwordController.text);

        if (emailError != null) {
          throw FirebaseAuthException(code: emailError);
        }
        if (passwordError != null) {
          throw FirebaseAuthException(code: passwordError);
        }

        // Attempt login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save login state
        await _authService.saveUserSession(
          _emailController.text.split('@')[0], // Basic username from email
          '', // Phone can be updated in profile
        );

        if (!mounted) return;
        // If LoginPage was pushed (e.g., from checkout flow), return true to caller.
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthErrors.getLocalizedErrorMessage(e.code))),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AuthErrors.getLocalizedErrorMessage('default'))),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userCredential = await _googleAuthService.signInWithGoogle();
      if (userCredential != null) {
        // Save session with Google user info
        final googleUser = userCredential.user;
        if (googleUser != null) {
          await _authService.saveUserSession(
            googleUser.displayName ?? '',
            googleUser.phoneNumber ?? '',
          );
        }

        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        throw FirebaseAuthException(code: 'google-sign-in-cancelled');
      }
    } catch (e) {
      if (!mounted) return;
      final errorCode = (e is FirebaseAuthException) ? e.code : 'default';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthErrors.getLocalizedErrorMessage(errorCode))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userCredential = await _appleAuthService.signInWithApple();
      if (userCredential != null) {
        // Save session with Apple user info
        final appleUser = userCredential.user;
        if (appleUser != null) {
          await _authService.saveUserSession(
            appleUser.displayName ?? '',
            appleUser.phoneNumber ?? '',
          );
        }

        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        throw FirebaseAuthException(code: 'apple-sign-in-failed');
      }
    } catch (e) {
      if (!mounted) return;
      final errorCode =
          (e is FirebaseAuthException) ? e.code : 'apple-sign-in-failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthErrors.getLocalizedErrorMessage(errorCode))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.login)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم تسجيل الدخول التقليدي
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: loc.email_hint,
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                        helperText: 'مثال: name@example.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        final emailError = _authService.validateEmail(value);
                        if (emailError != null) {
                          return AuthErrors.getLocalizedErrorMessage(
                              emailError);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: loc.password_hint,
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                        helperText: 'على الأقل 6 أحرف',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة السر';
                        }
                        final passwordError =
                            _authService.validatePassword(value);
                        if (passwordError != null) {
                          return AuthErrors.getLocalizedErrorMessage(
                              passwordError);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            child: Text(loc.login,
                                style: const TextStyle(fontSize: 18)),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildDivider(), // --- الفاصل ---
              const SizedBox(height: 24),

              // --- قسم الدخول عبر الشبكات الاجتماعية ---
              _buildSocialLoginButton(
                iconPath: 'assets/icons/google.png', // تأكد من إضافة هذه الصورة
                label: loc.google_sign_in,
                onPressed: _signInWithGoogle,
              ),
              const SizedBox(height: 16),
              _buildSocialLoginButton(
                iconPath: 'assets/icons/apple.png', // تأكد من إضافة هذه الصورة
                label: loc.apple_sign_in,
                isDarkMode: Theme.of(context).brightness == Brightness.dark,
                onPressed: _signInWithApple,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.signup),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => const SignUpPage())),
                    child: Text(loc.signup),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ويدجتس مساعدة للتصميم العصري ---

Widget _buildDivider() {
  return const Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Text('أو', style: TextStyle(color: Colors.grey)),
      ),
      Expanded(child: Divider()),
    ],
  );
}

Widget _buildSocialLoginButton({
  required String iconPath,
  required String label,
  required VoidCallback onPressed,
  bool isDarkMode = false,
}) {
  return OutlinedButton.icon(
    icon: Image.asset(iconPath, height: 24.0),
    label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: isDarkMode ? Colors.white : Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
