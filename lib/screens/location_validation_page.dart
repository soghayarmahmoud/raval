import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../services/address_service.dart';
import 'add_address_page.dart';
import 'checkout_page.dart';

class LocationValidationPage extends StatelessWidget {
  const LocationValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressService addressService = AddressService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد العنوان'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<AddressModel>>(
        future: addressService.getAddresses().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('حدث خطأ أثناء تحميل العناوين'),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LocationValidationPage()),
                    ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final addresses = snapshot.data ?? [];

          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'لم يتم إضافة أي عنوان',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يرجى إضافة عنوان للمتابعة',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AddAddressPage(isRequired: true),
                        ),
                      );
                      if (result == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CheckoutPage()),
                        );
                      }
                    },
                    icon: const Icon(Icons.add_location),
                    label: const Text('إضافة عنوان جديد'),
                  ),
                ],
              ),
            );
          }

          // If we have addresses, show them and allow selection
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(address.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address.governorate),
                            Text(address.details),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CheckoutPage()),
                            );
                          },
                          child: const Text('اختيار'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (_) => const AddAddressPage()),
                    );
                    if (result == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LocationValidationPage()),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة عنوان جديد'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
