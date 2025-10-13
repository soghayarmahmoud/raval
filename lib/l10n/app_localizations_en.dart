// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Our Store';

  @override
  String get cartPageTitle => 'Shopping Cart';

  @override
  String get checkoutButtonText => 'Proceed to Checkout';

  @override
  String get addAddressTitle => 'Add New Address';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get governorate => 'Governorate';

  @override
  String get addressDetails => 'Address Details';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get addresses => 'Saved Addresses';

  @override
  String get noAddresses => 'No saved addresses';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get deleteAddress => 'Delete Address';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteAddressConfirm =>
      'Are you sure you want to delete this address?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get cancel => 'Cancel';

  @override
  String get add_to_cart => 'Add to cart';

  @override
  String get added_to_cart => 'Added to cart';

  @override
  String get buy_now => 'Buy Now';

  @override
  String get available_colors => 'Available colors';

  @override
  String get available_sizes => 'Available sizes';

  @override
  String get description => 'Description';

  @override
  String get additional_info => 'Additional information';

  @override
  String get quantity => 'Quantity';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign up';

  @override
  String get email_hint => 'Email';

  @override
  String get password_hint => 'Password';

  @override
  String get google_sign_in => 'Continue with Google';

  @override
  String get apple_sign_in => 'Continue with Apple';

  @override
  String get myOrders => 'My Orders';

  @override
  String get trackShipment => 'Track Shipment';

  @override
  String get favorites => 'Favorites';

  @override
  String get branchAddresses => 'Branch Addresses';

  @override
  String get profile => 'Profile';

  @override
  String get supportAndHelp => 'Support & Help';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get loginPrompt => 'Log in or create an account for full access';

  @override
  String get sendTestNotification => 'Send Test Notification';

  @override
  String get supportChat => 'Support Chat';

  @override
  String get faq => 'FAQ';

  @override
  String get newArrivals => 'New Arrivals';

  @override
  String get bestOffers => 'Best Offers';

  @override
  String get category_all => 'All';

  @override
  String get category_girls => 'Girls';

  @override
  String get category_boys => 'Boys';

  @override
  String get category_baby => 'Baby';

  @override
  String get category_sales => 'Sales';

  @override
  String addedXToCart(String productName) {
    return '$productName has been added to the cart';
  }

  @override
  String totalPrice(int itemCount) {
    return 'Total ($itemCount products)';
  }

  @override
  String get checkout => 'Checkout';

  @override
  String get shippingAddress => 'Shipping Address';

  @override
  String get noAddressSelected => 'No address selected';

  @override
  String get change => 'Change';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String productsCount(int count) {
    return '$count products';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shippingFee => 'Shipping Fee';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get completePayment => 'Complete Payment';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get selectFromMap => 'Select from Map';

  @override
  String get addressNameHint => 'Address Name (e.g., Home, Work)';

  @override
  String get addressDetailsHint => 'Address details (street, block, house...)';

  @override
  String get selectGovernorate => 'Select a governorate';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get addBranch => 'Add New Branch';

  @override
  String get selectYourGovernorate => 'Select your governorate';

  @override
  String noBranchesIn(String governorateName) {
    return 'No branches found in $governorateName';
  }

  @override
  String get openMap => 'Open Map';

  @override
  String get call => 'Call';

  @override
  String get filters => 'Filters';

  @override
  String get priceKWD => 'Price (KWD)';

  @override
  String get color => 'Color';

  @override
  String get size => 'Size';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get noProductsMatchFilters => 'No products match these filters';

  @override
  String get favoritesListIsEmpty => 'Favorites list is empty';

  @override
  String get addToFavoritesHint =>
      'Add products you love by tapping the heart icon';

  @override
  String get searchInFAQ => 'Search in FAQ...';

  @override
  String get all => 'All';

  @override
  String get or => 'Or';

  @override
  String get haveAnAccount => 'Already have an account?';

  @override
  String get activeOrders => 'Active';

  @override
  String get completedOrders => 'Completed';

  @override
  String get cancelledOrders => 'Cancelled';

  @override
  String orderNumber(String number) {
    return 'Order No: $number';
  }

  @override
  String orderDate(String date) {
    return 'Order Date: $date';
  }

  @override
  String productsNo(int count) {
    return 'No. of Products: $count';
  }

  @override
  String totalPriceValue(String price) {
    return 'Total Price: $price KWD';
  }

  @override
  String get orderDetails => 'Order Details';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get trackingNumber => 'Tracking Number';

  @override
  String get shippingCompany => 'Shipping Company';

  @override
  String get estimatedDelivery => 'Estimated Delivery';

  @override
  String get recipient => 'Recipient';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get customerService => 'Customer Service';

  @override
  String get endConversation => 'End Conversation';

  @override
  String get endConversationConfirm =>
      'Are you sure you want to end the conversation?';

  @override
  String get end => 'End';

  @override
  String get startConversationHint =>
      'Start your conversation with customer service';

  @override
  String get writeYourMessage => 'Write your message here...';

  @override
  String get allowLocationAccess => 'Allow Location Access';

  @override
  String get locationAccessReason =>
      'We need access to your location to determine your address accurately. Please enable location services from the app settings.';

  @override
  String get ok => 'OK';

  @override
  String get locationError =>
      'An error occurred while determining your location. Please try again.';

  @override
  String get mainAddress => 'Main Address';

  @override
  String get locationSetOnMap => 'Location set on map';

  @override
  String get notSet => 'Not Set';

  @override
  String get addressSavedSuccess => 'Address saved successfully';

  @override
  String get addressSaveError =>
      'An error occurred while saving the address. Please try again.';

  @override
  String get addAddressToContinue => 'You must add an address to continue';

  @override
  String get enterAddressDetails => 'Enter address details';

  @override
  String get governorateAlAsimah => 'Al Asimah';

  @override
  String get governorateHawalli => 'Hawalli';

  @override
  String get governorateFarwaniya => 'Farwaniya';

  @override
  String get governorateAhmadi => 'Ahmadi';

  @override
  String get governorateMubarakAlKabeer => 'Mubarak Al-Kabeer';

  @override
  String get governorateJahra => 'Jahra';

  @override
  String get currency => 'KWD';

  @override
  String get cartIsEmpty => 'Your cart is empty';

  @override
  String get home => 'Home';

  @override
  String get work => 'Work';

  @override
  String get pleaseSelectShippingAddress => 'Please select a shipping address';

  @override
  String get paymentFailed => 'Payment Failed';

  @override
  String get invoiceNumber => 'Invoice Number';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String get paymentNotConfirmed => 'Payment not confirmed';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get great => 'Great!';

  @override
  String get selectShippingAddress => 'Select Shipping Address';

  @override
  String get pleaseAddOrSelectAddress => 'Please add or select an address';

  @override
  String get homeAddressDetails => 'Hawalli, Block 5, Street 10, House 15';

  @override
  String get workAddressDetails => 'Kuwait City, Commerce Tower, 20th Floor';

  @override
  String get confirmAddress => 'Confirm Address';

  @override
  String get errorLoadingAddresses => 'Error loading addresses';

  @override
  String get retry => 'Retry';

  @override
  String get noAddressAdded => 'No address added';

  @override
  String get pleaseAddAddressToContinue => 'Please add an address to continue';

  @override
  String get select => 'Select';

  @override
  String get unknown => 'Unknown';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorWhite => 'White';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorGreen => 'Green';

  @override
  String get searchForYourFavoriteProducts =>
      'Search for your favorite products...';

  @override
  String get shippingCompanyAramex => 'Shipping Company: Aramex';

  @override
  String get orderConfirmed => 'Order Confirmed';

  @override
  String get orderReceivedFromStore => 'Order received from store';

  @override
  String get orderAtSortingCenter => 'Order at sorting center';

  @override
  String get outForDelivery => 'Out for delivery';

  @override
  String get delivered => 'Delivered';

  @override
  String get deliveryDetails => 'Delivery Details';

  @override
  String get recipientName => 'Mohamed Ahmed';

  @override
  String get recipientPhoneNumber => '+20 123 456 7890';

  @override
  String get recipientAddress => '123 Street, Maadi, Cairo';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordTooShort => 'Password is too short';

  @override
  String get createAccount => 'Create Account';

  @override
  String get loginNow => 'Login now';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get weakPassword => 'The password is too weak.';

  @override
  String get emailAlreadyInUse => 'This email is already in use.';

  @override
  String get failedToCreateAccount => 'Failed to create account: ';

  @override
  String get appName => 'RAVAL';

  @override
  String get governorateCairo => 'Cairo';

  @override
  String get governorateAlexandria => 'Alexandria';

  @override
  String get governorateGiza => 'Giza';

  @override
  String get governorateMansoura => 'Mansoura';

  @override
  String get loginToAddBranch => 'You must be logged in to add a new branch';

  @override
  String get branchName => 'Branch Name';

  @override
  String get address => 'Address';

  @override
  String get workingHours => 'Working Hours';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get branchAddedSuccessfully => 'Branch added successfully';

  @override
  String get error => 'Error: ';

  @override
  String get add => 'Add';

  @override
  String get couldNotOpenMap => 'Could not open the map';

  @override
  String get couldNotMakeCall => 'Could not make the call';

  @override
  String get faqCategoryGeneral => 'General';

  @override
  String get faqCategoryOrders => 'Orders';

  @override
  String get faqCategoryShipping => 'Shipping';

  @override
  String get faqCategoryPayment => 'Payment';

  @override
  String get faqCategoryOther => 'Other';

  @override
  String mockQuestion(int index) {
    return 'Mock Question $index?';
  }

  @override
  String mockAnswer(int index) {
    return 'This is a mock answer for question $index. It provides details and solutions related to the question.';
  }

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get springDress => 'Spring Girls Dress';

  @override
  String get springDressDescription =>
      'A wonderful girls dress made of the finest cotton, suitable for spring and autumn. Elegant design with bright colors.';

  @override
  String get girls => 'Girls';

  @override
  String get dresses => 'Dresses';

  @override
  String get spring => 'Spring';

  @override
  String get materials => 'Materials';

  @override
  String get cotton => 'Cotton';

  @override
  String get season => 'Season';

  @override
  String get springAutumn => 'Spring/Autumn';

  @override
  String get style => 'Style';

  @override
  String get casual => 'Casual';

  @override
  String get boysSummerSet => 'Boys Summer Set';

  @override
  String get boysSummerSetDescription =>
      'A distinctive boys set suitable for the summer season, comfortable cotton material and bright colors';

  @override
  String get boys => 'Boys';

  @override
  String get summer => 'Summer';

  @override
  String get sport => 'Sport';

  @override
  String get winterJacket => 'Winter Jacket';

  @override
  String get winterJacketDescription =>
      'A warm winter jacket suitable for the winter season, with a modern design and excellent material';

  @override
  String get winter => 'Winter';

  @override
  String get woolAndPolyester => 'Wool and Polyester';

  @override
  String get lining => 'Lining';

  @override
  String get lined => 'Lined';

  @override
  String get emailExample => 'Example: name@example.com';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get atLeast6Chars => 'At least 6 characters';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get errorSendingMessage => 'Error sending message';

  @override
  String get sentAnImage => '📷 Sent an image';

  @override
  String get errorSendingImage => 'Error sending image';

  @override
  String get errorLoadingChat => 'Error loading chat';

  @override
  String get noInternetConnection =>
      'Please check your internet connection and try again.';
}
