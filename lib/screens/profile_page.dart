// In lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/locale_provider.dart';
import 'package:store/providers/theme_provider.dart';
import 'package:store/screens/add_address_page.dart';
import 'package:store/services/notification_service.dart';
import 'package:store/theme.dart';

// موديلات لتنظيم البيانات (لتسهيل الربط مع الداشبورد مستقبلاً)
class ServiceBoxModel {
  final String title;
  final IconData icon;
  final Color color;
  ServiceBoxModel({required this.title, required this.icon, required this.color});
}

class AddressModel {
  final String id;
  final String name; // e.g., "المنزل", "العمل"
  final String details;
  AddressModel({required this.id, required this.name, required this.details});
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الخدمات (يمكنك جلب هذه القائمة من Firestore في المستقبل)
    final List<ServiceBoxModel> services = [
      ServiceBoxModel(title: 'طلباتي', icon: Icons.shopping_bag_outlined, color: AppColors.primaryPink),
      ServiceBoxModel(title: 'تتبع الشحنة', icon: Icons.local_shipping_outlined, color: AppColors.accentTeal),
      ServiceBoxModel(title: 'المفضلة', icon: Icons.favorite_border, color: AppColors.accentYellow),
      ServiceBoxModel(title: 'عناوين الفروع', icon: Icons.store_mall_directory_outlined, color: AppColors.accentPurple),
    ];
    
    // قائمة عناوين مؤقتة (سيتم جلبها من Firestore)
    final List<AddressModel> userAddresses = [
       AddressModel(id: '1', name: 'المنزل', details: 'حولي، قطعة 5، شارع 10، منزل 15'),
       AddressModel(id: '2', name: 'العمل', details: 'مدينة الكويت، برج التجارية، الدور 20'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الحساب الشخصي'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- قسم معلومات المستخدم ---
              _buildUserInfo(context),
              const SizedBox(height: 16),

              // --- قسم الخدمات السريعة ---
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceBox(
                    title: service.title,
                    icon: service.icon,
                    color: service.color,
                    onTap: () {
                      // TODO: Add navigation logic for each service
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // --- قسم العناوين ---
              _buildSectionTitle('العناوين المحفوظة'),
              _buildAddressesSection(context, userAddresses),
              const SizedBox(height: 24),

              // --- قسم الإعدادات ---
              _buildSectionTitle('الإعدادات'),
              _buildSettingsMenu(context),
              const SizedBox(height: 24),

              // --- قسم الدعم ---
              _buildSectionTitle('الدعم والمساعدة'),
              _buildSupportMenu(context),
              const SizedBox(height: 32),

              // --- قسم روابط السوشيال ميديا ---
              _buildSocialMediaLinks(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 30),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "مرحباً، اسم العميل", // TODO: Fetch real name from Firebase
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "client.email@example.com", // TODO: Fetch real email
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesSection(BuildContext context, List<AddressModel> addresses) {
    return Column(
      children: [
        if (addresses.isEmpty)
          const Text("لا توجد عناوين محفوظة.")
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(address.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(address.details),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) { /* TODO: Handle edit/delete logic */ },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(value: 'edit', child: Text('تعديل')),
                      const PopupMenuItem<String>(value: 'delete', child: Text('حذف')),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('إضافة عنوان جديد'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AddAddressPage()));
          },
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
        )
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
  
  Widget _buildSettingsMenu(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('اللغة'),
            trailing: Text(localeProvider.locale.languageCode == 'ar' ? 'العربية' : 'English'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('العربية'),
                      onTap: () {
                        localeProvider.setLocale(const Locale('ar'));
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: const Text('English'),
                      onTap: () {
                        localeProvider.setLocale(const Locale('en'));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('الثيم'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('اختر الثيم'),
                  content: Consumer<ThemeProvider>(
                    builder: (context, provider, child) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<ThemeMode>(
                          title: const Text('فاتح'),
                          value: ThemeMode.light,
                          groupValue: provider.themeMode,
                          onChanged: (value) {
                            if (value != null) provider.setThemeMode(value);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('داكن'),
                          value: ThemeMode.dark,
                          groupValue: provider.themeMode,
                          onChanged: (value) {
                            if (value != null) provider.setThemeMode(value);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('افتراضي للنظام'),
                          value: ThemeMode.system,
                          groupValue: provider.themeMode,
                          onChanged: (value) {
                            if (value != null) provider.setThemeMode(value);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Send Test Notification'),
            onTap: () {
              NotificationService().sendTestNotification();
            },
          );
            },
          ),
          
        ],
      ),
    );
  }

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

  Widget _buildSocialMediaLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.facebook, size: 30)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt, size: 30)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline, size: 30)),
      ],
    );
  }
}