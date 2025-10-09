// In lib/screens/add_address_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // متغيرات للنموذج اليدوي
  final _formKey = GlobalKey<FormState>();
  String? _selectedGovernorate;
  final List<String> _kuwaitGovernorates = ['العاصمة', 'حولي', 'الفروانية', 'الأحمدي', 'مبارك الكبير', 'الجهراء'];

  // متغيرات للخريطة
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(29.3759, 47.9774); // مركز الكويت

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // ... (منطق طلب الأذونات وتحديد الموقع الحالي)
    // Position position = await Geolocator.getCurrentPosition();
    // setState(() => _currentCenter = LatLng(position.latitude, position.longitude));
    // _mapController.move(_currentCenter, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عنوان جديد'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: 'إدخال يدوي'),
            Tab(icon: Icon(Icons.map_outlined), text: 'تحديد من الخريطة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- التاب الأول: الإدخال اليدوي ---
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder()),
                    value: _selectedGovernorate,
                    items: _kuwaitGovernorates.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() => _selectedGovernorate = value),
                    validator: (value) => value == null ? 'اختر محافظة' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'عنوان الشارع، قطعة، منزل...', border: OutlineInputBorder()),
                    maxLines: 3,
                    validator: (value) => (value == null || value.isEmpty) ? 'أدخل تفاصيل العنوان' : null,
                  ),
                   const SizedBox(height: 24),
                   ElevatedButton(onPressed: (){}, child: const Text('حفظ العنوان')),
                ],
              ),
            ),
          ),
          // --- التاب الثاني: الخريطة ---
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              const Center(
                child: Icon(Icons.location_pin, size: 50, color: Colors.red),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: إذا كان في تاب الخريطة، احفظ الإحداثيات
          // إذا كان في تاب الإدخال اليدوي، احفظ البيانات
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}