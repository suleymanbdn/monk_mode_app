# Changelog

All notable changes to **Monk Mode** are documented here.  
Version format: `major.minor.patch+build` (Flutter / Play / App Store).

## [1.4.12+28] — 2026-05-02

### Release

- Play **versionCode** 28 / **versionName** 1.4.12 — store build.

## [1.4.11+27] — 2026-05-01

### Release

- Play **versionCode** 27 / **versionName** 1.4.11 — store build.

### UX

- Floating, rounded SnackBar theme globally; Focus Together hubs: dismiss keyboard by tapping outside; TextField Done/Go actions; PrimaryButton light haptics; Monk Mode session start/pause/complete haptics.

### Fixed

- Focus Together: if someone else ends the shared session early, remaining participants now get the correct summary and rewards path (no longer treated as a natural group completion).

## [1.4.4+20] — 2026-04-25

### Release

- Play **versionCode** 20 / **versionName** 1.4.4 — store build; same features as 1.4.3 (Settings → GOOGLE giriş konumu ve metinleri).

## [1.4.3+19] — 2026-04-25

### Fixed / UX

- **Settings — Google yedek:** "YEDEK" bölümü sürümün hemen altına taşındı (aşağı kaydırma gerekmeden görünür). Giriş satırı **"Google ile giriş yap"** ve bölüm başlığı **GOOGLE**; ikon `login` ile daha net. EN metin: "Sign in with Google".

## [1.4.2+18] — 2026-04-25

### Release / operations

- **Firebase Authentication:** Google ve Anonymous giriş yöntemleri projede etkin; Google yedek ve Focus Together bulut akışı üretim konsolu ile uyumlu.
- **Android:** Debug ve release **SHA-1** parmak izleri Firebase’deki Android uygulamasına kayıtlı (Google Sign-In).
- **Firestore:** Güvenlik kuralları ve index tanımları `monk-mode-focus-together` projesine deploy edildi; eski `code+phase` bileşik index kaldırıldı.

## [1.4.1+17] — 2026-04-25

### Security

- **Focus Together — Firestore:** Oda belge ID’si artık 8 haneli oda kodu ile aynı; `focus_rooms` için **koleksiyon list sorguları yasak** (`list: if false`); join ve izleme yalnızca **get(docId)** ile. Tüm açık lobilerin taranması engellendi.
- **Oda oluşturma:** Aynı kod için yarışları önlemek için oda + host katılımcısı tek **transaction** ile yazılıyor; `create` kuralında `code == roomId` doğrulaması.
- **Katılımcılar:** `get` / `list` sadece oda üyelerine (+ join öncesi kendi `uid` yoluna tek `get`); sunucu kuralları ile netleştirildi.
- **Kırılım:** Daha önce rastgele belge ID’siyle oluşturulmuş (eski şema) bulut odalar bu sürümden sonra **koda göre bulunamaz** — açık lobileri yeniden oluşturmak gerekir. Yerel (bellek) mod etkilenmez.

## [1.4.0+16] — 2026-04-25

### Added

- **Google backup:** Users can now sign in with Google in Settings → BACKUP to back up their streak, dopamine score, and session stats to the cloud. Stats are restored automatically when signing in on a fresh install, keeping progress safe across reinstalls.
- **Conflict resolution:** If the cloud backup has more sessions than the local device, the app offers a restore dialog; otherwise local data is uploaded immediately.
- **Firestore rules:** Added `users/{userId}` collection — owner-only read/write so no other user can access another's backup.
- **`StorageService`:** Added `loadTogetherTotal()` and `restoreFromCloudStats()` helpers used by the backup flow.

### Security (hardening pass)

- **Firestore — user backup:** `users/{userId}` now enforces a fixed set of fields, integer bounds, `syncedAt == request.time`, and optional `lastSessionDate` in `YYYY-MM-DD` form. Only `get` (not `list`) is allowed so the collection cannot be enumerated.
- **Firestore — room create:** `focus_rooms` create must use exactly the seven documented fields (`hasOnly`); `sessionEndsAt` must be null; `createdAt` must be the server timestamp (`request.time`) so clients cannot inject arbitrary data or oversized maps.
- **Client:** `AppStats` JSON parsing tolerates `num` from Firestore; backup upload/download values are clamped/sanitised in `FirestoreValueUtils`.
- **Store URLs:** `itunes.apple.com` added to the trusted list for `app_config` store links (with `play.google.com` / `apps.apple.com` / HTTPS).
- **Privacy link:** opening the privacy policy only proceeds if the URL is HTTPS and the host is `suleymanbdn.github.io` (defence in depth if the constant is ever changed).

## [1.3.1+15] � 2026-04-20

### Security

- **Firestore rules:** Removed overly-permissive `isRoomMember` from participant updates � members may now only change the `presence` field of other participants (needed for natural-complete), not `isHost` or `displayName`.
- **Firestore rules:** Added field-level validation on room `create` � code must be 8 chars, name ? 40 chars, duration 5�180 min; only documented fields accepted.
- **Firestore rules:** Non-host members can only write `phase=ended` + clear `sessionEndsAt` on the room document (covers leave-early and natural-complete); prevents arbitrary field tampering.
- **Open-redirect:** `store_url` read from Firestore `app_config` is now validated to be an HTTPS URL on `play.google.com` or `apps.apple.com` before `launchUrl` is called.
- **Input sanitisation:** Room name and display name are length-capped (40 / 20 chars) and trimmed in `FirestoreFocusRoomRepository` before any Firestore write; room name `TextField` enforces `maxLength: 40`.

