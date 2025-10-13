// In lib/screens/branches_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/theme.dart';
import 'package:store/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';


class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  final LocationService _locationService = LocationService();
  String? _selectedGovernorate;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _hoursController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _addNewBranch() async {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.loginToAddBranch),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.addBranch),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: loc.branchName),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: loc.address),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: loc.phoneNumber),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _hoursController,
                decoration: InputDecoration(labelText: loc.workingHours),
              ),
              TextField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: loc.latitude),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: loc.longitude),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final newBranch = BranchLocation(
                  name: _nameController.text,
                  address: _addressController.text,
                  phone: _phoneController.text,
                  workingHours: _hoursController.text,
                  latitude: double.parse(_latitudeController.text),
                  longitude: double.parse(_longitudeController.text),
                  governorate: _selectedGovernorate!,
                  isCustom: true,
                  userId: user.uid,
                );

                await _locationService.addBranch(newBranch);
                
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.branchAddedSuccessfully)),
                );

                _nameController.clear();
                _addressController.clear();
                _phoneController.clear();
                _hoursController.clear();
                _latitudeController.clear();
                _longitudeController.clear();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${loc.error}${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(loc.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<String> _governorates = [loc.governorateCairo, loc.governorateAlexandria, loc.governorateGiza, loc.governorateMansoura];
    if (_selectedGovernorate == null) {
      _selectedGovernorate = _governorates.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.branchAddresses),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            onPressed: _addNewBranch,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGovernorateSelector(_governorates),
          Expanded(
            child: StreamBuilder<List<BranchLocation>>(
              stream: _locationService.getBranchesByGovernorate(_selectedGovernorate!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${loc.error}${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final branches = snapshot.data ?? [];
                return _buildBranchesList(branches);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernorateSelector(List<String> _governorates) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGovernorate,
        decoration: InputDecoration(
          labelText: loc.selectGovernorate,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: _governorates
            .map((gov) => DropdownMenuItem(value: gov, child: Text(gov)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedGovernorate = value);
          }
        },
      ),
    );
  }

  Widget _buildBranchesList(List<BranchLocation> branches) {
    final loc = AppLocalizations.of(context)!;
    if (branches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_mall_directory_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              loc.noBranchesIn(_selectedGovernorate!),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = branches[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.store, color: AppColors.primaryPink),
                    const SizedBox(width: 8),
                    Text(
                      branch.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.location_on_outlined, branch.address),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone_outlined, branch.phone,
                    isPhone: true),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time_outlined, branch.workingHours),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.map_outlined),
                        label: Text(loc.openMap),
                        onPressed: () => _openMap(branch),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.phone),
                        label: Text(loc.call),
                        onPressed: () => _makePhoneCall(branch.phone),
                      ),
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

  Widget _buildInfoRow(IconData icon, String text, {bool isPhone = false}) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: isPhone
              ? TextButton(
                  onPressed: () => _makePhoneCall(text),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight,
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.primaryPink,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(text),
        ),
      ],
    );
  }

  Future<void> _openMap(BranchLocation branch) async {
    final loc = AppLocalizations.of(context)!;
    final url =
        'https://www.google.com/maps/search/?api=1&query=${branch.latitude},${branch.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.couldNotOpenMap)),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final loc = AppLocalizations.of(context)!;
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.couldNotMakeCall)),
      );
    }
  }
}
