// In lib/screens/orders_page.dart
import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['جاري التنفيذ', 'مكتمل', 'ملغي'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('active'),
          _buildOrdersList('completed'),
          _buildOrdersList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual orders count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رقم الطلب: #${1000 + index}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(status),
                  ],
                ),
                const Divider(height: 24),
                const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 8),
                    Text('تاريخ الطلب: 11 أكتوبر 2025'),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('عدد المنتجات: 3'),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.attach_money, size: 16),
                    SizedBox(width: 8),
                    Text('المبلغ الإجمالي: 150.00 EGP'),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('تفاصيل الطلب'),
                      onPressed: () {
                        // Navigate to order details
                      },
                    ),
                    if (status == 'active')
                      TextButton.icon(
                        icon: const Icon(Icons.cancel_outlined,
                            color: Colors.red),
                        label: const Text('إلغاء الطلب',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          // Show cancel confirmation dialog
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = AppColors.accentTeal;
        label = 'جاري التنفيذ';
        break;
      case 'completed':
        color = Colors.green;
        label = 'مكتمل';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'ملغي';
        break;
      default:
        color = Colors.grey;
        label = 'غير معروف';
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}
