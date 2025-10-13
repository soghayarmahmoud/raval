import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/models/address_model.dart';
import 'package:store/providers/locale_provider.dart';
import 'package:store/providers/theme_provider.dart';
import 'package:store/screens/add_address_page.dart';
import 'package:store/screens/branches_page.dart';
import 'package:store/screens/favorites_page.dart';
import 'package:store/screens/login_page.dart';
import 'package:store/screens/orders_page.dart';
import 'package:store/screens/shipping_tracking_page.dart';
import 'package:store/screens/signup_page.dart';
import 'package:store/screens/support_chat_page.dart';
import 'package:store/screens/faq_page.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/services/address_service.dart';
import 'package:store/services/notification_service.dart';
import 'package:store/theme.dart';

// موديل لتنظيم بيانات صناديق الخدمات
class ServiceBoxModel {
  final String title;
  final IconData icon;
  final Color color;
  ServiceBoxModel(
      {required this.title, required this.icon, required this.color});
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final localizations = AppLocalizations.of(context)!;

    final List<ServiceBoxModel> services = [
      ServiceBoxModel(
          title: localizations.myOrders,
          icon: Icons.shopping_bag_outlined,
          color: AppColors.primaryPink),
      ServiceBoxModel(
          title: localizations.trackShipment,
          icon: Icons.local_shipping_outlined,
          color: AppColors.accentTeal),
      ServiceBoxModel(
          title: localizations.favorites,
          icon: Icons.favorite_border,
          color: AppColors.accentYellow),
      ServiceBoxModel(
          title: localizations.branchAddresses,
          icon: Icons.store_mall_directory_outlined,
          color: AppColors.accentPurple),
    ];

    // قائمة عناوين مؤقتة (سيتم جلبها من Firestore في المستقبل)
    final List<AddressModel> userAddresses = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
      ),
      body: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          // عرض مؤشر تحميل أثناء انتظار البيانات
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bool isLoggedIn = snapshot.hasData;
          final User? user = snapshot.data;

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- قسم معلومات المستخدم (يعرض واجهة مختلفة حسب حالة الدخول) ---
                  if (isLoggedIn)
                    _buildLoggedInUserInfo(context, user!, authService)
                  else
                    _buildGuestUserInfo(context),

                  const SizedBox(height: 16),

                  // --- باقي الأقسام تظهر للجميع ---
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          switch (index) {
                            case 0: // Orders
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
                              break;
                            case 1: // Shipping
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingTrackingPage()));
                              break;
                            case 2: // Favorites
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
                              break;
                            case 3: // Branches
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BranchesPage()));
                              break;
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // قسم العناوين يظهر فقط للمستخدم المسجل
                  if (isLoggedIn) ...[
                    _buildSectionTitle(localizations.addresses),
                    _buildAddressesSection(context, userAddresses),
                    const SizedBox(height: 24),
                  ],

                  _buildSectionTitle(localizations.settings),
                  _buildSettingsMenu(context),
                  const SizedBox(height: 24),

                  _buildSectionTitle(localizations.supportAndHelp),
                  _buildSupportMenu(context),
                  const SizedBox(height: 32),

                  _buildSocialMediaLinks(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- واجهة تظهر إذا كان المستخدم مسجل دخوله ---
  Widget _buildLoggedInUserInfo(
      BuildContext context, User user, AuthService authService) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? localizations.welcomeMessage,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.email != null)
                        Text(
                          user.email!,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(localizations.signup,
                    style: const TextStyle(color: Colors.red)),
                onPressed: () async {
                  await authService.signOut();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- واجهة تظهر للزائر (غير المسجل) ---
  Widget _buildGuestUserInfo(BuildContext context) {
    final authService = AuthService();
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(localizations.welcomeMessage, 
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(localizations.loginPrompt, 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const LoginPage())),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              child: Text(localizations.login, 
                  style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const SignUpPage())),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              child: Text(localizations.signup, 
                  style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final userCredential = await authService.signInWithGoogle();
                  if (userCredential?.user != null) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تسجيل الدخول بنجاح باستخدام جوجل'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('فشل تسجيل الدخول: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.g_mobiledata), // يمكنك تغيير الأيقونة
              label: Text(localizations.google_sign_in),
            ),
            const SizedBox(height: 8),
            if (Theme.of(context).platform == TargetPlatform.iOS)
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final userCredential = await authService.signInWithApple();
                    if (userCredential?.user != null) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تسجيل الدخول بنجاح باستخدام آبل'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('فشل تسجيل الدخول: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.apple),
                label: Text(localizations.apple_sign_in),
              ),
          ],
        ),
      ),
    );
  }

  // (باقي الويدجتس تبقى كما هي)
  Widget _buildServiceBox(
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.3), blurRadius: 8, spreadRadius: 0.5)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesSection(
      BuildContext context, List<AddressModel> addresses) {
    final addressService = AddressService();
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (addresses.isEmpty)
          Text(localizations.noAddresses, style: const TextStyle(fontSize: 16)),
        if (addresses.isNotEmpty)
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
                  title: Text(address.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.governorate),
                      Text(address.details),
                      if (address.latitude != null && address.longitude != null)
                        Text(
                            'Location: ${address.latitude!.toStringAsFixed(6)}, ${address.longitude!.toStringAsFixed(6)}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const AddAddressPage(
                              isRequired: false,
                            ),
                          ),
                        );
                        if (result == true) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('تم تحديث العنوان بنجاح')),
                          );
                        }
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(localizations.confirmDelete),
                            content:
                                Text(localizations.deleteAddressConfirm),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(localizations.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  localizations.deleteAddress,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await addressService.deleteAddress(address.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('تم حذف العنوان بنجاح')),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('حدث خطأ أثناء حذف العنوان'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            const SizedBox(width: 8),
                            Text(localizations.editAddress),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(localizations.deleteAddress, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: Text(localizations.addNewAddress),
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (c) => const AddAddressPage(isRequired: false),
              ),
            );
            if (result == true) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إضافة العنوان بنجاح')),
              );
            }
          },
          style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40)),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(localizations.language),
            trailing: Text(localeProvider.locale.languageCode == 'ar'
                ? 'العربية'
                : 'English'),
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
            title: Text(localizations.theme),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.theme),
                  content: Consumer<ThemeProvider>(
                    builder: (context, provider, child) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<ThemeMode>(
                          title: Text(localizations.lightTheme),
                          value: ThemeMode.light,
                          groupValue: provider.themeMode,
                          onChanged: (value) {
                            if (value != null) provider.setThemeMode(value);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text(localizations.darkTheme),
                          value: ThemeMode.dark,
                          groupValue: provider.themeMode,
                          onChanged: (value) {
                            if (value != null) provider.setThemeMode(value);
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text(localizations.systemTheme),
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
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(localizations.sendTestNotification),
            onTap: () {
              NotificationService().sendTestNotification();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportMenu(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(localizations.supportChat),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupportChatPage()),
                );
              }),
          ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(localizations.faq),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQPage()),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildSocialMediaLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.facebook, size: 30)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.camera_alt, size: 30)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, size: 30)),
      ],
    );
  }
}
