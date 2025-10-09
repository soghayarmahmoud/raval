import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:store/providers/favorites_provider.dart'; 
import 'package:store/providers/theme_provider.dart';
import 'package:store/screens/splash_screen.dart';
import 'theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // <-- أضف هذا
      ],
      child: const MyApp(),
    ),
  );
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

      locale: const Locale('ar', ''),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), 
        Locale('en', ''), 
      ],

      home: const AnimatedSplashScreen(),
    );
  }
}