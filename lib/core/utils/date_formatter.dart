import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToyMd(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date); // Sep 12, 2023
  }

  static String formatToddMMyyyy(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date); // 17/08/1990
  }

  static String formatToTime(DateTime time) {
    return DateFormat('hh:mm a').format(time); // 10:00 AM
  }

  static String formatToDayMonth(DateTime date) {
    return DateFormat('d MMM').format(date); // 10 Sep
  }
}
