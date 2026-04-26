# Release notes (Monk Mode)

English copy for **Google Play** and **App Store** "What's new".  
Current version: **1.4.4** (build **20**).

---

## Short (~80 characters)

```
1.4.2: Production Firebase — Google + Anonymous sign-in; secure cloud rooms & backup.
```

---

## Medium (bulleted, default store list)

```
• 1.4.2: Firebase Auth (Google + Anonymous) and SHA certificates aligned for store builds; Firestore rules deployed for secure rooms and backup
• 1.4.1: Room codes = document IDs; recreate open lobbies if you used an older build
• Google backup in Settings; streak restore on reinstall
```

---

## Long (full release notes / web)

**What's new in 1.4.2**

- **Operations:** The Firebase project is configured for production use: **Google** and **Anonymous** sign-in enabled, **Android SHA-1** fingerprints (debug and release) registered, and **Firestore** security rules and indexes deployed. No app logic change from 1.4.1 — this build is the recommended release for the Play store.

**What's new in 1.4.1**

- **Focus Together / Firestore:** Room documents use the **8-character room code as the document ID**. Security rules **deny collection listing** on `focus_rooms`. **Important:** Lobbies from app versions **before 1.4.1** used random document IDs — create a **new room** and share the new code.

**What's new in 1.4.0**

- **Google Backup** in Settings; restore on fresh install; owner-only `users/{uid}` stats in Firestore.

**Earlier improvements (1.3.x)**

- Firestore security, open-redirect protection for store URLs, input sanitisation for rooms.

---

*Last updated: April 25, 2026 (1.4.4 build 20)*
