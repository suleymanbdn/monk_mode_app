# Pre-release checklist (Monk Mode)

Complete before shipping a store build.

## Version and build

- [ ] `pubspec.yaml` `version:` is correct (currently **1.4.4+20**).
- [ ] `flutter clean` → `flutter pub get` → `flutter analyze` — no issues.
- [ ] `flutter test` — all tests pass.
- [ ] **Android:** `flutter build appbundle` (or `apk`) — signing and `versionCode` match Play Console.
- [ ] **iOS:** `flutter build ipa` — version / build in Xcode match `pubspec`.

## Store copy

- [ ] Paste short / medium text from **`docs/RELEASE_NOTES.md`** into Play and App Store “What’s new”.
- [ ] Screenshots: home, Focus Together hub, lobby or session (recommended).
- [ ] Privacy / data: store text matches the app (Focus Together uses **Firebase / cloud** when enabled; see privacy policy).

## Final checks

- [ ] Settings shows version **1.3.1 (15)** (from `package_info` + `pubspec`).
- [ ] Core flows: Monk Mode, stats, Focus Together (create → lobby → start → summary).
- [ ] Back / leave confirmations behave as expected.

## After release

- [ ] Update `CHANGELOG.md` for the next release.
- [ ] Optional git tag: `v1.3.1`

---

*Developer log: `CHANGELOG.md` at repo root.*
