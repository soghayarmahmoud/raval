import 'package:flutter/material.dart';
import 'package:store/screens/splash_screen.dart';
import 'theme.dart';
// In lib/main.dart
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- أضف هذا السطر
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raval Kids Wears',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,

      // --- ابدأ الإضافة من هنا لجعل التطبيق يدعم العربية ---
      locale: const Locale('ar', ''), // تحديد اللغة الافتراضية للتطبيق
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // اللغة العربية
        Locale('en', ''), // اللغة الإنجليزية
      ],
      // --- نهاية الإضافة ---

      home: const AnimatedSplashScreen(),
    );
  }
}