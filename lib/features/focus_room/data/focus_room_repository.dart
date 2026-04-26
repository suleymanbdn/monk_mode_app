import '../models/focus_room_models.dart';

/// Focus Together room backend (in-memory or Firestore).
abstract class FocusRoomRepository {
  /// Creates a lobby room; [localUserId] becomes host.
  Future<FocusRoom> createRoom({
    required String name,
    required int durationMinutes,
    required String localUserId,
    required String localDisplayName,
  });

  /// Join an existing lobby by code.
  Future<JoinRoomResult> joinRoom({
    required String code,
    required String localUserId,
    required String localDisplayName,
  });

  /// Removes [userId] from the lobby; promotes a new host if needed.
  /// Returns null if the room was deleted (empty).
  Future<FocusRoom?> leaveLobby({
    required String roomId,
    required String userId,
  });

  Future<FocusRoom> setParticipantPresence({
    required String roomId,
    required String userId,
    required ParticipantPresence presence,
  });

  /// Host-only: lobby → running; lobby-ready participants → focusing.
  Future<FocusRoom> startSession({
    required String roomId,
    required String hostUserId,
  });

  /// Timer finished: focusing/paused → completed; phase → ended.
  Future<FocusRoom> completeSessionNatural(String roomId);

  /// Local user leaves during session: that user → left; phase → ended (MVP).
  Future<FocusRoom> markParticipantLeftDuringSession({
    required String roomId,
    required String userId,
  });

  /// Realtime room state; emits `null` if the room document is removed.
  /// In-memory backend returns an empty stream (no cloud updates).
  Stream<FocusRoom?> watchRoom(String roomId);
}

enum JoinRoomFailureKind { notFound, networkUnavailable }

/// Outcome of attempting to join a lobby by code.
class JoinRoomResult {
  const JoinRoomResult._({this.room, this.failure});

  final FocusRoom? room;
  final JoinRoomFailureKind? failure;

  bool get isSuccess => room != null;

  factory JoinRoomResult.success(FocusRoom room) =>
      JoinRoomResult._(room: room, failure: null);

  factory JoinRoomResult.notFound() =>
      JoinRoomResult._(room: null, failure: JoinRoomFailureKind.notFound);

  factory JoinRoomResult.networkUnavailable() => JoinRoomResult._(
    room: null,
    failure: JoinRoomFailureKind.networkUnavailable,
  );
}
