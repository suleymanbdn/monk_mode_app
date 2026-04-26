class TimeUtils {
  TimeUtils._();

  /// Converts total seconds to a `MM:SS` display string.
  static String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Session length for chips, dropdowns, and summaries.
  /// Under an hour: `15 min`; whole hours: `1h`; mixed: `1h 15min`.
  static String minutesToLabel(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}min';
  }

  /// Total accumulated minutes (stats cards): same pattern as [minutesToLabel].
  static String formatTotalMinutes(int totalMinutes) {
    if (totalMinutes < 60) return '$totalMinutes min';
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}min';
  }

  /// Returns a `YYYY-MM-DD` string for a given [date].
  static String dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static String get todayKey => dateKey(DateTime.now());

  static String get yesterdayKey =>
      dateKey(DateTime.now().subtract(const Duration(days: 1)));

  /// Converts a stored `YYYY-MM-DD` key to a readable label like `Mar 15, 2026`.
  /// Returns the raw key unchanged if it cannot be parsed.
  static String formatDateKey(String key) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final parts = key.split('-');
    if (parts.length != 3) return key;
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (month == null || day == null || month < 1 || month > 12) return key;
    return '${months[month - 1]} $day, ${parts[0]}';
  }
}
