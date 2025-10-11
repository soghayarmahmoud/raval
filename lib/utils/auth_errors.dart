// In lib/utils/auth_errors.dart
class AuthErrors {
  static String getLocalizedErrorMessage(String code, {bool isArabic = true}) {
    final messages = {
      'user-not-found': {
        'ar': 'البريد الإلكتروني غير مسجل',
        'en': 'Email is not registered'
      },
      'wrong-password': {
        'ar': 'كلمة المرور غير صحيحة',
        'en': 'Incorrect password'
      },
      'invalid-email': {
        'ar': 'البريد الإلكتروني غير صالح',
        'en': 'Invalid email address'
      },
      'weak-password': {
        'ar': 'كلمة المرور ضعيفة - يجب أن تحتوي على 6 أحرف على الأقل',
        'en': 'Weak password - must be at least 6 characters'
      },
      'email-already-in-use': {
        'ar': 'هذا البريد الإلكتروني مستخدم بالفعل',
        'en': 'This email is already registered'
      },
      'operation-not-allowed': {
        'ar': 'تسجيل الدخول بالبريد الإلكتروني غير مفعل',
        'en': 'Email/password sign in is not enabled'
      },
      'google-sign-in-cancelled': {
        'ar': 'تم إلغاء تسجيل الدخول بحساب جوجل',
        'en': 'Google sign in was cancelled'
      },
      'apple-sign-in-failed': {
        'ar': 'فشل تسجيل الدخول بحساب آبل',
        'en': 'Apple sign in failed'
      },
      'network-request-failed': {
        'ar': 'يرجى التحقق من اتصال الإنترنت',
        'en': 'Please check your internet connection'
      },
      'too-many-requests': {
        'ar': 'تم تجاوز عدد المحاولات المسموح بها، يرجى المحاولة لاحقاً',
        'en': 'Too many attempts, please try again later'
      },
      'default': {
        'ar': 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
        'en': 'An unexpected error occurred, please try again'
      },
    };

    final errorMessages = messages[code] ?? messages['default']!;
    return errorMessages[isArabic ? 'ar' : 'en']!;
  }
}
