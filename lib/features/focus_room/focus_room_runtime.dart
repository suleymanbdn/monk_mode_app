import 'data/focus_room_repository.dart';

/// Set to true after Firebase + Firestore init succeeds ([main.dart]).
bool focusRoomCloudSyncEnabled = false;

FocusRoomRepository? _focusRoomRepository;

void registerFocusRoomRepository(FocusRoomRepository repository) {
  _focusRoomRepository = repository;
}

FocusRoomRepository get focusRoomRepository {
  final r = _focusRoomRepository;
  if (r == null) {
    throw StateError('registerFocusRoomRepository must be called from main()');
  }
  return r;
}
