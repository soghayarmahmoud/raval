import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:store/theme.dart'; // استيراد الثيم للوصول إلى الألوان

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // بيانات مؤقتة للبانر الإعلاني - استبدلها لاحقًا ببيانات حقيقية
  final List<String> bannerImages = const [
    'https://via.placeholder.com/600x300/D71E61/FFFFFF?text=New+Arrivals',
    'https://via.placeholder.com/600x300/FDB813/000000?text=Sale+50%25',
    'https://via.placeholder.com/600x300/00828F/FFFFFF?text=Winter+Collection',
  ];

  // بيانات مؤقتة للأقسام - استبدلها لاحقًا ببيانات حقيقية
  final List<Map<String, String>> categories = const [
    {'name': 'بناتي', 'image': 'https://via.placeholder.com/150/FFC0CB/000000?text=Girls'},
    {'name': 'ولادي', 'image': 'https://via.placeholder.com/150/ADD8E6/000000?text=Boys'},
    {'name': 'شتوي', 'image': 'https://via.placeholder.com/150/B0C4DE/000000?text=Winter'},
    {'name': 'صيفي', 'image': 'https://via.placeholder.com/150/FFFF00/000000?text=Summer'},
    {'name': 'بيبي', 'image': 'https://via.placeholder.com/150/E6E6FA/000000?text=Baby'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RAVAL',
          style: TextStyle(fontFamily: 'Exo2', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. البانر الإعلاني المتحرك ---
            CarouselSlider.builder(
              itemCount: bannerImages.length,
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(bannerImages[index], fit: BoxFit.cover),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.85,
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. عنوان قسم "الأقسام" ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'الأقسام',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // --- 3. قائمة الأقسام الأفقية ---
            SizedBox(
              height: 120, // ارتفاع محدد للقائمة الأفقية
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    categoryName: categories[index]['name']!,
                    imageUrl: categories[index]['image']!,
                    onTap: () {
                      // يمكنك هنا إضافة منطق الانتقال لصفحة القسم عند الضغط عليه
                      print('${categories[index]['name']} tapped');
                    },
                  );
                },
              ),
            ),
             // يمكنك إضافة المزيد من الويدجتس هنا مثل "الأكثر مبيعًا" أو "وصل حديثًا"
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- ويدجت مخصصة لعرض كارت القسم لسهولة إعادة الاستخدام ---
class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            // صورة القسم
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // اسم القسم
            Text(
              categoryName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}