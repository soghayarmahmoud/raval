import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:store/l10n/app_localizations.dart';
import '../models/address_model.dart';
import '../services/address_service.dart';

class AddAddressPage extends StatefulWidget {
  final bool isRequired;
  const AddAddressPage({super.key, this.isRequired = false});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AddressService _addressService = AddressService();

  // Form variables
  final _formKey = GlobalKey<FormState>();
  String? _selectedGovernorate;
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();

  // Map variables
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(29.3759, 47.9774); // Kuwait center
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) {
        // Show a dialog explaining why location is needed
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.allowLocationAccess),
            content: Text(AppLocalizations.of(context)!.locationAccessReason),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentCenter, 15.0);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.locationError)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAddress() async {
    if (_tabController.index == 0) {
      // Manual entry validation
      if (!_formKey.currentState!.validate()) return;
    }

    setState(() => _isLoading = true);

    try {
      final newAddress = AddressModel(
        id: '', // Will be set by Firestore
        name: _nameController.text.isEmpty
            ? AppLocalizations.of(context)!.mainAddress
            : _nameController.text,
        details: _tabController.index == 0
            ? _detailsController.text
            : AppLocalizations.of(context)!.locationSetOnMap,
        governorate: _selectedGovernorate ?? AppLocalizations.of(context)!.notSet,
        latitude: _currentCenter.latitude,
        longitude: _currentCenter.longitude,
      );

      await _addressService.addAddress(newAddress);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addressSavedSuccess)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.addressSaveError)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<String> _kuwaitGovernorates = [
      localizations.governorateAlAsimah,
      localizations.governorateHawalli,
      localizations.governorateFarwaniya,
      localizations.governorateAhmadi,
      localizations.governorateMubarakAlKabeer,
      localizations.governorateJahra
    ];

    return WillPopScope(
      onWillPop: () async {
        if (widget.isRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.addAddressToContinue)),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.addAddressTitle),
          automaticallyImplyLeading: !widget.isRequired,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.edit), text: localizations.manualEntry),
              Tab(icon: Icon(Icons.map_outlined), text: localizations.selectFromMap),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  // Manual Entry Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: localizations.addressNameHint,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: localizations.governorate,
                              border: OutlineInputBorder(),
                            ),
                            initialValue: _selectedGovernorate,
                            items: _kuwaitGovernorates
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedGovernorate = value),
                            validator: (value) =>
                                value == null ? localizations.selectGovernorate : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _detailsController,
                            decoration: InputDecoration(
                              labelText: localizations.addressDetailsHint,
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? localizations.enterAddressDetails
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Map Tab
                  Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentCenter,
                          initialZoom: 13.0,
                          onTap: (tapPosition, point) {
                            setState(() => _currentCenter = point);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentCenter,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: _getCurrentLocation,
                          child: const Icon(Icons.my_location),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveAddress,
          label: Text(localizations.saveAddress),
          icon: const Icon(Icons.save),
        ),
      ),
    );
  }
}
