// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MONK MODE';

  @override
  String get appSubtitle => 'DOPAMINE DETOX';

  @override
  String get taglineSessionsZero => 'Your detox starts now.';

  @override
  String get taglineStreakZero => 'Rebuild your streak today.';

  @override
  String get taglineStreakLt3 => 'Keep the momentum going.';

  @override
  String get taglineStreakLt7 => 'Your focus is sharpening.';

  @override
  String get taglineStreakGe7 => 'You are in control.';

  @override
  String get dopamineScoreTitle => 'DOPAMINE SCORE';

  @override
  String get dopamineLabel0 => 'Start your first session.';

  @override
  String get dopamineLabel20 => 'Your detox journey has begun.';

  @override
  String get dopamineLabel45 => 'Building mental resistance.';

  @override
  String get dopamineLabel70 => 'Your clarity is growing.';

  @override
  String get dopamineLabel90 => 'Strong focus and discipline.';

  @override
  String get dopamineLabel100 => 'Peak mental clarity achieved.';

  @override
  String get dayStreakSuffix => 'day streak';

  @override
  String bestStreak(int days) {
    return 'Best: $days days';
  }

  @override
  String get todayLabel => 'TODAY';

  @override
  String get focusTimeStatLabel => 'Focus time';

  @override
  String get sessionsDoneStatLabel => 'Sessions done';

  @override
  String get heroTitle => 'Enter Monk Mode.';

  @override
  String get startMonkMode => 'START MONK MODE';

  @override
  String get focusTogether => 'FOCUS TOGETHER';

  @override
  String get circleJourneySection => 'CIRCLE JOURNEY';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get statsTooltip => 'Statistics';

  @override
  String get joinRoomNotFoundCloud =>
      'No open lobby for that code, or the host already started or left.';

  @override
  String get joinRoomNotFoundLocal =>
      'No lobby here. Create a room on this phone, then join with that code.';

  @override
  String get joinRoomNetworkError =>
      'Could not reach the server. Check your connection and try again.';

  @override
  String get resetDataMessage =>
      'This removes your streak, score, stats, session history, session length chips, and Focus Together name on this device. If you use cloud rooms, you will get a new anonymous account. This cannot be undone.';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsFocus => 'FOCUS';

  @override
  String get settingsLegal => 'LEGAL';

  @override
  String get settingsData => 'DATA';

  @override
  String get settingsResetCleared => 'All local data has been cleared.';

  @override
  String get settingsLanguage => 'LANGUAGE';

  @override
  String get languageEnglishName => 'English';

  @override
  String get languageTurkishName => 'Türkçe';

  @override
  String get languagePickerSubtitle => 'Optional — default is English.';

  @override
  String get updateScreenAppBar => 'UPDATE';

  @override
  String get updateAvailableTitle => 'Update available';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateAvailableBody =>
      'A newer version of Monk Mode is on the store. Update to get the latest fixes and improvements.';

  @override
  String get updateRequiredBody =>
      'This version is no longer supported. Install the latest Monk Mode from the store to continue.';

  @override
  String updateInstalledVersion(String version) {
    return 'Installed: $version';
  }

  @override
  String updateStoreVersion(String version) {
    return 'Store: $version';
  }

  @override
  String get updateOpenStore => 'UPDATE IN STORE';

  @override
  String get updateNotNow => 'NOT NOW';

  @override
  String get updateStoreOpenFailed =>
      'Could not open the store. Try again or open the app page manually.';

  @override
  String get updateVersionStatusTitle => 'VERSIONS';

  @override
  String get updateYouAreOn => 'On this device';

  @override
  String get updateLatestIs => 'Latest on store';

  @override
  String get updateBadgeRequired => 'REQUIRED';

  @override
  String get updateBadgeRecommended => 'RECOMMENDED';

  @override
  String get updateReleaseNotesTitle => 'DETAILS';

  @override
  String get updateOpenStoreHint =>
      'Opens Google Play or the App Store so you can install the update.';

  @override
  String get updateTapToOpenStore =>
      'Tap anywhere to open the store and install the update.';

  @override
  String get settingsCheckForUpdates => 'Check for updates';

  @override
  String get settingsCheckForUpdatesSubtitle =>
      'See if a newer version is on the store';

  @override
  String get settingsAppUpToDate => 'You are on the latest version.';

  @override
  String get settingsSessionChipsTitle => 'Session length chips';

  @override
  String get settingsPrivacyTitle => 'Privacy policy';

  @override
  String get settingsPrivacySubtitle => 'How we handle your data';

  @override
  String get settingsResetTitle => 'Reset all data';

  @override
  String get settingsResetSubtitle => 'Clear stats and history on this device';

  @override
  String get settingsLinkOpenFailed => 'Could not open the link.';

  @override
  String get resetDialogTitle => 'Reset all data?';

  @override
  String get resetDialogCancel => 'CANCEL';

  @override
  String get resetDialogConfirm => 'RESET';

  @override
  String get durationPresetsTitle => 'FOCUS LENGTHS';

  @override
  String get durationPresetsIntro =>
      'Pick three options for the timer screen. They must all be different.';

  @override
  String get durationPresetsFirst => 'FIRST CHIP';

  @override
  String get durationPresetsSecond => 'SECOND CHIP';

  @override
  String get durationPresetsThird => 'THIRD CHIP';

  @override
  String get durationPresetsSave => 'SAVE';

  @override
  String get durationPresetsDistinctError => 'Choose three different lengths.';

  @override
  String durationMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String durationHoursShort(int hours) {
    return '$hours h';
  }

  @override
  String durationHoursMinutesShort(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get durationZeroCompact => '0m';

  @override
  String get statsTitle => 'STATS';

  @override
  String get statsYourStats => 'YOUR STATS';

  @override
  String get statsStreakJourney => 'STREAK JOURNEY';

  @override
  String get statsOutOf100 => '/ 100';

  @override
  String get statsCurrentStreak => 'Current Streak';

  @override
  String get statsCompleted => 'Completed';

  @override
  String get statsTotalFocus => 'Total Focus';

  @override
  String get statsBestStreak => 'Best Streak';

  @override
  String get statsUnitDay => 'day';

  @override
  String get statsUnitDays => 'days';

  @override
  String get statsUnitSession => 'session';

  @override
  String get statsUnitSessions => 'sessions';

  @override
  String statsLastSession(String date) {
    return 'Last session: $date';
  }

  @override
  String get statsSessionHistoryTitle => 'Session history';

  @override
  String get statsSessionHistorySubtitle => 'See every completed focus session';

  @override
  String get statsEmptyTitle => 'No sessions yet';

  @override
  String get statsEmptyBody =>
      'Complete your first Monk Mode session\nto see your stats here.';

  @override
  String get statsMilestoneBeyond => 'Beyond 30 days — legendary!';

  @override
  String statsMilestoneOneDayTo(int next) {
    return '1 day to $next-day milestone';
  }

  @override
  String statsMilestoneDaysTo(int days, int next) {
    return '$days days to $next-day milestone';
  }

  @override
  String get historyTitle => 'SESSION HISTORY';

  @override
  String get historyEmptyTitle => 'No sessions yet';

  @override
  String get historyEmptyBody =>
      'Complete a Monk Mode session to build your history here.';

  @override
  String historyRowDetail(String duration, String time) {
    return '$duration focus · $time';
  }

  @override
  String get monkLeaveTitle => 'Leave session?';

  @override
  String get monkLeaveBody =>
      'Your timer is still running. If you leave now, progress will be lost.';

  @override
  String get monkKeepGoing => 'KEEP GOING';

  @override
  String get monkLeaveAction => 'LEAVE';

  @override
  String get monkAppBarTitle => 'MONK MODE';

  @override
  String get monkBackHome => 'BACK TO HOME';

  @override
  String get monkReady => 'READY';

  @override
  String get monkFocus => 'FOCUS';

  @override
  String get monkPaused => 'PAUSED';

  @override
  String get monkDone => 'DONE';

  @override
  String get monkSelectDuration => 'SELECT DURATION';

  @override
  String get monkTestMode => 'TEST MODE';

  @override
  String get monkStartSession => 'START SESSION';

  @override
  String get monkReset => 'RESET';

  @override
  String get monkPause => 'PAUSE';

  @override
  String get monkResume => 'RESUME';

  @override
  String get monkBgPauseSnackbar =>
      'Focus pauses when you leave the app. Tap RESUME to continue.';

  @override
  String get monkStayAwakeHint =>
      'Screen stays on during focus so auto-lock won’t pause your session. Switching apps still pauses.';

  @override
  String get monkCompleteTitle => 'Session Complete';

  @override
  String get monkCompleteSubtitle => 'Great focus. Keep it up.';

  @override
  String get monkShareResult => 'SHARE RESULT';

  @override
  String get monkShareSubject => 'My Monk Mode Session';

  @override
  String get monkShareStatDuration => 'DURATION';

  @override
  String get monkShareStatStreak => 'STREAK';

  @override
  String get monkShareStatScore => 'SCORE';

  @override
  String get monkShareTagline => '\"Focus like a monk\"';

  @override
  String get monkShareStreakNew => 'New start';

  @override
  String get monkShareStreakOne => '1 day';

  @override
  String monkShareStreakMany(int days) {
    return '$days days';
  }

  @override
  String get ftHubTitle => 'FOCUS TOGETHER';

  @override
  String get ftHubHeadline => 'Focus together';

  @override
  String get ftHubBodyOnline =>
      'One shared timer. Share the code; friends join before the host starts.';

  @override
  String get ftHubBodyOffline =>
      'One timer per room on this device. Add Firebase to sync with other phones.';

  @override
  String get ftYourNameHeader => 'YOUR NAME IN ROOMS';

  @override
  String get ftNameFieldHint => 'e.g. Alex';

  @override
  String get ftNameHelp =>
      'Everyone sees this in the list. Each phone also gets a short tag (#AB12) so two similar names stay distinct.';

  @override
  String get ftSaveName => 'SAVE NAME';

  @override
  String get ftStartHere => 'START HERE';

  @override
  String get ftCreateRoomTitle => 'Create a room';

  @override
  String get ftCreateRoomSubtitle =>
      'You are the host—set length and share the code';

  @override
  String get ftJoinRoomTitle => 'Join with code';

  @override
  String get ftJoinRoomSubtitleOnline => 'Enter the code from your host';

  @override
  String get ftJoinRoomSubtitleOffline =>
      'Same phone as the host until Firebase is on';

  @override
  String get ftErrorNameEmpty => 'Enter a name your friends will recognize.';

  @override
  String get ftNameSavedSnackbar =>
      'Saved. Others will see this name in the room.';

  @override
  String get ftJoinAppBar => 'JOIN ROOM';

  @override
  String get ftJoinEnterCode => 'Enter the code';

  @override
  String get ftJoinCodeHelp => 'Usually 8 characters; not case-sensitive.';

  @override
  String get ftJoinCodeSection => 'ROOM CODE';

  @override
  String get ftJoinMinChars => 'Enter at least 4 characters.';

  @override
  String get ftJoinLobby => 'JOIN LOBBY';

  @override
  String get ftJoinTypingHint => 'Keep typing—codes are usually 8 characters.';

  @override
  String get ftCreateAppBar => 'NEW ROOM';

  @override
  String get ftCreateDurationQuestion => 'How long is the block?';

  @override
  String get ftCreateDurationHelp =>
      'Everyone sees the same length once you start. You can still leave the lobby anytime.';

  @override
  String get ftNameOptionalSection => 'NAME (OPTIONAL)';

  @override
  String get ftRoomNameHint => 'e.g. Deep work · Sunday';

  @override
  String get ftCreateOpenLobby => 'CREATE & OPEN LOBBY';

  @override
  String get ftLobbyTitle => 'LOBBY';

  @override
  String get ftLobbyEmptyTitle => 'No active lobby';

  @override
  String get ftLobbyEmptyBody =>
      'Room closed or reset. Go back to the hub to create or join again.';

  @override
  String get ftBackToHub => 'BACK TO HUB';

  @override
  String get ftDefaultRoomTitle => 'Your focus room';

  @override
  String get ftLobbyShareOnline =>
      'Share the code below so others can join from their phone.';

  @override
  String get ftLobbyShareOffline => 'This code only works on this phone.';

  @override
  String get ftLobbyGuestWait =>
      'Wait for the host to start. Tap ready when you are set.';

  @override
  String get ftInThisRoom => 'IN THIS ROOM';

  @override
  String get ftStartFocusTimer => 'START FOCUS TIMER';

  @override
  String get ftImReady => 'I\'M READY';

  @override
  String get ftSetToWaiting => 'SET TO WAITING';

  @override
  String get ftLeaveLobby => 'LEAVE LOBBY';

  @override
  String get ftPhaseLobby => 'Waiting';

  @override
  String get ftPhaseRunning => 'Live';

  @override
  String get ftPhaseEnded => 'Ended';

  @override
  String get ftSessionBlockSuffix => 'block';

  @override
  String ftLobbyHereCount(int count) {
    return '$count here';
  }

  @override
  String get ftLobbyMetaMiddle => ' · ';

  @override
  String get ftInSessionTitle => 'IN SESSION';

  @override
  String get ftEndSessionAction => 'END';

  @override
  String get ftSharedFocusDefaultName => 'Shared focus';

  @override
  String ftInRoomCount(int count) {
    return '$count in this room';
  }

  @override
  String get ftTimerFocusLabel => 'FOCUS';

  @override
  String get ftTogetherSection => 'TOGETHER';

  @override
  String get ftSessionSyncOnline =>
      'Same end time for everyone; updates sync from the room.';

  @override
  String get ftSessionSyncOffline => 'Timer is only on this device.';

  @override
  String get ftSessionUpdating => 'Updating…';

  @override
  String get ftBgSessionPausedSnackbar =>
      'Timer was paused while the app was in the background. Remaining time is synced with the room.';

  @override
  String get ftStayAwakeHint =>
      'Screen stays on during the session so auto-lock won’t freeze your timer. Leaving the app still pauses locally until you return.';

  @override
  String get ftRoomCodeLabel => 'ROOM CODE';

  @override
  String get ftCodeCopied => 'Code copied';

  @override
  String get frCrossHubTitleOn => 'Synced rooms';

  @override
  String get frCrossHubTitleOff => 'This device only';

  @override
  String get frCrossJoinTitleOn => 'Join from another phone';

  @override
  String get frCrossJoinTitleOff => 'Offline mode';

  @override
  String get frCrossLobbyTitleOn => 'Share this code';

  @override
  String get frCrossLobbyTitleOff => 'This code';

  @override
  String get frCrossHubBodyOn =>
      'Create a room, share the 8-character code, and friends open Focus Together → Join while the lobby is open.';

  @override
  String get frCrossHubBodyOff =>
      'Cloud sync is off, so rooms exist only on this phone. Configure Firebase to play across devices.';

  @override
  String get frCrossJoinBodyOn =>
      'Code must match (letters/numbers; case does not matter). It stops working if the host already started or left.';

  @override
  String get frCrossJoinBodyOff =>
      'Only a room created on this same phone can be opened here.';

  @override
  String get frCrossLobbyBodyOn =>
      'When everyone is in, tap Start focus timer. If someone cannot join, check the code and that you are still in the lobby.';

  @override
  String get frCrossLobbyBodyOff =>
      'This code only works on this phone until Firebase is configured.';

  @override
  String get ftLeaveSessionTitle => 'Leave this session?';

  @override
  String get ftLeaveSessionBody =>
      'The timer will stop for you and this room will close on your device. In a live app, others could keep going—here it ends for everyone in mock mode.';

  @override
  String get ftKeepFocusing => 'KEEP FOCUSING';

  @override
  String get ftEndSessionSheet => 'END SESSION';

  @override
  String get ftCircleHeadlineAllBadges => 'Every circle badge unlocked';

  @override
  String get ftCircleHeadlineKeepFinishing => 'Keep finishing together';

  @override
  String get ftCircleHeadlineNextReady => 'Next badge ready';

  @override
  String ftCircleOneSessionToBadge(String badge) {
    return '1 session to $badge';
  }

  @override
  String ftCircleSessionsToBadge(int count, String badge) {
    return '$count sessions to $badge';
  }

  @override
  String get ftCircleSublineAllDone =>
      'Come back with your group whenever you want — the ritual is yours.';

  @override
  String get ftCircleSublineStart =>
      'Finish a full session with others to start your circle journey.';

  @override
  String get ftBadgeAt1 => 'First light';

  @override
  String get ftBadgeAt3 => 'Momentum';

  @override
  String get ftBadgeAt5 => 'Squad rhythm';

  @override
  String get ftBadgeAt10 => 'Circle strength';

  @override
  String get ftBadgeAt15 => 'Deep bench';

  @override
  String get ftBadgeAt25 => 'Focus anchor';

  @override
  String get ftBadgeAt50 => 'Circle legend';

  @override
  String get ftChaseAt1 =>
      'Your first circle badge is one natural finish away.';

  @override
  String get ftChaseAt3 =>
      'Three finishes is where a group habit usually sticks.';

  @override
  String get ftChaseAt5 =>
      'Five sessions is when shared focus starts to feel normal.';

  @override
  String get ftChaseAt10 =>
      'Double digits is worth protecting — one room at a time.';

  @override
  String get ftChaseAt15 =>
      'You are past the novelty phase — keep the ritual alive.';

  @override
  String get ftChaseAt25 => 'The anchor badge is for groups that do not quit.';

  @override
  String get ftChaseAt50 => 'After this, the win is the habit itself.';

  @override
  String get ftFooterFinishesOne => '1 natural finish logged';

  @override
  String ftFooterFinishesMany(int count) {
    return '$count natural finishes logged';
  }

  @override
  String ftFooterAllDone(int count) {
    return '$count natural finishes — keep the ritual with your circle.';
  }

  @override
  String get summaryAppBarEarly => 'WRAP-UP';

  @override
  String get summaryAppBarDone => 'DONE';

  @override
  String get summaryHeadlineEarly => 'You stepped away';

  @override
  String get summaryHeadlineDone => 'Session complete';

  @override
  String get summarySubEarly => 'The room closed when you ended early.';

  @override
  String get summarySubNatural => 'Nice work staying in flow together.';

  @override
  String summaryEndedAt(String time) {
    return 'Ended at $time';
  }

  @override
  String get summaryDefaultRoom => 'Focus room';

  @override
  String get summaryCompleted => 'COMPLETED';

  @override
  String get summaryDidNotFinish => 'DID NOT FINISH';

  @override
  String get summaryCompletedEmptyTitle =>
      'No one is listed as completed for this run.';

  @override
  String get summaryCompletedEmptySubtitle =>
      'That can happen if the session ended early.';

  @override
  String get summaryBackMonk => 'BACK TO MONK MODE';

  @override
  String get summaryFocusAgain => 'FOCUS TOGETHER AGAIN';

  @override
  String get summaryRewardsNatural => 'Monk Mode rewards';

  @override
  String get summaryRewardsEarly => 'Small recovery bonus';

  @override
  String get summaryStreakLineOne =>
      '1 day streak · counts like a solo session';

  @override
  String summaryStreakLineMany(int days) {
    return '$days days streak · counts like a solo session';
  }

  @override
  String summaryClarityLine(int delta, String focus) {
    return 'Clarity +$delta total ($focus focus)';
  }

  @override
  String summarySquadBonus(int bonus) {
    return '+$bonus squad bonus for finishing alongside others.';
  }

  @override
  String summaryClarityNow(int score) {
    return 'Clarity now at $score';
  }

  @override
  String summaryEarlyClarityLine(int delta) {
    return 'Clarity +$delta (streak unchanged)';
  }

  @override
  String get summaryEarlyHint =>
      'Finish a full session with the group to move your streak and earn the big clarity gains.';

  @override
  String get summaryNextReturn => 'NEXT REASON TO RETURN';

  @override
  String get ftMil1Title => 'First light';

  @override
  String get ftMil1Sub =>
      'You finished a full session with others. That is the hardest step.';

  @override
  String get ftMil3Title => 'Momentum';

  @override
  String get ftMil3Sub =>
      'Three shared finishes — your group is turning focus into a habit.';

  @override
  String get ftMil5Title => 'Squad rhythm';

  @override
  String get ftMil5Sub =>
      'Five times you all stayed until the end. Consistency beats intensity.';

  @override
  String get ftMil10Title => 'Circle strength';

  @override
  String get ftMil10Sub =>
      'Ten shared wins. Most people never stack this — you are building something real.';

  @override
  String get ftMil15Title => 'Deep bench';

  @override
  String get ftMil15Sub =>
      'Fifteen natural finishes. Your circle shows up when it counts.';

  @override
  String get ftMil25Title => 'Focus anchor';

  @override
  String get ftMil25Sub =>
      'Twenty-five shared sessions. That is discipline most people never stack.';

  @override
  String get ftMil50Title => 'Circle legend';

  @override
  String get ftMil50Sub =>
      'Fifty natural finishes together. Save this screen — you earned it.';

  @override
  String get settingsBackup => 'GOOGLE';

  @override
  String get backupSignInTitle => 'Sign in with Google';

  @override
  String get backupSignInSubtitle =>
      'Link your Google account to back up streak and stats in the cloud (restore after reinstall)';

  @override
  String get backupSignedInTitle => 'Google backup active';

  @override
  String backupSignedInSubtitle(String email) {
    return 'Synced as $email';
  }

  @override
  String get backupSyncNow => 'SYNC NOW';

  @override
  String get backupSignOut => 'Sign out of backup';

  @override
  String get backupSignOutSubtitle => 'Stats stay on this device';

  @override
  String get backupSignInFailed =>
      'Could not sign in with Google. Please try again.';

  @override
  String get backupSignInDialogOk => 'OK';

  @override
  String get backupSignInDialogDeveloperTitle =>
      'Google sign-in (Android setup)';

  @override
  String get backupSignInDialogDeveloperBody =>
      'Google blocked sign-in because the certificate that signed this install is not registered in Firebase.\n\nIf you installed from Google Play: Play Console → your app → Release (or Testing) → App integrity → App signing. Copy SHA-1 under App signing key certificate (not the upload key). In Firebase: Project settings → your Android app → Add fingerprint. Then download google-services.json again, replace android/app/google-services.json, and publish a new release.\n\nIf you use a local debug or release APK, add the SHA-1 from android/ gradlew signingReport (Variant: debug or release) instead.';

  @override
  String get backupSignInDialogTokenTitle => 'Google sign-in (token)';

  @override
  String get backupSignInDialogTokenBody =>
      'The app could not get an ID token from Google. In Firebase Console, re-download google-services.json after your SHA-1 fingerprints are added, and confirm lib/config/backup_sign_in_config.dart has the Web client ID (type 3 in json). Then create a new release build.';

  @override
  String get backupSynced => 'Stats backed up to Google.';

  @override
  String get backupSyncFailed => 'Backup failed. Check your connection.';

  @override
  String get backupRestoreTitle => 'Restore from cloud?';

  @override
  String backupRestoreBody(int sessions, int streak) {
    return 'Your Google backup has $sessions sessions and a $streak-day streak. Restore it to this device? Current local data will be replaced.';
  }

  @override
  String get backupRestoreConfirm => 'RESTORE';

  @override
  String get backupRestoreCancel => 'KEEP LOCAL';

  @override
  String get backupRestored => 'Stats restored from your Google backup.';

  @override
  String get backupSignOutConfirmTitle => 'Sign out of backup?';

  @override
  String get backupSignOutConfirmBody =>
      'Your stats stay on this device but will no longer sync to Google.';

  @override
  String get backupSignOutConfirm => 'SIGN OUT';

  @override
  String get backupSignOutCancel => 'CANCEL';
}
