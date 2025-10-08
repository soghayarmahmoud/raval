import 'package:flutter/material.dart';
import 'package:store/screens/splash_screen.dart';
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

      home: const AnimatedSplashScreen(), // <-- اجعلها الشاشة الرئيسية
    );
  }
}