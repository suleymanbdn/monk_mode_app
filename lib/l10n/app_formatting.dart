import 'app_localizations.dart';

extension AppLocalizationsDurationFmt on AppLocalizations {
  String formatSessionMinutes(int minutes) {
    if (minutes < 60) return durationMinutesShort(minutes);
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return durationHoursShort(h);
    return durationHoursMinutesShort(h, m);
  }

  String formatTotalFocusMinutes(int totalMinutes) {
    if (totalMinutes == 0) return durationZeroCompact;
    return formatSessionMinutes(totalMinutes);
  }
}
