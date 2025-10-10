// In lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:store/screens/signup_page.dart';
// ملاحظة: ستحتاج إلى إضافة صور الأيقونات في مجلد assets/icons/

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement login with email and password logic
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري التحقق من البيانات... (محاكاة)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
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
                      decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || !value.contains('@')) ? 'أدخل بريدًا إلكترونيًا صحيحًا' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'كلمة السر', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال كلمة السر' : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
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
                label: 'المتابعة باستخدام Google',
                onPressed: () {
                  // TODO: Implement Google Sign-In logic here
                },
              ),
              const SizedBox(height: 16),
              _buildSocialLoginButton(
                iconPath: 'assets/icons/apple.png', // تأكد من إضافة هذه الصورة
                label: 'المتابعة باستخدام Apple',
                isDarkMode: Theme.of(context).brightness == Brightness.dark,
                onPressed: () {
                  // TODO: Implement Apple Sign-In logic here
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟'),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const SignUpPage())),
                    child: const Text('أنشئ حسابًا الآن'),
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