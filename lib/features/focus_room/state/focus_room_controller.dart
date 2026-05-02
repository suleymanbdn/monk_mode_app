import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/focus_room_repository.dart';
import '../models/focus_room_models.dart';

/// Focus Together session state and timer.
class FocusRoomController extends ChangeNotifier {
  FocusRoomController({
    required FocusRoomRepository repository,
    required this.localUserId,
    String localDisplayName = 'Guest',
  }) : _repo = repository,
       _localDisplayName = localDisplayName.trim().isEmpty
           ? 'Guest'
           : (localDisplayName.trim().length > 20
                 ? localDisplayName.trim().substring(0, 20)
                 : localDisplayName.trim());

  final FocusRoomRepository _repo;
  final String localUserId;
  String _localDisplayName;
  String get localDisplayName => _localDisplayName;

  void setLocalDisplayName(String raw) {
    var t = raw.trim();
    if (t.isEmpty) return;
    if (t.length > 20) t = t.substring(0, 20);
    if (t == _localDisplayName) return;
    _localDisplayName = t;
    notifyListeners();
  }

  FocusRoom? _room;
  FocusRoom? get room => _room;

  int? _sessionRemainingSeconds;
  int? get sessionRemainingSeconds => _sessionRemainingSeconds;

  Timer? _sessionTimer;
  StreamSubscription<FocusRoom?>? _roomWatchSub;

  /// When true, session wall-clock updates and the 1s ticker are frozen (app in background).
  bool _suspendSessionTickerForBackground = false;

  bool get isHost => room?.host?.id == localUserId;

  bool get isInActiveSession =>
      room?.phase == FocusRoomPhase.running &&
      (_sessionRemainingSeconds ?? 0) > 0;

  void _syncWatch() {
    _roomWatchSub?.cancel();
    final id = _room?.id;
    if (id == null) return;

    _roomWatchSub = _repo
        .watchRoom(id)
        .listen(
          (r) {
            if (r == null) {
              stopSessionTimer();
              _room = null;
              _sessionRemainingSeconds = null;
              notifyListeners();
              return;
            }
            _room = r;
            if (r.phase == FocusRoomPhase.ended) {
              stopSessionTimer();
              _suspendSessionTickerForBackground = false;
              _sessionRemainingSeconds = 0;
            } else if (r.phase == FocusRoomPhase.running &&
                r.sessionEndsAt != null) {
              if (!_suspendSessionTickerForBackground) {
                final sec = r.sessionEndsAt!
                    .difference(DateTime.now())
                    .inSeconds;
                _sessionRemainingSeconds = sec.clamp(0, 999999);
                _ensureSessionTimerForRunning();
              }
            } else if (r.sessionEndsAt != null) {
              if (!_suspendSessionTickerForBackground) {
                final sec = r.sessionEndsAt!
                    .difference(DateTime.now())
                    .inSeconds;
                _sessionRemainingSeconds = sec.clamp(0, 999999);
              }
            }
            notifyListeners();
          },
          onError: (_) {
            stopSessionTimer();
            _room = null;
            _sessionRemainingSeconds = null;
            notifyListeners();
          },
        );
  }

  /// Binds an already-fetched room (tests / deep links).
  void bindRoom(FocusRoom value) {
    _room = value;
    _syncWatch();
    notifyListeners();
  }

  Future<void> createAndEnterRoom({
    required String name,
    required int durationMinutes,
  }) async {
    _room = await _repo.createRoom(
      name: name,
      durationMinutes: durationMinutes,
      localUserId: localUserId,
      localDisplayName: localDisplayName,
    );
    _syncWatch();
    notifyListeners();
  }

  /// [JoinRoomResult.isSuccess] is true when the lobby was joined or already joined.
  Future<JoinRoomResult> joinByCode(String rawCode) async {
    final r = await _repo.joinRoom(
      code: rawCode,
      localUserId: localUserId,
      localDisplayName: localDisplayName,
    );
    if (!r.isSuccess) return r;
    _room = r.room;
    _syncWatch();
    notifyListeners();
    return r;
  }

  /// Local user exits the lobby; clears active room snapshot for this client.
  Future<void> leaveLobby() async {
    _roomWatchSub?.cancel();
    _roomWatchSub = null;
    if (_room == null) return;
    await _repo.leaveLobby(roomId: _room!.id, userId: localUserId);
    _room = null;
    notifyListeners();
  }

