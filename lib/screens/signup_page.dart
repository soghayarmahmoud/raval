// In lib/screens/signup_page.dart
import 'package:flutter/material.dart';
import 'package:store/screens/login_page.dart'; // استيراد صفحة تسجيل الدخول
import 'package:store/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController(); // <-- حقل جديد
  final _passwordController = TextEditingController(); // <-- حقل جديد
  final _confirmPasswordController = TextEditingController(); // <-- حقل جديد
  final AuthService _authService = AuthService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // TODO: هنا سيتم إرسال كل هذه البيانات إلى قاعدة البيانات (مثل Firestore)
      
      // حاليًا، سنستمر في استخدام AuthService القديم بشكل مؤقت
      await _authService.signUp(
        _nameController.text,
        _phoneController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب بنجاح!')),
        );
        // نرسل true لنعرف أن التسجيل نجح وننتقل للخطوة التالية (مثل الدفع أو تحديد الموقع)
        Navigator.pop(context, true); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال الاسم' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال رقم الهاتف' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'البريد الإلكتروني', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || !value.contains('@')) ? 'أدخل بريدًا إلكترونيًا صحيحًا' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة السر', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.length < 6) ? 'كلمة السر يجب أن تكون 6 أحرف على الأقل' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'تأكيد كلمة السر', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة السر';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمتا السر غير متطابقتين';
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
                  child: const Text('إنشاء الحساب', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                      onPressed: () {
                        // الانتقال لصفحة تسجيل الدخول
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('سجل الدخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}