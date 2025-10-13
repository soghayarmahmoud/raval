import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Our Store'**
  String get appTitle;

  /// Title of the shopping cart page
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cartPageTitle;

  /// Text for the checkout button
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get checkoutButtonText;

  /// Title of the add address page
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addAddressTitle;

  /// Text for selecting location
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// Label for governorate selection
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// Label for address details
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// Button text for saving address
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme selection title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Saved addresses section title
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get addresses;

  /// Text shown when no addresses are saved
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get noAddresses;

  /// Button text for adding new address
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// Edit address option
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// Delete address option
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// Confirmation dialog title for delete
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Confirmation message for address deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddressConfirm;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Add to cart button
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get add_to_cart;

  /// Snackbar shown when item added to cart
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get added_to_cart;

  /// Buy now button text
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// Label for available colors
  ///
  /// In en, this message translates to:
  /// **'Available colors'**
  String get available_colors;

  /// Label for available sizes
  ///
  /// In en, this message translates to:
  /// **'Available sizes'**
  String get available_sizes;

  /// Label for product description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for additional info
  ///
  /// In en, this message translates to:
  /// **'Additional information'**
  String get additional_info;

  /// Label for quantity selector
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Signup text
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// Email input hint
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_hint;

  /// Password input hint
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_hint;

  /// Google sign in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get google_sign_in;

  /// Apple sign in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get apple_sign_in;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @trackShipment.
  ///
  /// In en, this message translates to:
  /// **'Track Shipment'**
  String get trackShipment;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @branchAddresses.
  ///
  /// In en, this message translates to:
  /// **'Branch Addresses'**
  String get branchAddresses;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @supportAndHelp.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportAndHelp;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeMessage;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Log in or create an account for full access'**
  String get loginPrompt;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get sendTestNotification;

  /// No description provided for @supportChat.
  ///
  /// In en, this message translates to:
  /// **'Support Chat'**
  String get supportChat;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @newArrivals.
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get newArrivals;

  /// No description provided for @bestOffers.
  ///
  /// In en, this message translates to:
  /// **'Best Offers'**
  String get bestOffers;

  /// No description provided for @category_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get category_all;

  /// No description provided for @category_girls.
  ///
  /// In en, this message translates to:
  /// **'Girls'**
  String get category_girls;

  /// No description provided for @category_boys.
  ///
  /// In en, this message translates to:
  /// **'Boys'**
  String get category_boys;

  /// No description provided for @category_baby.
  ///
  /// In en, this message translates to:
  /// **'Baby'**
  String get category_baby;

  /// No description provided for @category_sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get category_sales;

  /// Snackbar message with product name
  ///
  /// In en, this message translates to:
  /// **'{productName} has been added to the cart'**
  String addedXToCart(String productName);

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total ({itemCount} products)'**
  String totalPrice(int itemCount);

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// No description provided for @noAddressSelected.
  ///
  /// In en, this message translates to:
  /// **'No address selected'**
  String get noAddressSelected;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @productsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String productsCount(int count);

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @shippingFee.
  ///
  /// In en, this message translates to:
  /// **'Shipping Fee'**
  String get shippingFee;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @completePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @selectFromMap.
  ///
  /// In en, this message translates to:
  /// **'Select from Map'**
  String get selectFromMap;

  /// No description provided for @addressNameHint.
  ///
  /// In en, this message translates to:
  /// **'Address Name (e.g., Home, Work)'**
  String get addressNameHint;

  /// No description provided for @addressDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Address details (street, block, house...)'**
  String get addressDetailsHint;

  /// No description provided for @selectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select a governorate'**
  String get selectGovernorate;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @addBranch.
  ///
  /// In en, this message translates to:
  /// **'Add New Branch'**
  String get addBranch;

  /// No description provided for @selectYourGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select your governorate'**
  String get selectYourGovernorate;

  /// No description provided for @noBranchesIn.
  ///
  /// In en, this message translates to:
  /// **'No branches found in {governorateName}'**
  String noBranchesIn(String governorateName);

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get openMap;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @priceKWD.
  ///
  /// In en, this message translates to:
  /// **'Price (KWD)'**
  String get priceKWD;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noProductsMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No products match these filters'**
  String get noProductsMatchFilters;

  /// No description provided for @favoritesListIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Favorites list is empty'**
  String get favoritesListIsEmpty;

  /// No description provided for @addToFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Add products you love by tapping the heart icon'**
  String get addToFavoritesHint;

  /// No description provided for @searchInFAQ.
  ///
  /// In en, this message translates to:
  /// **'Search in FAQ...'**
  String get searchInFAQ;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @haveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAnAccount;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeOrders;

  /// No description provided for @completedOrders.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedOrders;

  /// No description provided for @cancelledOrders.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledOrders;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order No: {number}'**
  String orderNumber(String number);

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date: {date}'**
  String orderDate(String date);

  /// No description provided for @productsNo.
  ///
  /// In en, this message translates to:
  /// **'No. of Products: {count}'**
  String productsNo(int count);

  /// No description provided for @totalPriceValue.
  ///
  /// In en, this message translates to:
  /// **'Total Price: {price} KWD'**
  String totalPriceValue(String price);

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @trackingNumber.
  ///
  /// In en, this message translates to:
  /// **'Tracking Number'**
  String get trackingNumber;

  /// No description provided for @shippingCompany.
  ///
  /// In en, this message translates to:
  /// **'Shipping Company'**
  String get shippingCompany;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDelivery;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @customerService.
  ///
  /// In en, this message translates to:
  /// **'Customer Service'**
  String get customerService;

  /// No description provided for @endConversation.
  ///
  /// In en, this message translates to:
  /// **'End Conversation'**
  String get endConversation;

  /// No description provided for @endConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end the conversation?'**
  String get endConversationConfirm;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @startConversationHint.
  ///
  /// In en, this message translates to:
  /// **'Start your conversation with customer service'**
  String get startConversationHint;

  /// No description provided for @writeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message here...'**
  String get writeYourMessage;

  /// No description provided for @allowLocationAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get allowLocationAccess;

  /// No description provided for @locationAccessReason.
  ///
  /// In en, this message translates to:
  /// **'We need access to your location to determine your address accurately. Please enable location services from the app settings.'**
  String get locationAccessReason;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while determining your location. Please try again.'**
  String get locationError;

  /// No description provided for @mainAddress.
  ///
  /// In en, this message translates to:
  /// **'Main Address'**
  String get mainAddress;

  /// No description provided for @locationSetOnMap.
  ///
  /// In en, this message translates to:
  /// **'Location set on map'**
  String get locationSetOnMap;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get notSet;

  /// No description provided for @addressSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully'**
  String get addressSavedSuccess;

  /// No description provided for @addressSaveError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the address. Please try again.'**
  String get addressSaveError;

  /// No description provided for @addAddressToContinue.
  ///
  /// In en, this message translates to:
  /// **'You must add an address to continue'**
  String get addAddressToContinue;

  /// No description provided for @enterAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter address details'**
  String get enterAddressDetails;

  /// No description provided for @governorateAlAsimah.
  ///
  /// In en, this message translates to:
  /// **'Al Asimah'**
  String get governorateAlAsimah;

  /// No description provided for @governorateHawalli.
  ///
  /// In en, this message translates to:
  /// **'Hawalli'**
  String get governorateHawalli;

  /// No description provided for @governorateFarwaniya.
  ///
  /// In en, this message translates to:
  /// **'Farwaniya'**
  String get governorateFarwaniya;

  /// No description provided for @governorateAhmadi.
  ///
  /// In en, this message translates to:
  /// **'Ahmadi'**
  String get governorateAhmadi;

  /// No description provided for @governorateMubarakAlKabeer.
  ///
  /// In en, this message translates to:
  /// **'Mubarak Al-Kabeer'**
  String get governorateMubarakAlKabeer;

  /// No description provided for @governorateJahra.
  ///
  /// In en, this message translates to:
  /// **'Jahra'**
  String get governorateJahra;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get currency;

  /// No description provided for @cartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartIsEmpty;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @pleaseSelectShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Please select a shipping address'**
  String get pleaseSelectShippingAddress;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumber;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// No description provided for @paymentNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment not confirmed'**
  String get paymentNotConfirmed;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get great;

  /// No description provided for @selectShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Shipping Address'**
  String get selectShippingAddress;

  /// No description provided for @pleaseAddOrSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Please add or select an address'**
  String get pleaseAddOrSelectAddress;

  /// No description provided for @homeAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Hawalli, Block 5, Street 10, House 15'**
  String get homeAddressDetails;

  /// No description provided for @workAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Kuwait City, Commerce Tower, 20th Floor'**
  String get workAddressDetails;

  /// No description provided for @confirmAddress.
  ///
  /// In en, this message translates to:
  /// **'Confirm Address'**
  String get confirmAddress;

  /// No description provided for @errorLoadingAddresses.
  ///
  /// In en, this message translates to:
  /// **'Error loading addresses'**
  String get errorLoadingAddresses;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noAddressAdded.
  ///
  /// In en, this message translates to:
  /// **'No address added'**
  String get noAddressAdded;

  /// No description provided for @pleaseAddAddressToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please add an address to continue'**
  String get pleaseAddAddressToContinue;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @searchForYourFavoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for your favorite products...'**
  String get searchForYourFavoriteProducts;

  /// No description provided for @shippingCompanyAramex.
  ///
  /// In en, this message translates to:
  /// **'Shipping Company: Aramex'**
  String get shippingCompanyAramex;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmed;

  /// No description provided for @orderReceivedFromStore.
  ///
  /// In en, this message translates to:
  /// **'Order received from store'**
  String get orderReceivedFromStore;

  /// No description provided for @orderAtSortingCenter.
  ///
  /// In en, this message translates to:
  /// **'Order at sorting center'**
  String get orderAtSortingCenter;

  /// No description provided for @outForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get outForDelivery;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @deliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get deliveryDetails;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Ahmed'**
  String get recipientName;

  /// No description provided for @recipientPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'+20 123 456 7890'**
  String get recipientPhoneNumber;

  /// No description provided for @recipientAddress.
  ///
  /// In en, this message translates to:
  /// **'123 Street, Maadi, Cairo'**
  String get recipientAddress;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get passwordTooShort;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get loginNow;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// No description provided for @failedToCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to create account: '**
  String get failedToCreateAccount;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RAVAL'**
  String get appName;

  /// No description provided for @governorateCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get governorateCairo;

  /// No description provided for @governorateAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get governorateAlexandria;

  /// No description provided for @governorateGiza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get governorateGiza;

  /// No description provided for @governorateMansoura.
  ///
  /// In en, this message translates to:
  /// **'Mansoura'**
  String get governorateMansoura;

  /// No description provided for @loginToAddBranch.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to add a new branch'**
  String get loginToAddBranch;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @branchAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Branch added successfully'**
  String get branchAddedSuccessfully;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @couldNotOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Could not open the map'**
  String get couldNotOpenMap;

  /// No description provided for @couldNotMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Could not make the call'**
  String get couldNotMakeCall;

  /// No description provided for @faqCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get faqCategoryGeneral;

  /// No description provided for @faqCategoryOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get faqCategoryOrders;

  /// No description provided for @faqCategoryShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get faqCategoryShipping;

  /// No description provided for @faqCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get faqCategoryPayment;

  /// No description provided for @faqCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get faqCategoryOther;

  /// No description provided for @mockQuestion.
  ///
  /// In en, this message translates to:
  /// **'Mock Question {index}?'**
  String mockQuestion(int index);

  /// No description provided for @mockAnswer.
  ///
  /// In en, this message translates to:
  /// **'This is a mock answer for question {index}. It provides details and solutions related to the question.'**
  String mockAnswer(int index);

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @springDress.
  ///
  /// In en, this message translates to:
  /// **'Spring Girls Dress'**
  String get springDress;

  /// No description provided for @springDressDescription.
  ///
  /// In en, this message translates to:
  /// **'A wonderful girls dress made of the finest cotton, suitable for spring and autumn. Elegant design with bright colors.'**
  String get springDressDescription;

  /// No description provided for @girls.
  ///
  /// In en, this message translates to:
  /// **'Girls'**
  String get girls;

  /// No description provided for @dresses.
  ///
  /// In en, this message translates to:
  /// **'Dresses'**
  String get dresses;

  /// No description provided for @spring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get spring;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @cotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cotton;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @springAutumn.
  ///
  /// In en, this message translates to:
  /// **'Spring/Autumn'**
  String get springAutumn;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casual;

  /// No description provided for @boysSummerSet.
  ///
  /// In en, this message translates to:
  /// **'Boys Summer Set'**
  String get boysSummerSet;

  /// No description provided for @boysSummerSetDescription.
  ///
  /// In en, this message translates to:
  /// **'A distinctive boys set suitable for the summer season, comfortable cotton material and bright colors'**
  String get boysSummerSetDescription;

  /// No description provided for @boys.
  ///
  /// In en, this message translates to:
  /// **'Boys'**
  String get boys;

  /// No description provided for @summer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get summer;

  /// No description provided for @sport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get sport;

  /// No description provided for @winterJacket.
  ///
  /// In en, this message translates to:
  /// **'Winter Jacket'**
  String get winterJacket;

  /// No description provided for @winterJacketDescription.
  ///
  /// In en, this message translates to:
  /// **'A warm winter jacket suitable for the winter season, with a modern design and excellent material'**
  String get winterJacketDescription;

  /// No description provided for @winter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get winter;

  /// No description provided for @woolAndPolyester.
  ///
  /// In en, this message translates to:
  /// **'Wool and Polyester'**
  String get woolAndPolyester;

  /// No description provided for @lining.
  ///
  /// In en, this message translates to:
  /// **'Lining'**
  String get lining;

  /// No description provided for @lined.
  ///
  /// In en, this message translates to:
  /// **'Lined'**
  String get lined;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'Example: name@example.com'**
  String get emailExample;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @atLeast6Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get atLeast6Chars;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @errorSendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Error sending message'**
  String get errorSendingMessage;

  /// No description provided for @sentAnImage.
  ///
  /// In en, this message translates to:
  /// **'📷 Sent an image'**
  String get sentAnImage;

  /// No description provided for @errorSendingImage.
  ///
  /// In en, this message translates to:
  /// **'Error sending image'**
  String get errorSendingImage;

  /// No description provided for @errorLoadingChat.
  ///
  /// In en, this message translates to:
  /// **'Error loading chat'**
  String get errorLoadingChat;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get noInternetConnection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
