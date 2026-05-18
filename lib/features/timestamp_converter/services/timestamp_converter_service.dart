import 'package:injectable/injectable.dart';

@lazySingleton
class TimestampConverterService {
  /// Formats the DateTime into a clean local string (e.g., 2024-05-18 19:02:58)
  String formatDateTime(DateTime dt) {
    return dt.toString().split('.').first;
  }

  /// Calculates the human-readable relative time
  String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    final isPast = difference.isNegative;
    final absDiff = difference.abs();

    if (absDiff.inSeconds < 60) return 'Just now';
    if (absDiff.inMinutes < 60) {
      return '${absDiff.inMinutes} minutes ${isPast ? 'ago' : 'from now'}';
    }
    if (absDiff.inHours < 24) {
      return '${absDiff.inHours} hours ${isPast ? 'ago' : 'from now'}';
    }
    if (absDiff.inDays < 30) {
      return '${absDiff.inDays} days ${isPast ? 'ago' : 'from now'}';
    }
    if (absDiff.inDays < 365) {
      return '${absDiff.inDays ~/ 30} months ${isPast ? 'ago' : 'from now'}';
    }
    return '${absDiff.inDays ~/ 365} years ${isPast ? 'ago' : 'from now'}';
  }
}
