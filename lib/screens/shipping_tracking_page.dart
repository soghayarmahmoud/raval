// In lib/screens/shipping_tracking_page.dart
import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/theme.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ShippingTrackingPage extends StatelessWidget {
  const ShippingTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.trackShipment),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfo(context),
            const SizedBox(height: 24),
            _buildTrackingTimeline(context),
            const SizedBox(height: 24),
            _buildDeliveryDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.trackingNumber,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'EG123456789',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryPink,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.local_shipping_outlined),
                SizedBox(width: 8),
                Text(loc.shippingCompanyAramex),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  '${loc.estimatedDelivery}: ${_getEstimatedDeliveryTime()}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final trackingSteps = [
      {
        'title': loc.orderConfirmed,
        'time': '9:30 ص',
        'date': '11 أكتوبر 2025',
        'isCompleted': true,
      },
      {
        'title': loc.orderReceivedFromStore,
        'time': '2:15 م',
        'date': '11 أكتوبر 2025',
        'isCompleted': true,
      },
      {
        'title': loc.orderAtSortingCenter,
        'time': '6:45 م',
        'date': '11 أكتوبر 2025',
        'isCompleted': true,
      },
      {
        'title': loc.outForDelivery,
        'time': '10:30 ص',
        'date': '12 أكتوبر 2025',
        'isCompleted': false,
      },
      {
        'title': loc.delivered,
        'time': '-',
        'date': '-',
        'isCompleted': false,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.trackShipment,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trackingSteps.length,
              itemBuilder: (context, index) {
                final step = trackingSteps[index];
                return TimelineTile(
                  isFirst: index == 0,
                  isLast: index == trackingSteps.length - 1,
                  beforeLineStyle: LineStyle(
                    color: step['isCompleted'] as bool
                        ? AppColors.primaryPink
                        : Colors.grey.shade300,
                  ),
                  indicatorStyle: IndicatorStyle(
                    width: 24,
                    color: step['isCompleted'] as bool
                        ? AppColors.primaryPink
                        : Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    iconStyle: IconStyle(
                      color: Colors.white,
                      iconData: step['isCompleted'] as bool
                          ? Icons.check
                          : Icons.circle,
                    ),
                  ),
                  endChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: step['isCompleted'] as bool
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${step['time']} - ${step['date']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDetails(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.deliveryDetails,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person_outline,
              title: loc.recipient,
              value: loc.recipientName,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.phone_outlined,
              title: loc.phoneNumber,
              value: loc.recipientPhoneNumber,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.location_on_outlined,
              title: loc.deliveryAddress,
              value: loc.recipientAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _getEstimatedDeliveryTime() {
  final now = DateTime.now();
  final estimatedDelivery = now.add(const Duration(days: 2));
  return '${estimatedDelivery.day}/${estimatedDelivery.month}/${estimatedDelivery.year}';
}
