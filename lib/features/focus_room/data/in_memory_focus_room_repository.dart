import 'dart:async';
import 'dart:math';

import '../models/focus_room_models.dart';
import 'focus_room_repository.dart';

/// Single-device store (Firebase fallback / offline).
/// Room [FocusRoom.id] is the 8-char code — same as Firestore paths.
class InMemoryFocusRoomRepository implements FocusRoomRepository {
  final Map<String, FocusRoom> _byId = {};

  String _normalizeCode(String raw) {
    final s = raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (s.length >= 8) return s.substring(0, 8);
    if (s.isEmpty) return '';
    return s.padRight(8, 'X');
  }

  String _randomUniqueCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    for (var n = 0; n < 256; n++) {
      final code = List.generate(
        8,
        (_) => chars[r.nextInt(chars.length)],
      ).join();
      if (!_byId.containsKey(code)) return code;
    }
    throw StateError('In-memory room code space exhausted');
  }

  void _deleteRoom(String roomId) {
    _byId.remove(roomId);
  }

  @override
  Future<FocusRoom> createRoom({
    required String name,
    required int durationMinutes,
    required String localUserId,
    required String localDisplayName,
  }) async {
    final code = _randomUniqueCode();
    final room = FocusRoom(
      id: code,
      code: code,
      name: name,
      durationMinutes: durationMinutes,
      participants: [
        FocusParticipant(
          id: localUserId,
          displayName: localDisplayName,
          isHost: true,
          presence: ParticipantPresence.inLobby,
        ),
      ],
      phase: FocusRoomPhase.lobby,
    );
    _byId[code] = room;
    return room;
  }

  @override
  Future<JoinRoomResult> joinRoom({
    required String code,
    required String localUserId,
    required String localDisplayName,
  }) async {
    final normalized = _normalizeCode(code);
    if (normalized.length < 4) return JoinRoomResult.notFound();
    var room = _byId[normalized];
    if (room == null) return JoinRoomResult.notFound();
    if (room.phase != FocusRoomPhase.lobby) return JoinRoomResult.notFound();
    if (room.participants.any((p) => p.id == localUserId)) {
      return JoinRoomResult.success(room);
    }

    final guest = FocusParticipant(
      id: localUserId,
      displayName: localDisplayName,
      isHost: false,
      presence: ParticipantPresence.inLobby,
    );
    room = room.copyWith(participants: [...room.participants, guest]);
    _byId[normalized] = room;
    return JoinRoomResult.success(room);
  }

  @override
  Future<FocusRoom?> leaveLobby({
    required String roomId,
    required String userId,
  }) async {
    var room = _byId[roomId];
    if (room == null) return null;

    final wasHost = room.host?.id == userId;
    var list = room.participants.where((p) => p.id != userId).toList();
    if (list.isEmpty) {
      _deleteRoom(roomId);
      return null;
    }
    if (wasHost) {
      list = [
        for (var i = 0; i < list.length; i++) list[i].copyWith(isHost: i == 0),
      ];
    }
    room = room.copyWith(participants: list);
    _byId[roomId] = room;
    return room;
  }

  @override
  Future<FocusRoom> setParticipantPresence({
    required String roomId,
    required String userId,
    required ParticipantPresence presence,
  }) async {
    var room = _byId[roomId]!;
    final list = room.participants
        .map((p) => p.id == userId ? p.copyWith(presence: presence) : p)
        .toList();
    room = room.copyWith(participants: list);
    _byId[roomId] = room;
    return room;
  }

  @override
  Future<FocusRoom> startSession({
    required String roomId,
    required String hostUserId,
  }) async {
    var room = _byId[roomId]!;
    if (room.host?.id != hostUserId) {
      throw StateError('Only the host can start the session');
    }
    final list = room.participants.map((p) {
      if (p.presence == ParticipantPresence.left) return p;
      if (p.presence == ParticipantPresence.inLobby ||
          p.presence == ParticipantPresence.ready) {
        return p.copyWith(presence: ParticipantPresence.focusing);
      }
      return p;
    }).toList();
    final ends = DateTime.now().toUtc().add(
      Duration(minutes: room.durationMinutes),
    );
    room = room.copyWith(
      participants: list,
      phase: FocusRoomPhase.running,
      sessionEndsAt: ends,
    );
    _byId[roomId] = room;
    return room;
  }

  @override
  Future<FocusRoom> completeSessionNatural(String roomId) async {
    var room = _byId[roomId]!;
    final list = room.participants.map((p) {
      if (p.presence == ParticipantPresence.focusing ||
          p.presence == ParticipantPresence.paused) {
        return p.copyWith(presence: ParticipantPresence.completed);
      }
      return p;
    }).toList();
    room = room.copyWith(
      participants: list,
      phase: FocusRoomPhase.ended,
      clearSessionEndsAt: true,
    );
    _byId[roomId] = room;
    return room;
  }

  @override
  Future<FocusRoom> markParticipantLeftDuringSession({
    required String roomId,
    required String userId,
  }) async {
    var room = _byId[roomId]!;
    final list = room.participants
        .map(
          (p) => p.id == userId
              ? p.copyWith(presence: ParticipantPresence.left)
              : p,
        )
        .toList();

    // Only end the room if no other active participant remains.
    final othersActive = list.any(
      (p) => p.id != userId && p.presence != ParticipantPresence.left,
    );

    room = room.copyWith(
      participants: list,
      phase: othersActive ? room.phase : FocusRoomPhase.ended,
      clearSessionEndsAt: !othersActive,
    );
    _byId[roomId] = room;
    return room;
  }

  @override
  Stream<FocusRoom?> watchRoom(String roomId) async* {}
}
