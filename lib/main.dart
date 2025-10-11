import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/favorites_provider.dart';
import 'package:store/providers/locale_provider.dart';
import 'package:store/providers/theme_provider.dart';
import 'package:store/providers/dynamic_text_provider.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/screens/splash_screen.dart';
import 'package:store/screens/login_page.dart';
import 'package:store/screens/main_screen.dart';
import 'package:store/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/firebase_options.dart';
import 'package:store/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
            create: (_) => DynamicTextProvider()..loadContent()),
        Provider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Raval',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AnimatedSplashScreen();
        }
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const LoginPage();
      },
    );
  }
}
