// In lib/screens/signup_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/screens/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _submitForm() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.accountCreatedSuccessfully), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }

    } on FirebaseAuthException catch (e) {
      String message = loc.somethingWentWrong;
      if (e.code == 'weak-password') {
        message = loc.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        message = loc.emailAlreadyInUse;
      }
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.failedToCreateAccount}${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.createNewAccount)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(controller: _nameController, decoration: InputDecoration(labelText: loc.fullName, border: OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? loc.fieldRequired : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _phoneController, decoration: InputDecoration(labelText: loc.phoneNumber, border: OutlineInputBorder()), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? loc.fieldRequired : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _emailController, decoration: InputDecoration(labelText: loc.email_hint, border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? loc.invalidEmail : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: loc.password_hint, border: OutlineInputBorder()), validator: (v) => (v == null || v.length < 6) ? loc.passwordTooShort : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _confirmPasswordController, obscureText: true, decoration: InputDecoration(labelText: loc.confirmPassword, border: OutlineInputBorder()), validator: (v) => v != _passwordController.text ? loc.passwordsDoNotMatch : null),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: _isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white,))
                      : Text(loc.createAccount, style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDivider(context),
            const SizedBox(height: 24),
            _buildSocialLoginButton(
              iconPath: 'assets/icons/google.png',
              label: loc.google_sign_in,
              onPressed: () { /* TODO: Implement Google Sign-Up */ },
            ),
            const SizedBox(height: 16),
            _buildSocialLoginButton(
              iconPath: 'assets/icons/apple.png',
              label: loc.apple_sign_in,
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
              onPressed: () { /* TODO: Implement Apple Sign-Up */ },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loc.haveAnAccount),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginPage())),
                  child: Text(loc.login),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDivider(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  return Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(loc.or, style: TextStyle(color: Colors.grey)),
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
      side: BorderSide(color: Colors.grey.shade300),
    ),
  );
}