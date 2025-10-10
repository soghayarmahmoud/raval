// In lib/screens/signup_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    if (!_formKey.currentState!.validate()) {
      return; // إذا لم تكن البيانات صحيحة، لا تكمل
    }
    
    setState(() => _isLoading = true);

    try {
      // 1. إنشاء المستخدم في Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. تحديث اسم المستخدم (DisplayName)
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      // TODO: 3. حفظ البيانات الإضافية (مثل رقم الهاتف) في Firestore
      // await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      //   'name': _nameController.text.trim(),
      //   'email': _emailController.text.trim(),
      //   'phone': _phoneController.text.trim(),
      // });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب بنجاح!'), backgroundColor: Colors.green),
        );
        // العودة للصفحة السابقة وإرسال إشارة نجاح
        Navigator.pop(context, true);
      }

    } on FirebaseAuthException catch (e) {
      // التعامل مع أخطاء Firebase الشائعة
      String message = 'حدث خطأ ما.';
      if (e.code == 'weak-password') {
        message = 'كلمة السر ضعيفة جدًا.';
      } else if (e.code == 'email-already-in-use') {
        message = 'هذا البريد الإلكتروني مستخدم بالفعل.';
      }
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // التعامل مع أي أخطاء أخرى
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إنشاء الحساب: ${e.toString()}'), backgroundColor: Colors.red),
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
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
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
                  TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? 'الحقل مطلوب' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder()), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? 'الحقل مطلوب' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? 'بريد غير صحيح' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة السر', border: OutlineInputBorder()), validator: (v) => (v == null || v.length < 6) ? 'كلمة السر قصيرة جدًا' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'تأكيد كلمة السر', border: OutlineInputBorder()), validator: (v) => v != _passwordController.text ? 'كلمتا السر غير متطابقتين' : null),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: _isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white,))
                      : const Text('إنشاء الحساب', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),
            _buildSocialLoginButton(
              iconPath: 'assets/icons/google.png',
              label: 'المتابعة باستخدام Google',
              onPressed: () { /* TODO: Implement Google Sign-Up */ },
            ),
            const SizedBox(height: 16),
            _buildSocialLoginButton(
              iconPath: 'assets/icons/apple.png',
              label: 'المتابعة باستخدام Apple',
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
              onPressed: () { /* TODO: Implement Apple Sign-Up */ },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('لديك حساب بالفعل؟'),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginPage())),
                  child: const Text('سجل الدخول'),
                ),
              ],
            ),
          ],
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
      side: BorderSide(color: Colors.grey.shade300),
    ),
  );
}