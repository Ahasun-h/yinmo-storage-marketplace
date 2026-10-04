import 'package:intl/intl.dart';

class TimeConverter {
  static String? timeAgo(String? isoTimestamp) {
    if (isoTimestamp == null) return '';

    // Parse the timestamp, try to detect if it is UTC or Local
    DateTime notifTime = DateTime.parse(isoTimestamp);

    // If input is UTC (ends with Z or no offset but intended as UTC), use UTC now
    // Otherwise rely on local time comparison
    final now = notifTime.isUtc ? DateTime.now().toUtc() : DateTime.now();

    final diff = now.difference(notifTime);

    if (diff.isNegative) {
      // Logic to handle future dates (e.g. slight clock skew or actual future date)
      return "0m";
    }

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m"; // মিনিট আগে
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h"; // ঘণ্টা আগে
    } else {
      return "${diff.inDays}d"; // দিন আগে
    }
  }

  static String? formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime); // Example: 1:12 PM
  }
}
