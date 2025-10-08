// In lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:store/screens/cart_page.dart';
import 'package:store/screens/favorites_page.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/profile_page.dart';
import 'package:store/screens/search_page.dart';
import 'package:store/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // الصفحة الرئيسية هي الصفحة الافتراضية

  // قائمة الصفحات التي سيتم التنقل بينها
  static const List<Widget> _pages = <Widget>[
    SearchPage(),
    FavoritesPage(),
    HomePage(), // الصفحة الرئيسية ستكون في المنتصف لكن ترتيبها هنا لا يهم
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // عرض الصفحة المختارة
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // زر الـ Home المميز في المنتصف
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2), // 2 هو index الخاص بـ HomePage
        backgroundColor: AppColors.primaryPink,
        child: const Icon(Icons.home, color: Colors.white),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // شريط التنقل السفلي
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // لعمل "فتحة" للزر العائم
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () => _onItemTapped(0)),
            IconButton(icon: Icon(Icons.favorite_border), onPressed: () => _onItemTapped(1)),
            const SizedBox(width: 40), // مساحة فارغة مكان الزر العائم
            IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: () => _onItemTapped(3)),
            IconButton(icon: Icon(Icons.person_outline), onPressed: () => _onItemTapped(4)),
          ],
        ),
      ),
    );
  }
}