// Focus Together domain types.

enum FocusRoomPhase { lobby, running, ended }

enum ParticipantPresence { inLobby, ready, focusing, paused, completed, left }

/// How the session ended from the local client's perspective (summary copy).
enum SessionEndKind {
  /// Timer reached zero; server would finalize everyone still focusing.
  naturalComplete,

  /// Local user left before the timer finished.
  localLeftEarly,

  /// Another participant left first, which closed the room for everyone.
  endedByOthers,
}

class FocusParticipant {
  const FocusParticipant({
    required this.id,
    required this.displayName,
    this.isHost = false,
    this.presence = ParticipantPresence.inLobby,
    this.isSimulated = false,
  });

  final String id;
  final String displayName;
  final bool isHost;
  final ParticipantPresence presence;

  /// Always false for real users; kept for Firestore schema compatibility.
  final bool isSimulated;

  FocusParticipant copyWith({
    String? id,
    String? displayName,
    bool? isHost,
    ParticipantPresence? presence,
    bool? isSimulated,
  }) {
    return FocusParticipant(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      isHost: isHost ?? this.isHost,
      presence: presence ?? this.presence,
      isSimulated: isSimulated ?? this.isSimulated,
    );
  }
}

class FocusRoom {
  const FocusRoom({
    required this.id,
    required this.code,
    required this.name,
    required this.durationMinutes,
    required this.participants,
    this.phase = FocusRoomPhase.lobby,
    this.sessionEndsAt,
  });

  final String id;
  final String code;
  final String name;
  final int durationMinutes;
  final List<FocusParticipant> participants;
  final FocusRoomPhase phase;

  /// When set (cloud sessions), all devices derive remaining time from this instant.
  final DateTime? sessionEndsAt;

  FocusParticipant? get host {
    for (final p in participants) {
      if (p.isHost) return p;
    }
    return null;
  }

  int get readyCount =>
      participants.where((p) => p.presence == ParticipantPresence.ready).length;

  FocusRoom copyWith({
    String? id,
    String? code,
    String? name,
    int? durationMinutes,
    List<FocusParticipant>? participants,
    FocusRoomPhase? phase,
    DateTime? sessionEndsAt,
    bool clearSessionEndsAt = false,
  }) {
    return FocusRoom(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      participants: participants ?? this.participants,
      phase: phase ?? this.phase,
      sessionEndsAt: clearSessionEndsAt
          ? null
          : (sessionEndsAt ?? this.sessionEndsAt),
    );
  }
}

class FocusSessionSummary {
  const FocusSessionSummary({
    required this.roomName,
    required this.durationMinutes,
    required this.completedNames,
    required this.skippedNames,
    required this.endedAtHm,
    required this.endKind,
  });

  final String roomName;
  final int durationMinutes;
  final List<String> completedNames;
  final List<String> skippedNames;

  /// Local time when the summary was built, `HH:mm` (localized prefix applied in UI).
  final String endedAtHm;
  final SessionEndKind endKind;
}

/// Pure function: easy to unit test and mirror server-side later.
abstract final class FocusRoomSummaryBuilder {
  static FocusSessionSummary build({
    required FocusRoom room,
    required SessionEndKind endKind,
  }) {
    final completed = <String>[];
    final skipped = <String>[];

    for (final p in room.participants) {
      switch (p.presence) {
        case ParticipantPresence.completed:
          completed.add(p.displayName);
        case ParticipantPresence.left:
          skipped.add(p.displayName);
        case ParticipantPresence.focusing:
        case ParticipantPresence.paused:
        case ParticipantPresence.ready:
        case ParticipantPresence.inLobby:
          // Still in session when summary is shown, or natural end missed a row.
          skipped.add(p.displayName);
      }
    }

    final now = DateTime.now();
    final endedAt =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return FocusSessionSummary(
      roomName: room.name,
      durationMinutes: room.durationMinutes,
      completedNames: completed,
      skippedNames: skipped,
      endedAtHm: endedAt,
      endKind: endKind,
    );
  }
}
