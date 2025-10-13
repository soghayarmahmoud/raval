// In lib/screens/orders_page.dart
// ignore_for_file: deprecated_member_use

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final List<String> _tabs = [loc.activeOrders, loc.completedOrders, loc.cancelledOrders];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myOrders),
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
    final loc = AppLocalizations.of(context)!;
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
                      loc.orderNumber((1000 + index).toString()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(status),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 8),
                    Text(loc.orderDate("11 October 2025")),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 16),
                    SizedBox(width: 8),
                    Text(loc.productsNo(3)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16),
                    SizedBox(width: 8),
                    Text(loc.totalPriceValue("150.00")),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.visibility_outlined),
                      label: Text(loc.orderDetails),
                      onPressed: () {
                        // Navigate to order details
                      },
                    ),
                    if (status == 'active')
                      TextButton.icon(
                        icon: const Icon(Icons.cancel_outlined,
                            color: Colors.red),
                        label: Text(loc.cancelOrder,
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
    final loc = AppLocalizations.of(context)!;
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = AppColors.accentTeal;
        label = loc.activeOrders;
        break;
      case 'completed':
        color = Colors.green;
        label = loc.completedOrders;
        break;
      case 'cancelled':
        color = Colors.red;
        label = loc.cancelledOrders;
        break;
      default:
        color = Colors.grey;
        label = loc.unknown;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}
