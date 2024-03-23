import 'package:intl/intl.dart';

class Formatter {
  // Method to format a date
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Method to format currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(amount);
  }

  // Method to format a phone number
  static String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAllMapped(
      RegExp(r'^(\d{3})(\d{3})(\d{4})$'),
      (match) => '(${match[1]}) ${match[2]}-${match[3]}',
    );
  }

  // Method to format an international phone number
  static String formatInternationalPhoneNumber(String phoneNumber, String countryCode) {
    return '$countryCode $phoneNumber'; 
  }
}
