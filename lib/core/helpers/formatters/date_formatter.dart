import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const String _defaultLocale = 'id_ID';
  static const String _defaultPattern = 'dd MMM yyyy';

  static String formatDate(
    DateTime? date, {
    String pattern = _defaultPattern,
    String locale = _defaultLocale,
    String fallback = '-',
  }) {
    if (date == null) return fallback;
    try {
      return DateFormat(pattern, locale).format(date);
    } catch (_) {
      try {
        return DateFormat('dd-MM-yyyy').format(date);
      } catch (_) {
        return fallback;
      }
    }
  }
}