## [1.3.0+14] � 2026-04-20

### Changed

- **Code cleanup:** Removed dead unreachable branch in `loadFocusTogetherCircleProgress`, fixed misplaced comment block, eliminated double `AppStorageScope.maybeOf` lookup, and stripped redundant inline section comments throughout UI files.

## [1.2.9+13] — 2026-04-08

### Changed

- **Focus Together code clarity:** Removed duplicate English “circle” copy from the progress model and from `FocusTogetherReward`. Session summary “next return” uses **localized** strings from `FocusTogetherCircleProgress` only.

## [1.2.8+12] — 2026-04-08

### Improved

- **Focus timers & auto-lock:** While **Monk Mode** or a **Focus Together** session is **running**, the device keeps the **screen awake** (`wakelock_plus`) so **display sleep no longer pauses** the timer. **Switching apps / background** still pauses as before. Short in-app hint (EN/TR); Android **`WAKE_LOCK`** declared.

## [1.2.7+11] — 2026-04-08

### Fixed / improved

- **Language persistence:** App UI language is **awaited** to disk when changed (Settings → Language) so **Türkçe survives app restart** reliably.
- **Full EN/TR UI sweep:** Replaced hardcoded English across **Settings**, duration presets, **Stats**, session history, **Monk Mode**, and **Focus Together** (hub, join, create, lobby, shared session, summary, cross-device hints, circle journey). Duration labels and dates follow the active locale.

## [1.2.6+10] — 2026-04-07

### Fixed

- **In-app update prompt:** Runs when **Firebase Core** is initialized, not only when Focus Together cloud sync is on. Split **`Firebase.initializeApp`** and **anonymous sign-in** in `main.dart` so `app_config` can still be read if auth fails.
- **Update screen:** Localized (**EN/TR**), clearer copy (“update available” / “update required”), store open error **SnackBar**, and **navigator retry** so the route pushes reliably after launch.

## [1.2.5+9] — 2026-04-07

### Release

- **Play / store build 9** — ships the **codebase cleanup** in 1.2.4+8 (no demo bots, smaller Focus Together stack, leaner home screen). User-facing behavior matches 1.2.4 unless noted in that entry.

## [1.2.4+8] — 2026-04-07

### Release

- **Play / store build 8** — includes 1.2.3 changes below (Firestore rules + anon auth, join error UX, reset scope, accessibility, tests) and **English-by-default UI** with **Settings → Language** for Turkish.

### Removed / simplified

- In-memory **demo bots** (Jordan/Sam), **`applySimulationTick`**, and related timer noise.
- **`join_room_result.dart`**, **`focus_together_auth.dart`** (logic folded into `focus_room_repository.dart` / `FocusRoomIdentity`).
- Legacy **`Mock*`** typedefs, **`FocusRoomConfig`**, **`avatarSeed`**, duplicate **VIEW STATS** home CTA, public **`dopaminePointsForSessionMinutes`**, unused **`viewStats`** l10n key.
- Stub **`docs/GUNCELLEME_NOTLARI.md`**; **README** trimmed. Store copy: **`docs/RELEASE_NOTES.md`** only.

## [1.2.3+7] — 2026-04-07

### Added

- **Localization (`en` + `tr`):** UI **defaults to English**; **Settings → Language** switches to Turkish. Home, settings (including reset copy), and Focus Together join errors use the selected language.
- **Firebase Anonymous Auth** so Focus Together can use Firestore with authenticated clients.
- **Unit tests** for `StorageService` (streak rules, dopamine tiers, reset including duration presets).

### Changed

- **Firestore security rules**: `focus_rooms` / `participants` no longer world-writable; access tied to signed-in users, host, and room membership.
- **Focus Together identity**: uses Firebase `uid` when cloud sync is on; local `u_*` id when offline-only.
- **Join by code**: distinguishes “lobby not found” from **network / server** errors with clearer messages.
- **Settings → Reset all data**: also clears session length presets and Focus Together name; rotates anonymous Firebase user when cloud is enabled.
- **Home header**: settings/stats actions use `IconButton` + tooltips for accessibility.
- **Host handoff**: when the host leaves a lobby, `hostUserId` on the room document updates so the last member can delete the room under strict rules.

### Notes

- Firebase Console: enable **Anonymous** sign-in; deploy updated **`firestore.rules`** before or with this release.
- Existing rooms created under pre-auth clients may require users to **create a new room** after updating.

## [1.2.0+4] — 2026-04-01

### Added

- **Focus Together (Focus Room)**: create or join a room with a code, lobby with participants, shared session timer, session summary, and local mock state (ready for Firebase/Supabase later).
- Hub entry from home: **FOCUS TOGETHER**.
- Leave-session and skip confirmations (bottom sheet), subtle route transitions, loading states, and polished timer visuals.

### Changed

- Settings screen continues to show version from `package_info` (reads `pubspec.yaml` at build time).

### Notes

- Focus Room state is **on-device only** in this release; no cloud sync yet.
- **Android build 4:** `flutter build apk` + `flutter build appbundle` release artifacts.

## [1.1.0+2] — earlier

- Baseline with Monk Mode timer, dopamine score, streaks, stats, and settings.
