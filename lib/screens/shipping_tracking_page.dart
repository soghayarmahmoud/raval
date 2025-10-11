// In lib/screens/shipping_tracking_page.dart
import 'package:flutter/material.dart';
import 'package:store/theme.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ShippingTrackingPage extends StatelessWidget {
  const ShippingTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع الشحنة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: 24),
            _buildTrackingTimeline(context),
            const SizedBox(height: 24),
            _buildDeliveryDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم التتبع',
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
            const Row(
              children: [
                Icon(Icons.local_shipping_outlined),
                SizedBox(width: 8),
                Text('شركة الشحن: أرامكس'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  'الوقت المتوقع للتوصيل: ${_getEstimatedDeliveryTime()}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline(BuildContext context) {
    final trackingSteps = [
      {
        'title': 'تم تأكيد الطلب',
        'time': '9:30 ص',
        'date': '11 أكتوبر 2025',
        'isCompleted': true,
      },
      {
        'title': 'تم استلام الطلب من المتجر',
        'time': '2:15 م',
        'date': '11 أكتوبر 2025',
        'isCompleted': true,
      },
      {
        'title': 'الطلب في مركز الفرز',
        'time': '6:45 م',
        'date': '11 أكتوبر 2025',
        'isCompleted': true,
      },
      {
        'title': 'جاري التوصيل',
        'time': '10:30 ص',
        'date': '12 أكتوبر 2025',
        'isCompleted': false,
      },
      {
        'title': 'تم التوصيل',
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
            const Text(
              'تتبع الشحنة',
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

  Widget _buildDeliveryDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل التوصيل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person_outline,
              title: 'المستلم',
              value: 'محمد أحمد',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: '+20 123 456 7890',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.location_on_outlined,
              title: 'عنوان التوصيل',
              value: 'شارع 123، المعادي، القاهرة',
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
