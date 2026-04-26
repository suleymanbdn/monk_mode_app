import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/focus_room_models.dart';
import 'focus_room_repository.dart';

final class _CodeTaken implements Exception {}

/// Firestore-backed Focus Together (multi-device). Collection: `focus_rooms`.
/// Her oda belgesinin ID’si 8 karakterlik oda kodu ile aynıdır (koleksiyon taraması yok).
class FirestoreFocusRoomRepository implements FocusRoomRepository {
  FirestoreFocusRoomRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _db.collection('focus_rooms');

  String _normalizeCode(String raw) {
    final s = raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (s.length >= 8) return s.substring(0, 8);
    if (s.isEmpty) return '';
    return s.padRight(8, 'X');
  }

  String _randomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(8, (_) => chars[r.nextInt(chars.length)]).join();
  }

  DateTime? _readEndsAt(Map<String, dynamic> d) {
    final t = d['sessionEndsAt'];
    if (t is Timestamp) return t.toDate();
    return null;
  }

  FocusRoomPhase _parsePhase(String? s) {
    for (final v in FocusRoomPhase.values) {
      if (v.name == s) return v;
    }
    return FocusRoomPhase.lobby;
  }

  ParticipantPresence _parsePresence(String? s) {
    for (final v in ParticipantPresence.values) {
      if (v.name == s) return v;
    }
    return ParticipantPresence.inLobby;
  }

  FocusRoom? _fromRoomAndParts(
    DocumentSnapshot<Map<String, dynamic>> roomSnap,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> partDocs,
  ) {
    if (!roomSnap.exists) return null;
    final d = roomSnap.data()!;
    final participants =
        partDocs.map((doc) {
          final m = doc.data();
          return FocusParticipant(
            id: doc.id,
            displayName: m['displayName'] as String? ?? 'Guest',
            isHost: m['isHost'] as bool? ?? false,
            presence: _parsePresence(m['presence'] as String?),
            isSimulated: m['isSimulated'] as bool? ?? false,
          );
        }).toList()..sort(
          (a, b) => a.displayName.toLowerCase().compareTo(
            b.displayName.toLowerCase(),
          ),
        );

    return FocusRoom(
      id: roomSnap.id,
      code: d['code'] as String,
      name: d['name'] as String? ?? '',
      durationMinutes: (d['durationMinutes'] as num).toInt(),
      participants: participants,
      phase: _parsePhase(d['phase'] as String?),
      sessionEndsAt: _readEndsAt(d),
    );
  }

  Future<FocusRoom> _fetchRoom(String roomId) async {
    final roomRef = _rooms.doc(roomId);
    final r = await roomRef.get();
    final p = await roomRef.collection('participants').get();
    final room = _fromRoomAndParts(r, p.docs);
    if (room == null) throw StateError('Room $roomId missing');
    return room;
  }

  Future<void> _deleteRoomCascade(
    DocumentReference<Map<String, dynamic>> roomRef,
  ) async {
    final parts = await roomRef.collection('participants').get();
    WriteBatch batch = _db.batch();
    var n = 0;
    for (final d in parts.docs) {
      batch.delete(d.reference);
      n++;
      if (n >= 400) {
        await batch.commit();
        batch = _db.batch();
        n = 0;
      }
    }
    batch.delete(roomRef);
    await batch.commit();
  }

  @override
  Future<FocusRoom> createRoom({
    required String name,
    required int durationMinutes,
    required String localUserId,
    required String localDisplayName,
  }) async {
    for (var attempt = 0; attempt < 32; attempt++) {
      final code = _randomCode();
      final ref = _rooms.doc(code);

      final safeName = name.trim().length > 40
          ? name.trim().substring(0, 40)
          : name.trim();
      final safeDuration = durationMinutes.clamp(5, 180);
      final safeDisplayName = localDisplayName.trim().isEmpty
          ? 'Guest'
          : (localDisplayName.trim().length > 20
                ? localDisplayName.trim().substring(0, 20)
                : localDisplayName.trim());

      try {
        await _db.runTransaction((transaction) async {
          final snap = await transaction.get(ref);
          if (snap.exists) throw _CodeTaken();
          transaction.set(ref, {
            'code': code,
            'name': safeName,
            'durationMinutes': safeDuration,
            'phase': FocusRoomPhase.lobby.name,
            'hostUserId': localUserId,
            'sessionEndsAt': null,
            'createdAt': FieldValue.serverTimestamp(),
          });
          transaction.set(ref.collection('participants').doc(localUserId), {
            'displayName': safeDisplayName,
            'isHost': true,
            'presence': ParticipantPresence.inLobby.name,
            'isSimulated': false,
          });
        });
      } on _CodeTaken {
        continue;
      }
      return _fetchRoom(code);
    }
    throw StateError('Could not allocate a unique room code');
  }

  @override
  Future<JoinRoomResult> joinRoom({
    required String code,
    required String localUserId,
    required String localDisplayName,
  }) async {
    final normalized = _normalizeCode(code);
    if (normalized.length < 4) return JoinRoomResult.notFound();

    try {
      final roomRef = _rooms.doc(normalized);
      final roomSnap = await roomRef.get();
      if (!roomSnap.exists) return JoinRoomResult.notFound();
      final phase = _parsePhase(roomSnap.data()!['phase'] as String?);
      if (phase != FocusRoomPhase.lobby) {
        return JoinRoomResult.notFound();
      }
      final existing = await roomRef
          .collection('participants')
          .doc(localUserId)
          .get();
      if (existing.exists) {
        return JoinRoomResult.success(await _fetchRoom(roomRef.id));
      }

      final safeJoinName = localDisplayName.trim().isEmpty
          ? 'Guest'
          : (localDisplayName.trim().length > 20
                ? localDisplayName.trim().substring(0, 20)
                : localDisplayName.trim());
      await roomRef.collection('participants').doc(localUserId).set({
        'displayName': safeJoinName,
        'isHost': false,
        'presence': ParticipantPresence.inLobby.name,
        'isSimulated': false,
      });
      return JoinRoomResult.success(await _fetchRoom(roomRef.id));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied' ||
          e.code == 'unavailable' ||
          e.code == 'deadline-exceeded') {
        return JoinRoomResult.networkUnavailable();
      }
      return JoinRoomResult.networkUnavailable();
    } catch (_) {
      return JoinRoomResult.networkUnavailable();
    }
  }

  @override
  Future<FocusRoom?> leaveLobby({
    required String roomId,
    required String userId,
  }) async {
    final roomRef = _rooms.doc(roomId);
    final pref = roomRef.collection('participants').doc(userId);
    final me = await pref.get();
    if (!me.exists) return _fetchRoom(roomId);

    final wasHost = me.data()!['isHost'] as bool? ?? false;
    await pref.delete();

    final snap = await roomRef.collection('participants').get();
    if (snap.docs.isEmpty) {
      await _deleteRoomCascade(roomRef);
      return null;
    }

    if (wasHost && snap.docs.isNotEmpty) {
      final batch = _db.batch();
      final newHostId = snap.docs.first.id;
      batch.update(roomRef, {'hostUserId': newHostId});
      for (var i = 0; i < snap.docs.length; i++) {
        batch.update(snap.docs[i].reference, {'isHost': i == 0});
      }
      await batch.commit();
    }
    return _fetchRoom(roomId);
  }

  @override
  Future<FocusRoom> setParticipantPresence({
    required String roomId,
    required String userId,
    required ParticipantPresence presence,
  }) async {
    await _rooms.doc(roomId).collection('participants').doc(userId).update({
      'presence': presence.name,
    });
    return _fetchRoom(roomId);
  }

  @override
  Future<FocusRoom> startSession({
    required String roomId,
    required String hostUserId,
  }) async {
    final roomRef = _rooms.doc(roomId);
    final roomSnap = await roomRef.get();
    if (!roomSnap.exists) throw StateError('Room missing');
    final data = roomSnap.data()!;
    if (data['hostUserId'] != hostUserId) {
      throw StateError('Only the host can start the session');
    }
    final durationMinutes = (data['durationMinutes'] as num).toInt();
    final ends = DateTime.now().toUtc().add(Duration(minutes: durationMinutes));

    final partSnap = await roomRef.collection('participants').get();
    final batch = _db.batch();
    batch.update(roomRef, {
      'phase': FocusRoomPhase.running.name,
      'sessionEndsAt': Timestamp.fromDate(ends),
    });
    for (final doc in partSnap.docs) {
      final pr = doc.data();
      final pres = _parsePresence(pr['presence'] as String?);
      if (pres == ParticipantPresence.left) continue;
      if (pres == ParticipantPresence.inLobby ||
          pres == ParticipantPresence.ready) {
        batch.update(doc.reference, {
          'presence': ParticipantPresence.focusing.name,
        });
      }
    }
    await batch.commit();
    return _fetchRoom(roomId);
  }

  @override
  Future<FocusRoom> completeSessionNatural(String roomId) async {
    final roomRef = _rooms.doc(roomId);
    final rs = await roomRef.get();
    if (!rs.exists) throw StateError('Room missing');
    if (_parsePhase(rs.data()!['phase'] as String?) == FocusRoomPhase.ended) {
      return _fetchRoom(roomId);
    }

    final partSnap = await roomRef.collection('participants').get();
    final batch = _db.batch();
    batch.update(roomRef, {
      'phase': FocusRoomPhase.ended.name,
      'sessionEndsAt': FieldValue.delete(),
    });
    for (final doc in partSnap.docs) {
      final pres = _parsePresence(doc.data()['presence'] as String?);
      if (pres == ParticipantPresence.focusing ||
          pres == ParticipantPresence.paused) {
        batch.update(doc.reference, {
          'presence': ParticipantPresence.completed.name,
        });
      }
    }
    await batch.commit();
    return _fetchRoom(roomId);
  }

  @override
  Future<FocusRoom> markParticipantLeftDuringSession({
    required String roomId,
    required String userId,
  }) async {
    final roomRef = _rooms.doc(roomId);
    final batch = _db.batch();
    batch.update(roomRef, {
      'phase': FocusRoomPhase.ended.name,
      'sessionEndsAt': FieldValue.delete(),
    });
    batch.update(roomRef.collection('participants').doc(userId), {
      'presence': ParticipantPresence.left.name,
    });
    await batch.commit();
    return _fetchRoom(roomId);
  }

  @override
  Stream<FocusRoom?> watchRoom(String roomId) {
    final ref = _rooms.doc(roomId);
    return Rx.combineLatest2<
      DocumentSnapshot<Map<String, dynamic>>,
      QuerySnapshot<Map<String, dynamic>>,
      FocusRoom?
    >(
      ref.snapshots(),
      ref.collection('participants').snapshots(),
      (roomSnap, partSnap) => _fromRoomAndParts(roomSnap, partSnap.docs),
    );
  }
}
