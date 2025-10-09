// In lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/theme_provider.dart';
import 'package:store/theme.dart';

// موديل بسيط لتنظيم بيانات الصناديق (لتسهيل الربط مع الداشبورد مستقبلاً)
class ServiceBoxModel {
  final String title;
  final IconData icon;
  final Color color;

  ServiceBoxModel({required this.title, required this.icon, required this.color});
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الخدمات (يمكنك جلب هذه القائمة من Firestore في المستقبل)
    final List<ServiceBoxModel> services = [
      ServiceBoxModel(title: 'طلباتي', icon: Icons.shopping_bag_outlined, color: AppColors.primaryPink),
      ServiceBoxModel(title: 'تتبع الشحنة', icon: Icons.local_shipping_outlined, color: AppColors.accentTeal),
      ServiceBoxModel(title: 'العناوين', icon: Icons.location_on_outlined, color: AppColors.accentPurple),
      ServiceBoxModel(title: 'المفضلة', icon: Icons.favorite_border, color: AppColors.accentYellow),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('القائمة'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- قسم الخدمات ---
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceBox(
                    title: service.title,
                    icon: service.icon,
                    color: service.color,
                    onTap: () {},
                  );
                },
              ),
              const SizedBox(height: 24),

              // --- قسم الإعدادات ---
              _buildSectionTitle('الإعدادات'),
              _buildSettingsMenu(context),
              const SizedBox(height: 24),
              
              // --- قسم أقرب متجر ---
              _buildSectionTitle('أقرب متجر'),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.store_mall_directory_outlined, color: Theme.of(context).primaryColor),
                  title: const Text('اسم المتجر هنا - يفتح حتى 10م'), // سيتم جلبه من الداشبورد
                  subtitle: const Text('العنوان التفصيلي للمتجر...'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: فتح الخريطة لموقع المتجر
                  },
                ),
              ),
              const SizedBox(height: 24),


              // --- قسم الدعم ---
              _buildSectionTitle('الدعم والمساعدة'),
              _buildSupportMenu(context),
              const SizedBox(height: 32),

              // --- قسم روابط السوشيال ميديا ---
              _buildSocialMediaLinks(),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء الصناديق المضيئة
  Widget _buildServiceBox({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // خلفية بلون خفيف
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2), // بوردر بنفس اللون
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4), // ظل مضيء بنفس اللون
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color), // أيقونة بنفس اللون
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color, // نص بنفس اللون
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  // ويدجت لقائمة الإعدادات
  Widget _buildSettingsMenu(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('اللغة'),
            trailing: const Text('العربية'), // يمكن تعديلها لاحقًا
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('الثيم'),
            onTap: () {
              // إظهار نافذة اختيار الثيم
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('اختر الثيم'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('فاتح'),
                        value: ThemeMode.light,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          if(value != null) themeProvider.setThemeMode(value);
                          Navigator.of(context).pop();
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('داكن'),
                        value: ThemeMode.dark,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                          if(value != null) themeProvider.setThemeMode(value);
                           Navigator.of(context).pop();
                        },
                      ),
                       RadioListTile<ThemeMode>(
                        title: const Text('افتراضي للنظام'),
                        value: ThemeMode.system,
                        groupValue: themeProvider.themeMode,
                        onChanged: (value) {
                           if(value != null) themeProvider.setThemeMode(value);
                           Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ويدجت لقائمة الدعم
  Widget _buildSupportMenu(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('تواصل مع خدمة العملاء'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('الأسئلة الشائعة'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ويدجت لروابط السوشيال ميديا
  Widget _buildSocialMediaLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.facebook, size: 30)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt, size: 30)), // Placeholder for Instagram
        IconButton(onPressed: (){}, icon: const Icon(Icons.chat_bubble_outline, size: 30)), // Placeholder for a chat app
      ],
    );
  }
}