  /// Guest toggles ready ↔ waiting in lobby.
  Future<void> toggleReady() async {
    if (_room == null) return;
    final self = _room!.participants
        .where((p) => p.id == localUserId)
        .firstOrNull;
    if (self == null) return;
    final next = self.presence == ParticipantPresence.ready
        ? ParticipantPresence.inLobby
        : ParticipantPresence.ready;
    _room = await _repo.setParticipantPresence(
      roomId: _room!.id,
      userId: localUserId,
      presence: next,
    );
    notifyListeners();
  }

  /// Host starts the shared timer; begins local tick loop.
  Future<void> startSharedSession() async {
    if (_room == null) return;
    _room = await _repo.startSession(
      roomId: _room!.id,
      hostUserId: localUserId,
    );
    if (_room!.sessionEndsAt != null) {
      _sessionRemainingSeconds = _room!.sessionEndsAt!
          .difference(DateTime.now())
          .inSeconds
          .clamp(0, 999999);
    } else {
      _sessionRemainingSeconds = _room!.durationMinutes * 60;
    }
    _ensureSessionTimerForRunning();
    notifyListeners();
  }

  /// Guests (and host after [startSharedSession]) need a 1s ticker while running.
  void _ensureSessionTimerForRunning() {
    if (_room?.phase != FocusRoomPhase.running) return;
    if (_suspendSessionTickerForBackground) return;
    if (_sessionTimer != null) return;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onSessionTick();
    });
  }

  /// Stops local countdown while the app is not foreground (timer should not run in background).
  void pauseSessionTickerForBackground() {
    if (_room?.phase != FocusRoomPhase.running) return;
    _suspendSessionTickerForBackground = true;
    stopSessionTimer();
    notifyListeners();
  }

  /// Restores ticker and syncs remaining time after returning to the app.
  void resumeSessionTickerAfterForeground() {
    if (!_suspendSessionTickerForBackground) return;
    _suspendSessionTickerForBackground = false;
    if (_room?.phase == FocusRoomPhase.running) {
      if (_room!.sessionEndsAt != null) {
        _sessionRemainingSeconds = _room!.sessionEndsAt!
            .difference(DateTime.now())
            .inSeconds
            .clamp(0, 999999);
      }
      _ensureSessionTimerForRunning();
    }
    notifyListeners();
  }

  void _onSessionTick() {
    if (_room == null || _sessionRemainingSeconds == null) return;
    final roomId = _room!.id;

    if (_room!.sessionEndsAt != null) {
      final sec = _room!.sessionEndsAt!.difference(DateTime.now()).inSeconds;
      _sessionRemainingSeconds = sec.clamp(0, 999999);
      if (sec <= 0) {
        _sessionTimer?.cancel();
        _sessionTimer = null;
        _repo.completeSessionNatural(roomId).then((r) {
          _room = r;
          _sessionRemainingSeconds = 0;
          notifyListeners();
        });
        return;
      }
      notifyListeners();
      return;
    }

    final nextSec = _sessionRemainingSeconds! - 1;
    if (nextSec <= 0) {
      _sessionTimer?.cancel();
      _sessionTimer = null;
      _repo.completeSessionNatural(roomId).then((r) {
        _room = r;
        _sessionRemainingSeconds = 0;
        notifyListeners();
      });
      return;
    }

    _sessionRemainingSeconds = nextSec;
    notifyListeners();
  }

  void stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// END / leave early: ends MVP session for everyone locally; returns summary.
  Future<FocusSessionSummary> leaveSessionEarly() async {
    stopSessionTimer();
    if (_room == null) throw StateError('No active room');
    final id = _room!.id;
    _room = await _repo.markParticipantLeftDuringSession(
      roomId: id,
      userId: localUserId,
    );
    _sessionRemainingSeconds = 0;
    notifyListeners();
    return FocusRoomSummaryBuilder.build(
      room: _room!,
      endKind: SessionEndKind.localLeftEarly,
    );
  }

  FocusSessionSummary buildSessionSummary(SessionEndKind endKind) {
    if (_room == null) throw StateError('No room');
    return FocusRoomSummaryBuilder.build(room: _room!, endKind: endKind);
  }

  void clearRoom() {
    stopSessionTimer();
    _suspendSessionTickerForBackground = false;
    _roomWatchSub?.cancel();
    _roomWatchSub = null;
    _room = null;
    _sessionRemainingSeconds = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopSessionTimer();
    _roomWatchSub?.cancel();
    super.dispose();
  }
}
