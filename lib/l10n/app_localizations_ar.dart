// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجرنا';

  @override
  String get cartPageTitle => 'سلة المشتريات';

  @override
  String get checkoutButtonText => 'الانتقال إلى الدفع';

  @override
  String get addAddressTitle => 'إضافة عنوان جديد';

  @override
  String get selectLocation => 'تحديد الموقع';

  @override
  String get governorate => 'المحافظة';

  @override
  String get addressDetails => 'تفاصيل العنوان';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'الثيم';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'النظام';

  @override
  String get addresses => 'العناوين المحفوظة';

  @override
  String get noAddresses => 'لا توجد عناوين محفوظة';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get editAddress => 'تعديل العنوان';

  @override
  String get deleteAddress => 'حذف العنوان';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get deleteAddressConfirm => 'هل أنت متأكد من حذف هذا العنوان؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get add_to_cart => 'أضف إلى السلة';

  @override
  String get added_to_cart => 'تمت الإضافة إلى السلة';

  @override
  String get buy_now => 'شراء الآن';

  @override
  String get available_colors => 'الألوان المتاحة';

  @override
  String get available_sizes => 'المقاسات المتاحة';

  @override
  String get description => 'الوصف';

  @override
  String get additional_info => 'معلومات إضافية';

  @override
  String get quantity => 'الكمية';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email_hint => 'البريد الإلكتروني';

  @override
  String get password_hint => 'كلمة السر';

  @override
  String get google_sign_in => 'المتابعة باستخدام Google';

  @override
  String get apple_sign_in => 'المتابعة باستخدام Apple';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get trackShipment => 'تتبع الشحنة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get branchAddresses => 'عناوين الفروع';

  @override
  String get profile => 'الحساب الشخصي';

  @override
  String get supportAndHelp => 'الدعم والمساعدة';

  @override
  String get welcomeMessage => 'مرحباً بك';

  @override
  String get loginPrompt => 'سجل الدخول أو أنشئ حساباً للوصول الكامل';

  @override
  String get sendTestNotification => 'إرسال إشعار تجريبي';

  @override
  String get supportChat => 'محادثة الدعم';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get newArrivals => 'وصل حديثًا';

  @override
  String get bestOffers => 'أفضل العروض';

  @override
  String get category_all => 'الكل';

  @override
  String get category_girls => 'بناتي';

  @override
  String get category_boys => 'ولادي';

  @override
  String get category_baby => 'بيبي';

  @override
  String get category_sales => 'تنزيلات';

  @override
  String addedXToCart(String productName) {
    return 'تمت إضافة $productName إلى السلة';
  }

  @override
  String totalPrice(int itemCount) {
    return 'الإجمالي ($itemCount منتجات)';
  }

  @override
  String get checkout => 'إتمام الطلب';

  @override
  String get shippingAddress => 'عنوان الشحن';

  @override
  String get noAddressSelected => 'لا يوجد عنوان محدد';

  @override
  String get change => 'تغيير';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String productsCount(int count) {
    return '$count منتجات';
  }

  @override
  String get subtotal => 'مجموع المنتجات';

  @override
  String get shippingFee => 'رسوم الشحن';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get completePayment => 'إتمام الدفع';

  @override
  String get manualEntry => 'إدخال يدوي';

  @override
  String get selectFromMap => 'تحديد من الخريطة';

  @override
  String get addressNameHint => 'اسم العنوان (مثل: المنزل، العمل)';

  @override
  String get addressDetailsHint => 'تفاصيل العنوان (شارع، قطعة، منزل...)';

  @override
  String get selectGovernorate => 'اختر محافظة';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get addBranch => 'إضافة فرع جديد';

  @override
  String get selectYourGovernorate => 'اختر محافظتك';

  @override
  String noBranchesIn(String governorateName) {
    return 'لا توجد فروع في $governorateName';
  }

  @override
  String get openMap => 'فتح الخريطة';

  @override
  String get call => 'اتصال';

  @override
  String get filters => 'الفلاتر';

  @override
  String get priceKWD => 'السعر (KWD)';

  @override
  String get color => 'اللون';

  @override
  String get size => 'المقاس';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String get noProductsMatchFilters => 'لا توجد منتجات تطابق هذه الفلاتر';

  @override
  String get favoritesListIsEmpty => 'قائمة المفضلة فارغة';

  @override
  String get addToFavoritesHint =>
      'أضف منتجاتك التي تحبها بالضغط على أيقونة القلب';

  @override
  String get searchInFAQ => 'البحث في الأسئلة الشائعة...';

  @override
  String get all => 'الكل';

  @override
  String get or => 'أو';

  @override
  String get haveAnAccount => 'لديك حساب بالفعل؟';

  @override
  String get activeOrders => 'جاري التنفيذ';

  @override
  String get completedOrders => 'مكتمل';

  @override
  String get cancelledOrders => 'ملغي';

  @override
  String orderNumber(String number) {
    return 'رقم الطلب: $number';
  }

  @override
  String orderDate(String date) {
    return 'تاريخ الطلب: $date';
  }

  @override
  String productsNo(int count) {
    return 'عدد المنتجات: $count';
  }

  @override
  String totalPriceValue(String price) {
    return 'المبلغ الإجمالي: $price KWD';
  }

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get trackingNumber => 'رقم التتبع';

  @override
  String get shippingCompany => 'شركة الشحن';

  @override
  String get estimatedDelivery => 'الوقت المتوقع للتوصيل';

  @override
  String get recipient => 'المستلم';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get confirmPassword => 'تأكيد كلمة السر';

  @override
  String get passwordsDoNotMatch => 'كلمتا السر غير متطابقتين';

  @override
  String get customerService => 'خدمة العملاء';

  @override
  String get endConversation => 'إنهاء المحادثة';

  @override
  String get endConversationConfirm => 'هل أنت متأكد من إنهاء المحادثة؟';

  @override
  String get end => 'إنهاء';

  @override
  String get startConversationHint => 'ابدأ محادثتك مع خدمة العملاء';

  @override
  String get writeYourMessage => 'اكتب رسالتك هنا...';

  @override
  String get allowLocationAccess => 'السماح بالوصول للموقع';

  @override
  String get locationAccessReason =>
      'نحتاج إلى الوصول إلى موقعك لتحديد عنوانك بدقة. يرجى تفعيل خدمة الموقع من إعدادات التطبيق.';

  @override
  String get ok => 'حسناً';

  @override
  String get locationError =>
      'حدث خطأ أثناء تحديد موقعك. يرجى المحاولة مرة أخرى.';

  @override
  String get mainAddress => 'العنوان الرئيسي';

  @override
  String get locationSetOnMap => 'تم تحديد الموقع على الخريطة';

  @override
  String get notSet => 'غير محدد';

  @override
  String get addressSavedSuccess => 'تم حفظ العنوان بنجاح';

  @override
  String get addressSaveError =>
      'حدث خطأ أثناء حفظ العنوان. يرجى المحاولة مرة أخرى.';

  @override
  String get addAddressToContinue => 'يجب إضافة عنوان للمتابعة';

  @override
  String get enterAddressDetails => 'أدخل تفاصيل العنوان';

  @override
  String get governorateAlAsimah => 'العاصمة';

  @override
  String get governorateHawalli => 'حولي';

  @override
  String get governorateFarwaniya => 'الفروانية';

  @override
  String get governorateAhmadi => 'الأحمدي';

  @override
  String get governorateMubarakAlKabeer => 'مبارك الكبير';

  @override
  String get governorateJahra => 'الجهراء';

  @override
  String get currency => 'د.ك';

  @override
  String get cartIsEmpty => 'سلة المشتريات فارغة';

  @override
  String get home => 'المنزل';

  @override
  String get work => 'العمل';

  @override
  String get pleaseSelectShippingAddress => 'الرجاء اختيار عنوان الشحن';

  @override
  String get paymentFailed => 'فشل الدفع';

  @override
  String get invoiceNumber => 'رقم الفاتورة';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح';

  @override
  String get paymentNotConfirmed => 'لم يتم تأكيد الدفع';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get great => 'رائع!';

  @override
  String get selectShippingAddress => 'اختر عنوان الشحن';

  @override
  String get pleaseAddOrSelectAddress => 'الرجاء إضافة أو اختيار عنوان';

  @override
  String get homeAddressDetails => 'حولي، قطعة 5، شارع 10، منزل 15';

  @override
  String get workAddressDetails => 'مدينة الكويت، برج التجارية، الدور 20';

  @override
  String get confirmAddress => 'تأكيد العنوان';

  @override
  String get errorLoadingAddresses => 'خطأ في تحميل العناوين';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noAddressAdded => 'لم يتم إضافة عنوان';

  @override
  String get pleaseAddAddressToContinue => 'الرجاء إضافة عنوان للمتابعة';

  @override
  String get select => 'اختيار';

  @override
  String get unknown => 'غير معروف';

  @override
  String get colorPink => 'وردي';

  @override
  String get colorWhite => 'أبيض';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorBlack => 'أسود';

  @override
  String get colorGreen => 'أخضر';

  @override
  String get searchForYourFavoriteProducts => 'ابحث عن منتجاتك المفضلة...';

  @override
  String get shippingCompanyAramex => 'شركة الشحن: أرامكس';

  @override
  String get orderConfirmed => 'تم تأكيد الطلب';

  @override
  String get orderReceivedFromStore => 'تم استلام الطلب من المتجر';

  @override
  String get orderAtSortingCenter => 'الطلب في مركز الفرز';

  @override
  String get outForDelivery => 'جاري التوصيل';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get deliveryDetails => 'تفاصيل التوصيل';

  @override
  String get recipientName => 'محمد أحمد';

  @override
  String get recipientPhoneNumber => '+20 123 456 7890';

  @override
  String get recipientAddress => 'شارع 123، المعادي، القاهرة';

  @override
  String get invalidEmail => 'بريد غير صحيح';

  @override
  String get passwordTooShort => 'كلمة السر قصيرة جدًا';

  @override
  String get createAccount => 'إنشاء الحساب';

  @override
  String get loginNow => 'سجل الدخول الآن';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح!';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get weakPassword => 'كلمة السر ضعيفة جدًا.';

  @override
  String get emailAlreadyInUse => 'هذا البريد الإلكتروني مستخدم بالفعل.';

  @override
  String get failedToCreateAccount => 'فشل إنشاء الحساب: ';

  @override
  String get appName => 'RAVAL';

  @override
  String get governorateCairo => 'القاهرة';

  @override
  String get governorateAlexandria => 'الإسكندرية';

  @override
  String get governorateGiza => 'الجيزة';

  @override
  String get governorateMansoura => 'المنصورة';

  @override
  String get loginToAddBranch => 'يجب تسجيل الدخول لإضافة فرع جديد';

  @override
  String get branchName => 'اسم الفرع';

  @override
  String get address => 'العنوان';

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get latitude => 'خط العرض';

  @override
  String get longitude => 'خط الطول';

  @override
  String get branchAddedSuccessfully => 'تم إضافة الفرع بنجاح';

  @override
  String get error => 'حدث خطأ: ';

  @override
  String get add => 'إضافة';

  @override
  String get couldNotOpenMap => 'لا يمكن فتح الخريطة';

  @override
  String get couldNotMakeCall => 'لا يمكن إجراء المكالمة';

  @override
  String get faqCategoryGeneral => 'عام';

  @override
  String get faqCategoryOrders => 'الطلبات';

  @override
  String get faqCategoryShipping => 'الشحن';

  @override
  String get faqCategoryPayment => 'الدفع';

  @override
  String get faqCategoryOther => 'أخرى';

  @override
  String mockQuestion(int index) {
    return 'سؤال وهمي $index؟';
  }

  @override
  String mockAnswer(int index) {
    return 'هذه إجابة وهمية للسؤال $index. توفر تفاصيل وحلولاً متعلقة بالسؤال.';
  }

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get springDress => 'فستان بناتي ربيعي';

  @override
  String get springDressDescription =>
      'فستان بناتي رائع مصنوع من أجود أنواع القطن، مناسب لفصل الربيع والخريف. تصميم أنيق بألوان زاهية.';

  @override
  String get girls => 'بناتي';

  @override
  String get dresses => 'فساتين';

  @override
  String get spring => 'ربيعي';

  @override
  String get materials => 'المواد';

  @override
  String get cotton => 'قطن';

  @override
  String get season => 'الموسم';

  @override
  String get springAutumn => 'ربيع/خريف';

  @override
  String get style => 'نمط';

  @override
  String get casual => 'كاجوال';

  @override
  String get boysSummerSet => 'طقم ولادي صيفي';

  @override
  String get boysSummerSetDescription =>
      'طقم ولادي مميز مناسب لفصل الصيف، خامة قطنية مريحة وألوان زاهية';

  @override
  String get boys => 'ولادي';

  @override
  String get summer => 'صيفي';

  @override
  String get sport => 'سبورت';

  @override
  String get winterJacket => 'جاكيت شتوي';

  @override
  String get winterJacketDescription =>
      'جاكيت شتوي دافئ مناسب لفصل الشتاء، بتصميم عصري وخامة ممتازة';

  @override
  String get winter => 'شتاء';

  @override
  String get woolAndPolyester => 'صوف وبوليستر';

  @override
  String get lining => 'البطانة';

  @override
  String get lined => 'مبطن';

  @override
  String get emailExample => 'مثال: name@example.com';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get atLeast6Chars => 'على الأقل 6 أحرف';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة السر';

  @override
  String get errorSendingMessage => 'حدث خطأ في إرسال الرسالة';

  @override
  String get sentAnImage => '📷 تم إرسال صورة';

  @override
  String get errorSendingImage => 'حدث خطأ في إرسال الصورة';

  @override
  String get errorLoadingChat => 'حدث خطأ في تحميل المحادثة';

  @override
  String get noInternetConnection =>
      'الرجاء التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
}
