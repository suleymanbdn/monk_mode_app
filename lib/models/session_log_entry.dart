/// One completed focus session stored for the session history list.
class SessionLogEntry {
  const SessionLogEntry({
    required this.dateKey,
    required this.durationMinutes,
    required this.completedAtMs,
  });

  final String dateKey;
  final int durationMinutes;
  final int completedAtMs;

  Map<String, dynamic> toJson() => {
    'd': dateKey,
    'm': durationMinutes,
    't': completedAtMs,
  };

  factory SessionLogEntry.fromJson(Map<String, dynamic> json) {
    return SessionLogEntry(
      dateKey: json['d'] as String? ?? '',
      durationMinutes: (json['m'] as num?)?.toInt() ?? 0,
      completedAtMs: (json['t'] as num?)?.toInt() ?? 0,
    );
  }
}
