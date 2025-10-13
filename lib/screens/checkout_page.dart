// In lib/screens/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/models/cart_item_model.dart';
import 'package:store/models/address_model.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/screens/add_address_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with SingleTickerProviderStateMixin {
  final CartService _cartService = CartService();
  List<CartItemModel> _cartItems = [];
  bool _isLoading = true;
  bool _isProcessingPayment = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late List<AddressModel> _userAddresses;
  AddressModel? _selectedAddress;
  
  double _subtotal = 0;
  final double _shippingFee = 2.500;

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();

    MyFatoorahFlutter.instance.init(
      'rLtt6JWvbU-wNJBlEK-BB_gSAc_wL-dQzVsq7MCTeP1_kaLFeJB0bA92G5NioM7qrONj5bTksLmafbq0A0LIKcwU_fL4a1gSt4dYFVVPVGP-CMAaGb6d3o8G4C6mMuiQz0jAZ7LDEF_rI9y9VlkCliH3PJj_9go_N_1ISGpmbu5Cdx_ug0WxE_26z21upG2_N0G_p4B2DRTAcc_Gk7GDU6_pL8gJzVp9p4VlL8N1jMAA-g6_2rE1s3a_b3y3a_p', // TODO: Replace with your actual API token
      MFCountry.KUWAIT,
      MFEnvironment.TEST,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;
    _userAddresses = [
      AddressModel(id: '1', name: loc.home, details: loc.homeAddressDetails, governorate: ''),
      AddressModel(id: '2', name: loc.work, details: loc.workAddressDetails, governorate: ''),
    ];
    _selectedAddress ??= _userAddresses.isNotEmpty ? _userAddresses.first : null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCheckoutData() async {
    final items = await _cartService.getCartItems();
    double sum = items.fold(0, (prev, item) => prev + (item.product.price * item.quantity));
    if(mounted) {
      setState(() {
        _cartItems = items;
        _subtotal = sum;
        _isLoading = false;
      });
    }
  }

  Future<void> _handlePayment() async {
    final loc = AppLocalizations.of(context)!;
    if (_selectedAddress == null) {
      _showSnackBar(loc.pleaseSelectShippingAddress, Icons.location_off, Colors.orange);
      return;
    }
    
    setState(() => _isProcessingPayment = true);

    double total = _subtotal + _shippingFee;

    var request = MFExecutePaymentRequest(
      invoiceValue: total,
      paymentMethodId: 1, // KNET
    );

    try {
      // --- START OF FIX ---
      // The executePayment function expects 3 positional arguments, not named ones.
      final response = await MyFatoorahFlutter.instance.executePayment(
        request, // 1st argument: The payment request
        'https://www.success.com', // 2nd argument: Success URL
        (invoiceId) { // 3rd argument: Failure callback
          // This callback is triggered by MyFatoorah on failure (e.g., user cancellation)
          _showErrorDialog(loc.paymentFailed, "${loc.invoiceNumber}: $invoiceId");
        },
      );
      
      // After the await, we handle the successful response
      final status = response.invoiceStatus?.toString().toLowerCase() ?? '';
      if (status.contains('paid')) {
        _showSuccessDialog(loc.paymentSuccessful, '${loc.invoiceNumber}: ${response.invoiceId}');
      } else {
        // This part might be reached if the payment is pending or has another status
        _showErrorDialog(loc.paymentFailed, loc.paymentNotConfirmed);
      }
      // --- END OF FIX ---
    } catch (e) {
      _showErrorDialog(loc.errorOccurred, e.toString());
    } finally {
       if (mounted) {
         setState(() => _isProcessingPayment = false);
       }
    }
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessDialog(String title, String message) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 64),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(loc.great, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline, color: Colors.red.shade600, size: 64),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(loc.ok, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressSelector() {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.selectShippingAddress,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._userAddresses.map((address) => _buildAddressCard(address)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAddressPage()));
                },
                icon: const Icon(Icons.add),
                label: Text(loc.addNewAddress),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    final isSelected = _selectedAddress?.id == address.id;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedAddress = address);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.location_on_outlined,
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue.shade800 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.details,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(loc.checkout, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressSection(),
                    const SizedBox(height: 16),
                    _buildOrderSummarySection(),
                    const SizedBox(height: 16),
                    _buildPriceDetailsSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  Widget _buildAddressSection() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.local_shipping, color: Colors.blue.shade600),
                ),
                const SizedBox(width: 12),
                Text(
                  loc.shippingAddress,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on, color: Colors.green.shade600, size: 24),
            ),
            title: Text(
              _selectedAddress?.name ?? loc.noAddressSelected,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _selectedAddress?.details ?? loc.pleaseAddOrSelectAddress,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            trailing: TextButton(
              onPressed: _showAddressSelector,
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(loc.change, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.shopping_bag, color: Colors.purple.shade600),
                ),
                const SizedBox(width: 12),
                Text(
                  loc.orderSummary,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    loc.productsCount(_cartItems.length),
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cartItems.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.product.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${loc.quantity}: ${item.quantity}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(item.product.price * item.quantity).toStringAsFixed(3)} ${loc.currency}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsSection() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _priceRow(loc.subtotal, '${_subtotal.toStringAsFixed(3)} ${loc.currency}', isWhite: true),
            const SizedBox(height: 12),
            _priceRow(loc.shippingFee, '${_shippingFee.toStringAsFixed(3)} ${loc.currency}', isWhite: true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withAlpha(26),
                      Colors.white.withAlpha(128),
                      Colors.white.withAlpha(26),
                    ],
                  ),
                ),
              ),
            ),
            _priceRow(
              loc.totalAmount,
              '${(_subtotal + _shippingFee).toStringAsFixed(3)} ${loc.currency}',
              isTotal: true,
              isWhite: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, String amount, {bool isTotal = false, bool isWhite = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 20 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
      color: isWhite ? Colors.white : Colors.black87,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(amount, style: style.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    if (_cartItems.isEmpty) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isProcessingPayment
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade700],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withAlpha(102),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handlePayment,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            loc.completePayment,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}