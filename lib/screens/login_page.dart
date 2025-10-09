// In lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:store/screens/signup_page.dart';
// ملاحظة: سنحتاج لتطوير AuthService لاحقًا ليدعم تسجيل الدخول الفعلي

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final AuthService _authService = AuthService(); // سنستخدمه لاحقًا

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: هنا سيتم إضافة منطق التحقق من المستخدم أمام قاعدة البيانات
      // حاليًا، سنقوم فقط بطباعة البيانات المدخلة
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري التحقق من البيانات... (محاكاة)')),
      );

      // بعد التحقق الناجح، يمكنك الانتقال للصفحة الرئيسية أو صفحة الدفع
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // يمكنك إضافة شعار التطبيق هنا
                // Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'الرجاء إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // لإخفاء كلمة السر
                  decoration: const InputDecoration(
                    labelText: 'كلمة السر',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة السر';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟'),
                    TextButton(
                      onPressed: () {
                        // الانتقال لصفحة إنشاء حساب
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text('أنشئ حسابًا الآن'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}