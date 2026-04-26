import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MONK MODE'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DOPAMINE DETOX'**
  String get appSubtitle;

  /// No description provided for @taglineSessionsZero.
  ///
  /// In en, this message translates to:
  /// **'Your detox starts now.'**
  String get taglineSessionsZero;

  /// No description provided for @taglineStreakZero.
  ///
  /// In en, this message translates to:
  /// **'Rebuild your streak today.'**
  String get taglineStreakZero;

  /// No description provided for @taglineStreakLt3.
  ///
  /// In en, this message translates to:
  /// **'Keep the momentum going.'**
  String get taglineStreakLt3;

  /// No description provided for @taglineStreakLt7.
  ///
  /// In en, this message translates to:
  /// **'Your focus is sharpening.'**
  String get taglineStreakLt7;

  /// No description provided for @taglineStreakGe7.
  ///
  /// In en, this message translates to:
  /// **'You are in control.'**
  String get taglineStreakGe7;

  /// No description provided for @dopamineScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'DOPAMINE SCORE'**
  String get dopamineScoreTitle;

  /// No description provided for @dopamineLabel0.
  ///
  /// In en, this message translates to:
  /// **'Start your first session.'**
  String get dopamineLabel0;

  /// No description provided for @dopamineLabel20.
  ///
  /// In en, this message translates to:
  /// **'Your detox journey has begun.'**
  String get dopamineLabel20;

  /// No description provided for @dopamineLabel45.
  ///
  /// In en, this message translates to:
  /// **'Building mental resistance.'**
  String get dopamineLabel45;

  /// No description provided for @dopamineLabel70.
  ///
  /// In en, this message translates to:
  /// **'Your clarity is growing.'**
  String get dopamineLabel70;

  /// No description provided for @dopamineLabel90.
  ///
  /// In en, this message translates to:
  /// **'Strong focus and discipline.'**
  String get dopamineLabel90;

  /// No description provided for @dopamineLabel100.
  ///
  /// In en, this message translates to:
  /// **'Peak mental clarity achieved.'**
  String get dopamineLabel100;

  /// No description provided for @dayStreakSuffix.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get dayStreakSuffix;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best: {days} days'**
  String bestStreak(int days);

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todayLabel;

  /// No description provided for @focusTimeStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get focusTimeStatLabel;

  /// No description provided for @sessionsDoneStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions done'**
  String get sessionsDoneStatLabel;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Monk Mode.'**
  String get heroTitle;

  /// No description provided for @startMonkMode.
  ///
  /// In en, this message translates to:
  /// **'START MONK MODE'**
  String get startMonkMode;

  /// No description provided for @focusTogether.
  ///
  /// In en, this message translates to:
  /// **'FOCUS TOGETHER'**
  String get focusTogether;

  /// No description provided for @circleJourneySection.
  ///
  /// In en, this message translates to:
  /// **'CIRCLE JOURNEY'**
  String get circleJourneySection;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @statsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTooltip;

  /// No description provided for @joinRoomNotFoundCloud.
  ///
  /// In en, this message translates to:
  /// **'No open lobby for that code, or the host already started or left.'**
  String get joinRoomNotFoundCloud;

  /// No description provided for @joinRoomNotFoundLocal.
  ///
  /// In en, this message translates to:
  /// **'No lobby here. Create a room on this phone, then join with that code.'**
  String get joinRoomNotFoundLocal;

  /// No description provided for @joinRoomNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection and try again.'**
  String get joinRoomNetworkError;

  /// No description provided for @resetDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes your streak, score, stats, session history, session length chips, and Focus Together name on this device. If you use cloud rooms, you will get a new anonymous account. This cannot be undone.'**
  String get resetDataMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @settingsFocus.
  ///
  /// In en, this message translates to:
  /// **'FOCUS'**
  String get settingsFocus;

  /// No description provided for @settingsLegal.
  ///
  /// In en, this message translates to:
  /// **'LEGAL'**
  String get settingsLegal;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get settingsData;

  /// No description provided for @settingsResetCleared.
  ///
  /// In en, this message translates to:
  /// **'All local data has been cleared.'**
  String get settingsResetCleared;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsLanguage;

  /// No description provided for @languageEnglishName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishName;

  /// No description provided for @languageTurkishName.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkishName;

  /// No description provided for @languagePickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — default is English.'**
  String get languagePickerSubtitle;

  /// No description provided for @updateScreenAppBar.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get updateScreenAppBar;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailableTitle;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequiredTitle;

  /// No description provided for @updateAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A newer version of Monk Mode is on the store. Update to get the latest fixes and improvements.'**
  String get updateAvailableBody;

  /// No description provided for @updateRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. Install the latest Monk Mode from the store to continue.'**
  String get updateRequiredBody;

  /// No description provided for @updateInstalledVersion.
  ///
  /// In en, this message translates to:
  /// **'Installed: {version}'**
  String updateInstalledVersion(String version);

  /// No description provided for @updateStoreVersion.
  ///
  /// In en, this message translates to:
  /// **'Store: {version}'**
  String updateStoreVersion(String version);

  /// No description provided for @updateOpenStore.
  ///
  /// In en, this message translates to:
  /// **'UPDATE IN STORE'**
  String get updateOpenStore;

  /// No description provided for @updateNotNow.
  ///
  /// In en, this message translates to:
  /// **'NOT NOW'**
  String get updateNotNow;

  /// No description provided for @updateStoreOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the store. Try again or open the app page manually.'**
  String get updateStoreOpenFailed;

  /// No description provided for @updateVersionStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'VERSIONS'**
  String get updateVersionStatusTitle;

  /// No description provided for @updateYouAreOn.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get updateYouAreOn;

  /// No description provided for @updateLatestIs.
  ///
  /// In en, this message translates to:
  /// **'Latest on store'**
  String get updateLatestIs;

  /// No description provided for @updateBadgeRequired.
  ///
  /// In en, this message translates to:
  /// **'REQUIRED'**
  String get updateBadgeRequired;

  /// No description provided for @updateBadgeRecommended.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get updateBadgeRecommended;

  /// No description provided for @updateReleaseNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get updateReleaseNotesTitle;

  /// No description provided for @updateOpenStoreHint.
  ///
  /// In en, this message translates to:
  /// **'Opens Google Play or the App Store so you can install the update.'**
  String get updateOpenStoreHint;

  /// No description provided for @updateTapToOpenStore.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to open the store and install the update.'**
  String get updateTapToOpenStore;

  /// No description provided for @settingsCheckForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get settingsCheckForUpdates;

  /// No description provided for @settingsCheckForUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See if a newer version is on the store'**
  String get settingsCheckForUpdatesSubtitle;

  /// No description provided for @settingsAppUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You are on the latest version.'**
  String get settingsAppUpToDate;

  /// No description provided for @settingsSessionChipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session length chips'**
  String get settingsSessionChipsTitle;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get settingsPrivacySubtitle;

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear stats and history on this device'**
  String get settingsResetSubtitle;

  /// No description provided for @settingsLinkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get settingsLinkOpenFailed;

  /// No description provided for @resetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get resetDialogTitle;

  /// No description provided for @resetDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get resetDialogCancel;

  /// No description provided for @resetDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get resetDialogConfirm;

  /// No description provided for @durationPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'FOCUS LENGTHS'**
  String get durationPresetsTitle;

  /// No description provided for @durationPresetsIntro.
  ///
  /// In en, this message translates to:
  /// **'Pick three options for the timer screen. They must all be different.'**
  String get durationPresetsIntro;

  /// No description provided for @durationPresetsFirst.
  ///
  /// In en, this message translates to:
  /// **'FIRST CHIP'**
  String get durationPresetsFirst;

  /// No description provided for @durationPresetsSecond.
  ///
  /// In en, this message translates to:
  /// **'SECOND CHIP'**
  String get durationPresetsSecond;

  /// No description provided for @durationPresetsThird.
  ///
  /// In en, this message translates to:
  /// **'THIRD CHIP'**
  String get durationPresetsThird;

  /// No description provided for @durationPresetsSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get durationPresetsSave;

  /// No description provided for @durationPresetsDistinctError.
  ///
  /// In en, this message translates to:
  /// **'Choose three different lengths.'**
  String get durationPresetsDistinctError;

  /// No description provided for @durationMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutesShort(int minutes);

  /// No description provided for @durationHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String durationHoursShort(int hours);

  /// No description provided for @durationHoursMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutesShort(int hours, int minutes);

  /// No description provided for @durationZeroCompact.
  ///
  /// In en, this message translates to:
  /// **'0m'**
  String get durationZeroCompact;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'STATS'**
  String get statsTitle;

  /// No description provided for @statsYourStats.
  ///
  /// In en, this message translates to:
  /// **'YOUR STATS'**
  String get statsYourStats;

  /// No description provided for @statsStreakJourney.
  ///
  /// In en, this message translates to:
  /// **'STREAK JOURNEY'**
  String get statsStreakJourney;

  /// No description provided for @statsOutOf100.
  ///
  /// In en, this message translates to:
  /// **'/ 100'**
  String get statsOutOf100;

  /// No description provided for @statsCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get statsCurrentStreak;

  /// No description provided for @statsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statsCompleted;

  /// No description provided for @statsTotalFocus.
  ///
  /// In en, this message translates to:
  /// **'Total Focus'**
  String get statsTotalFocus;

  /// No description provided for @statsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get statsBestStreak;

  /// No description provided for @statsUnitDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get statsUnitDay;

  /// No description provided for @statsUnitDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get statsUnitDays;

  /// No description provided for @statsUnitSession.
  ///
  /// In en, this message translates to:
  /// **'session'**
  String get statsUnitSession;

  /// No description provided for @statsUnitSessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get statsUnitSessions;

  /// No description provided for @statsLastSession.
  ///
  /// In en, this message translates to:
  /// **'Last session: {date}'**
  String statsLastSession(String date);

  /// No description provided for @statsSessionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get statsSessionHistoryTitle;

  /// No description provided for @statsSessionHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'See every completed focus session'**
  String get statsSessionHistorySubtitle;

  /// No description provided for @statsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get statsEmptyTitle;

  /// No description provided for @statsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete your first Monk Mode session\nto see your stats here.'**
  String get statsEmptyBody;

  /// No description provided for @statsMilestoneBeyond.
  ///
  /// In en, this message translates to:
  /// **'Beyond 30 days — legendary!'**
  String get statsMilestoneBeyond;

  /// No description provided for @statsMilestoneOneDayTo.
  ///
  /// In en, this message translates to:
  /// **'1 day to {next}-day milestone'**
  String statsMilestoneOneDayTo(int next);

  /// No description provided for @statsMilestoneDaysTo.
  ///
  /// In en, this message translates to:
  /// **'{days} days to {next}-day milestone'**
  String statsMilestoneDaysTo(int days, int next);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'SESSION HISTORY'**
  String get historyTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete a Monk Mode session to build your history here.'**
  String get historyEmptyBody;

  /// No description provided for @historyRowDetail.
  ///
  /// In en, this message translates to:
  /// **'{duration} focus · {time}'**
  String historyRowDetail(String duration, String time);

  /// No description provided for @monkLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave session?'**
  String get monkLeaveTitle;

  /// No description provided for @monkLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'Your timer is still running. If you leave now, progress will be lost.'**
  String get monkLeaveBody;

  /// No description provided for @monkKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'KEEP GOING'**
  String get monkKeepGoing;

  /// No description provided for @monkLeaveAction.
  ///
  /// In en, this message translates to:
  /// **'LEAVE'**
  String get monkLeaveAction;

  /// No description provided for @monkAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'MONK MODE'**
  String get monkAppBarTitle;

  /// No description provided for @monkBackHome.
  ///
  /// In en, this message translates to:
  /// **'BACK TO HOME'**
  String get monkBackHome;

  /// No description provided for @monkReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get monkReady;

  /// No description provided for @monkFocus.
  ///
  /// In en, this message translates to:
  /// **'FOCUS'**
  String get monkFocus;

  /// No description provided for @monkPaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get monkPaused;

  /// No description provided for @monkDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get monkDone;

  /// No description provided for @monkSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'SELECT DURATION'**
  String get monkSelectDuration;

  /// No description provided for @monkTestMode.
  ///
  /// In en, this message translates to:
  /// **'TEST MODE'**
  String get monkTestMode;

  /// No description provided for @monkStartSession.
  ///
  /// In en, this message translates to:
  /// **'START SESSION'**
  String get monkStartSession;

  /// No description provided for @monkReset.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get monkReset;

  /// No description provided for @monkPause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get monkPause;

  /// No description provided for @monkResume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get monkResume;

  /// No description provided for @monkBgPauseSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Focus pauses when you leave the app. Tap RESUME to continue.'**
  String get monkBgPauseSnackbar;

  /// No description provided for @monkStayAwakeHint.
  ///
  /// In en, this message translates to:
  /// **'Screen stays on during focus so auto-lock won’t pause your session. Switching apps still pauses.'**
  String get monkStayAwakeHint;

  /// No description provided for @monkCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get monkCompleteTitle;

  /// No description provided for @monkCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Great focus. Keep it up.'**
  String get monkCompleteSubtitle;

  /// No description provided for @monkShareResult.
  ///
  /// In en, this message translates to:
  /// **'SHARE RESULT'**
  String get monkShareResult;

  /// No description provided for @monkShareSubject.
  ///
  /// In en, this message translates to:
  /// **'My Monk Mode Session'**
  String get monkShareSubject;

  /// No description provided for @monkShareStatDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get monkShareStatDuration;

  /// No description provided for @monkShareStatStreak.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get monkShareStatStreak;

  /// No description provided for @monkShareStatScore.
  ///
  /// In en, this message translates to:
  /// **'SCORE'**
  String get monkShareStatScore;

  /// No description provided for @monkShareTagline.
  ///
  /// In en, this message translates to:
  /// **'\"Focus like a monk\"'**
  String get monkShareTagline;

  /// No description provided for @monkShareStreakNew.
  ///
  /// In en, this message translates to:
  /// **'New start'**
  String get monkShareStreakNew;

  /// No description provided for @monkShareStreakOne.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get monkShareStreakOne;

  /// No description provided for @monkShareStreakMany.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String monkShareStreakMany(int days);

  /// No description provided for @ftHubTitle.
  ///
  /// In en, this message translates to:
  /// **'FOCUS TOGETHER'**
  String get ftHubTitle;

  /// No description provided for @ftHubHeadline.
  ///
  /// In en, this message translates to:
  /// **'Focus together'**
  String get ftHubHeadline;

  /// No description provided for @ftHubBodyOnline.
  ///
  /// In en, this message translates to:
  /// **'One shared timer. Share the code; friends join before the host starts.'**
  String get ftHubBodyOnline;

  /// No description provided for @ftHubBodyOffline.
  ///
  /// In en, this message translates to:
  /// **'One timer per room on this device. Add Firebase to sync with other phones.'**
  String get ftHubBodyOffline;

  /// No description provided for @ftYourNameHeader.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME IN ROOMS'**
  String get ftYourNameHeader;

  /// No description provided for @ftNameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alex'**
  String get ftNameFieldHint;

  /// No description provided for @ftNameHelp.
  ///
  /// In en, this message translates to:
  /// **'Everyone sees this in the list. Each phone also gets a short tag (#AB12) so two similar names stay distinct.'**
  String get ftNameHelp;

  /// No description provided for @ftSaveName.
  ///
  /// In en, this message translates to:
  /// **'SAVE NAME'**
  String get ftSaveName;

  /// No description provided for @ftStartHere.
  ///
  /// In en, this message translates to:
  /// **'START HERE'**
  String get ftStartHere;

  /// No description provided for @ftCreateRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a room'**
  String get ftCreateRoomTitle;

  /// No description provided for @ftCreateRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are the host—set length and share the code'**
  String get ftCreateRoomSubtitle;

  /// No description provided for @ftJoinRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get ftJoinRoomTitle;

  /// No description provided for @ftJoinRoomSubtitleOnline.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your host'**
  String get ftJoinRoomSubtitleOnline;

  /// No description provided for @ftJoinRoomSubtitleOffline.
  ///
  /// In en, this message translates to:
  /// **'Same phone as the host until Firebase is on'**
  String get ftJoinRoomSubtitleOffline;

  /// No description provided for @ftErrorNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a name your friends will recognize.'**
  String get ftErrorNameEmpty;

  /// No description provided for @ftNameSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Saved. Others will see this name in the room.'**
  String get ftNameSavedSnackbar;

  /// No description provided for @ftJoinAppBar.
  ///
  /// In en, this message translates to:
  /// **'JOIN ROOM'**
  String get ftJoinAppBar;

  /// No description provided for @ftJoinEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get ftJoinEnterCode;

  /// No description provided for @ftJoinCodeHelp.
  ///
  /// In en, this message translates to:
  /// **'Usually 8 characters; not case-sensitive.'**
  String get ftJoinCodeHelp;

  /// No description provided for @ftJoinCodeSection.
  ///
  /// In en, this message translates to:
  /// **'ROOM CODE'**
  String get ftJoinCodeSection;

  /// No description provided for @ftJoinMinChars.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 4 characters.'**
  String get ftJoinMinChars;

  /// No description provided for @ftJoinLobby.
  ///
  /// In en, this message translates to:
  /// **'JOIN LOBBY'**
  String get ftJoinLobby;

  /// No description provided for @ftJoinTypingHint.
  ///
  /// In en, this message translates to:
  /// **'Keep typing—codes are usually 8 characters.'**
  String get ftJoinTypingHint;

  /// No description provided for @ftCreateAppBar.
  ///
  /// In en, this message translates to:
  /// **'NEW ROOM'**
  String get ftCreateAppBar;

  /// No description provided for @ftCreateDurationQuestion.
  ///
  /// In en, this message translates to:
  /// **'How long is the block?'**
  String get ftCreateDurationQuestion;

  /// No description provided for @ftCreateDurationHelp.
  ///
  /// In en, this message translates to:
  /// **'Everyone sees the same length once you start. You can still leave the lobby anytime.'**
  String get ftCreateDurationHelp;

  /// No description provided for @ftNameOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'NAME (OPTIONAL)'**
  String get ftNameOptionalSection;

  /// No description provided for @ftRoomNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Deep work · Sunday'**
  String get ftRoomNameHint;

  /// No description provided for @ftCreateOpenLobby.
  ///
  /// In en, this message translates to:
  /// **'CREATE & OPEN LOBBY'**
  String get ftCreateOpenLobby;

  /// No description provided for @ftLobbyTitle.
  ///
  /// In en, this message translates to:
  /// **'LOBBY'**
  String get ftLobbyTitle;

  /// No description provided for @ftLobbyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active lobby'**
  String get ftLobbyEmptyTitle;

  /// No description provided for @ftLobbyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Room closed or reset. Go back to the hub to create or join again.'**
  String get ftLobbyEmptyBody;

  /// No description provided for @ftBackToHub.
  ///
  /// In en, this message translates to:
  /// **'BACK TO HUB'**
  String get ftBackToHub;

  /// No description provided for @ftDefaultRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Your focus room'**
  String get ftDefaultRoomTitle;

  /// No description provided for @ftLobbyShareOnline.
  ///
  /// In en, this message translates to:
  /// **'Share the code below so others can join from their phone.'**
  String get ftLobbyShareOnline;

  /// No description provided for @ftLobbyShareOffline.
  ///
  /// In en, this message translates to:
  /// **'This code only works on this phone.'**
  String get ftLobbyShareOffline;

  /// No description provided for @ftLobbyGuestWait.
  ///
  /// In en, this message translates to:
  /// **'Wait for the host to start. Tap ready when you are set.'**
  String get ftLobbyGuestWait;

  /// No description provided for @ftInThisRoom.
  ///
  /// In en, this message translates to:
  /// **'IN THIS ROOM'**
  String get ftInThisRoom;

  /// No description provided for @ftStartFocusTimer.
  ///
  /// In en, this message translates to:
  /// **'START FOCUS TIMER'**
  String get ftStartFocusTimer;

  /// No description provided for @ftImReady.
  ///
  /// In en, this message translates to:
  /// **'I\'M READY'**
  String get ftImReady;

  /// No description provided for @ftSetToWaiting.
  ///
  /// In en, this message translates to:
  /// **'SET TO WAITING'**
  String get ftSetToWaiting;

  /// No description provided for @ftLeaveLobby.
  ///
  /// In en, this message translates to:
  /// **'LEAVE LOBBY'**
  String get ftLeaveLobby;

  /// No description provided for @ftPhaseLobby.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get ftPhaseLobby;

  /// No description provided for @ftPhaseRunning.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get ftPhaseRunning;

  /// No description provided for @ftPhaseEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ftPhaseEnded;

  /// No description provided for @ftSessionBlockSuffix.
  ///
  /// In en, this message translates to:
  /// **'block'**
  String get ftSessionBlockSuffix;

  /// No description provided for @ftLobbyHereCount.
  ///
  /// In en, this message translates to:
  /// **'{count} here'**
  String ftLobbyHereCount(int count);

  /// No description provided for @ftLobbyMetaMiddle.
  ///
  /// In en, this message translates to:
  /// **' · '**
  String get ftLobbyMetaMiddle;

  /// No description provided for @ftInSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'IN SESSION'**
  String get ftInSessionTitle;

  /// No description provided for @ftEndSessionAction.
  ///
  /// In en, this message translates to:
  /// **'END'**
  String get ftEndSessionAction;

  /// No description provided for @ftSharedFocusDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Shared focus'**
  String get ftSharedFocusDefaultName;

  /// No description provided for @ftInRoomCount.
  ///
  /// In en, this message translates to:
  /// **'{count} in this room'**
  String ftInRoomCount(int count);

  /// No description provided for @ftTimerFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'FOCUS'**
  String get ftTimerFocusLabel;

  /// No description provided for @ftTogetherSection.
  ///
  /// In en, this message translates to:
  /// **'TOGETHER'**
  String get ftTogetherSection;

  /// No description provided for @ftSessionSyncOnline.
  ///
  /// In en, this message translates to:
  /// **'Same end time for everyone; updates sync from the room.'**
  String get ftSessionSyncOnline;

  /// No description provided for @ftSessionSyncOffline.
  ///
  /// In en, this message translates to:
  /// **'Timer is only on this device.'**
  String get ftSessionSyncOffline;

  /// No description provided for @ftSessionUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get ftSessionUpdating;

  /// No description provided for @ftBgSessionPausedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Timer was paused while the app was in the background. Remaining time is synced with the room.'**
  String get ftBgSessionPausedSnackbar;

  /// No description provided for @ftStayAwakeHint.
  ///
  /// In en, this message translates to:
  /// **'Screen stays on during the session so auto-lock won’t freeze your timer. Leaving the app still pauses locally until you return.'**
  String get ftStayAwakeHint;

  /// No description provided for @ftRoomCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'ROOM CODE'**
  String get ftRoomCodeLabel;

  /// No description provided for @ftCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get ftCodeCopied;

  /// No description provided for @frCrossHubTitleOn.
  ///
  /// In en, this message translates to:
  /// **'Synced rooms'**
  String get frCrossHubTitleOn;

  /// No description provided for @frCrossHubTitleOff.
  ///
  /// In en, this message translates to:
  /// **'This device only'**
  String get frCrossHubTitleOff;

  /// No description provided for @frCrossJoinTitleOn.
  ///
  /// In en, this message translates to:
  /// **'Join from another phone'**
  String get frCrossJoinTitleOn;

  /// No description provided for @frCrossJoinTitleOff.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get frCrossJoinTitleOff;

  /// No description provided for @frCrossLobbyTitleOn.
  ///
  /// In en, this message translates to:
  /// **'Share this code'**
  String get frCrossLobbyTitleOn;

  /// No description provided for @frCrossLobbyTitleOff.
  ///
  /// In en, this message translates to:
  /// **'This code'**
  String get frCrossLobbyTitleOff;

  /// No description provided for @frCrossHubBodyOn.
  ///
  /// In en, this message translates to:
  /// **'Create a room, share the 8-character code, and friends open Focus Together → Join while the lobby is open.'**
  String get frCrossHubBodyOn;

  /// No description provided for @frCrossHubBodyOff.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is off, so rooms exist only on this phone. Configure Firebase to play across devices.'**
  String get frCrossHubBodyOff;

  /// No description provided for @frCrossJoinBodyOn.
  ///
  /// In en, this message translates to:
  /// **'Code must match (letters/numbers; case does not matter). It stops working if the host already started or left.'**
  String get frCrossJoinBodyOn;

  /// No description provided for @frCrossJoinBodyOff.
  ///
  /// In en, this message translates to:
  /// **'Only a room created on this same phone can be opened here.'**
  String get frCrossJoinBodyOff;

  /// No description provided for @frCrossLobbyBodyOn.
  ///
  /// In en, this message translates to:
  /// **'When everyone is in, tap Start focus timer. If someone cannot join, check the code and that you are still in the lobby.'**
  String get frCrossLobbyBodyOn;

  /// No description provided for @frCrossLobbyBodyOff.
  ///
  /// In en, this message translates to:
  /// **'This code only works on this phone until Firebase is configured.'**
  String get frCrossLobbyBodyOff;

  /// No description provided for @ftLeaveSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this session?'**
  String get ftLeaveSessionTitle;

  /// No description provided for @ftLeaveSessionBody.
  ///
  /// In en, this message translates to:
  /// **'The timer will stop for you and this room will close on your device. In a live app, others could keep going—here it ends for everyone in mock mode.'**
  String get ftLeaveSessionBody;

  /// No description provided for @ftKeepFocusing.
  ///
  /// In en, this message translates to:
  /// **'KEEP FOCUSING'**
  String get ftKeepFocusing;

  /// No description provided for @ftEndSessionSheet.
  ///
  /// In en, this message translates to:
  /// **'END SESSION'**
  String get ftEndSessionSheet;

  /// No description provided for @ftCircleHeadlineAllBadges.
  ///
  /// In en, this message translates to:
  /// **'Every circle badge unlocked'**
  String get ftCircleHeadlineAllBadges;

  /// No description provided for @ftCircleHeadlineKeepFinishing.
  ///
  /// In en, this message translates to:
  /// **'Keep finishing together'**
  String get ftCircleHeadlineKeepFinishing;

  /// No description provided for @ftCircleHeadlineNextReady.
  ///
  /// In en, this message translates to:
  /// **'Next badge ready'**
  String get ftCircleHeadlineNextReady;

  /// No description provided for @ftCircleOneSessionToBadge.
  ///
  /// In en, this message translates to:
  /// **'1 session to {badge}'**
  String ftCircleOneSessionToBadge(String badge);

  /// No description provided for @ftCircleSessionsToBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions to {badge}'**
  String ftCircleSessionsToBadge(int count, String badge);

  /// No description provided for @ftCircleSublineAllDone.
  ///
  /// In en, this message translates to:
  /// **'Come back with your group whenever you want — the ritual is yours.'**
  String get ftCircleSublineAllDone;

  /// No description provided for @ftCircleSublineStart.
  ///
  /// In en, this message translates to:
  /// **'Finish a full session with others to start your circle journey.'**
  String get ftCircleSublineStart;

  /// No description provided for @ftBadgeAt1.
  ///
  /// In en, this message translates to:
  /// **'First light'**
  String get ftBadgeAt1;

  /// No description provided for @ftBadgeAt3.
  ///
  /// In en, this message translates to:
  /// **'Momentum'**
  String get ftBadgeAt3;

  /// No description provided for @ftBadgeAt5.
  ///
  /// In en, this message translates to:
  /// **'Squad rhythm'**
  String get ftBadgeAt5;

  /// No description provided for @ftBadgeAt10.
  ///
  /// In en, this message translates to:
  /// **'Circle strength'**
  String get ftBadgeAt10;

  /// No description provided for @ftBadgeAt15.
  ///
  /// In en, this message translates to:
  /// **'Deep bench'**
  String get ftBadgeAt15;

  /// No description provided for @ftBadgeAt25.
  ///
  /// In en, this message translates to:
  /// **'Focus anchor'**
  String get ftBadgeAt25;

  /// No description provided for @ftBadgeAt50.
  ///
  /// In en, this message translates to:
  /// **'Circle legend'**
  String get ftBadgeAt50;

  /// No description provided for @ftChaseAt1.
  ///
  /// In en, this message translates to:
  /// **'Your first circle badge is one natural finish away.'**
  String get ftChaseAt1;

  /// No description provided for @ftChaseAt3.
  ///
  /// In en, this message translates to:
  /// **'Three finishes is where a group habit usually sticks.'**
  String get ftChaseAt3;

  /// No description provided for @ftChaseAt5.
  ///
  /// In en, this message translates to:
  /// **'Five sessions is when shared focus starts to feel normal.'**
  String get ftChaseAt5;

  /// No description provided for @ftChaseAt10.
  ///
  /// In en, this message translates to:
  /// **'Double digits is worth protecting — one room at a time.'**
  String get ftChaseAt10;

  /// No description provided for @ftChaseAt15.
  ///
  /// In en, this message translates to:
  /// **'You are past the novelty phase — keep the ritual alive.'**
  String get ftChaseAt15;

  /// No description provided for @ftChaseAt25.
  ///
  /// In en, this message translates to:
  /// **'The anchor badge is for groups that do not quit.'**
  String get ftChaseAt25;

  /// No description provided for @ftChaseAt50.
  ///
  /// In en, this message translates to:
  /// **'After this, the win is the habit itself.'**
  String get ftChaseAt50;

  /// No description provided for @ftFooterFinishesOne.
  ///
  /// In en, this message translates to:
  /// **'1 natural finish logged'**
  String get ftFooterFinishesOne;

  /// No description provided for @ftFooterFinishesMany.
  ///
  /// In en, this message translates to:
  /// **'{count} natural finishes logged'**
  String ftFooterFinishesMany(int count);

  /// No description provided for @ftFooterAllDone.
  ///
  /// In en, this message translates to:
  /// **'{count} natural finishes — keep the ritual with your circle.'**
  String ftFooterAllDone(int count);

  /// No description provided for @summaryAppBarEarly.
  ///
  /// In en, this message translates to:
  /// **'WRAP-UP'**
  String get summaryAppBarEarly;

  /// No description provided for @summaryAppBarDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get summaryAppBarDone;

  /// No description provided for @summaryHeadlineEarly.
  ///
  /// In en, this message translates to:
  /// **'You stepped away'**
  String get summaryHeadlineEarly;

  /// No description provided for @summaryHeadlineDone.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get summaryHeadlineDone;

  /// No description provided for @summarySubEarly.
  ///
  /// In en, this message translates to:
  /// **'The room closed when you ended early.'**
  String get summarySubEarly;

  /// No description provided for @summarySubNatural.
  ///
  /// In en, this message translates to:
  /// **'Nice work staying in flow together.'**
  String get summarySubNatural;

  /// No description provided for @summaryEndedAt.
  ///
  /// In en, this message translates to:
  /// **'Ended at {time}'**
  String summaryEndedAt(String time);

  /// No description provided for @summaryDefaultRoom.
  ///
  /// In en, this message translates to:
  /// **'Focus room'**
  String get summaryDefaultRoom;

  /// No description provided for @summaryCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get summaryCompleted;

  /// No description provided for @summaryDidNotFinish.
  ///
  /// In en, this message translates to:
  /// **'DID NOT FINISH'**
  String get summaryDidNotFinish;

  /// No description provided for @summaryCompletedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No one is listed as completed for this run.'**
  String get summaryCompletedEmptyTitle;

  /// No description provided for @summaryCompletedEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'That can happen if the session ended early.'**
  String get summaryCompletedEmptySubtitle;

  /// No description provided for @summaryBackMonk.
  ///
  /// In en, this message translates to:
  /// **'BACK TO MONK MODE'**
  String get summaryBackMonk;

  /// No description provided for @summaryFocusAgain.
  ///
  /// In en, this message translates to:
  /// **'FOCUS TOGETHER AGAIN'**
  String get summaryFocusAgain;

  /// No description provided for @summaryRewardsNatural.
  ///
  /// In en, this message translates to:
  /// **'Monk Mode rewards'**
  String get summaryRewardsNatural;

  /// No description provided for @summaryRewardsEarly.
  ///
  /// In en, this message translates to:
  /// **'Small recovery bonus'**
  String get summaryRewardsEarly;

  /// No description provided for @summaryStreakLineOne.
  ///
  /// In en, this message translates to:
  /// **'1 day streak · counts like a solo session'**
  String get summaryStreakLineOne;

  /// No description provided for @summaryStreakLineMany.
  ///
  /// In en, this message translates to:
  /// **'{days} days streak · counts like a solo session'**
  String summaryStreakLineMany(int days);

  /// No description provided for @summaryClarityLine.
  ///
  /// In en, this message translates to:
  /// **'Clarity +{delta} total ({focus} focus)'**
  String summaryClarityLine(int delta, String focus);

  /// No description provided for @summarySquadBonus.
  ///
  /// In en, this message translates to:
  /// **'+{bonus} squad bonus for finishing alongside others.'**
  String summarySquadBonus(int bonus);

  /// No description provided for @summaryClarityNow.
  ///
  /// In en, this message translates to:
  /// **'Clarity now at {score}'**
  String summaryClarityNow(int score);

  /// No description provided for @summaryEarlyClarityLine.
  ///
  /// In en, this message translates to:
  /// **'Clarity +{delta} (streak unchanged)'**
  String summaryEarlyClarityLine(int delta);

  /// No description provided for @summaryEarlyHint.
  ///
  /// In en, this message translates to:
  /// **'Finish a full session with the group to move your streak and earn the big clarity gains.'**
  String get summaryEarlyHint;

  /// No description provided for @summaryNextReturn.
  ///
  /// In en, this message translates to:
  /// **'NEXT REASON TO RETURN'**
  String get summaryNextReturn;

  /// No description provided for @ftMil1Title.
  ///
  /// In en, this message translates to:
  /// **'First light'**
  String get ftMil1Title;

  /// No description provided for @ftMil1Sub.
  ///
  /// In en, this message translates to:
  /// **'You finished a full session with others. That is the hardest step.'**
  String get ftMil1Sub;

  /// No description provided for @ftMil3Title.
  ///
  /// In en, this message translates to:
  /// **'Momentum'**
  String get ftMil3Title;

  /// No description provided for @ftMil3Sub.
  ///
  /// In en, this message translates to:
  /// **'Three shared finishes — your group is turning focus into a habit.'**
  String get ftMil3Sub;

  /// No description provided for @ftMil5Title.
  ///
  /// In en, this message translates to:
  /// **'Squad rhythm'**
  String get ftMil5Title;

  /// No description provided for @ftMil5Sub.
  ///
  /// In en, this message translates to:
  /// **'Five times you all stayed until the end. Consistency beats intensity.'**
  String get ftMil5Sub;

  /// No description provided for @ftMil10Title.
  ///
  /// In en, this message translates to:
  /// **'Circle strength'**
  String get ftMil10Title;

  /// No description provided for @ftMil10Sub.
  ///
  /// In en, this message translates to:
  /// **'Ten shared wins. Most people never stack this — you are building something real.'**
  String get ftMil10Sub;

  /// No description provided for @ftMil15Title.
  ///
  /// In en, this message translates to:
  /// **'Deep bench'**
  String get ftMil15Title;

  /// No description provided for @ftMil15Sub.
  ///
  /// In en, this message translates to:
  /// **'Fifteen natural finishes. Your circle shows up when it counts.'**
  String get ftMil15Sub;

  /// No description provided for @ftMil25Title.
  ///
  /// In en, this message translates to:
  /// **'Focus anchor'**
  String get ftMil25Title;

  /// No description provided for @ftMil25Sub.
  ///
  /// In en, this message translates to:
  /// **'Twenty-five shared sessions. That is discipline most people never stack.'**
  String get ftMil25Sub;

  /// No description provided for @ftMil50Title.
  ///
  /// In en, this message translates to:
  /// **'Circle legend'**
  String get ftMil50Title;

  /// No description provided for @ftMil50Sub.
  ///
  /// In en, this message translates to:
  /// **'Fifty natural finishes together. Save this screen — you earned it.'**
  String get ftMil50Sub;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'GOOGLE'**
  String get settingsBackup;

  /// No description provided for @backupSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get backupSignInTitle;

  /// No description provided for @backupSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Link your Google account to back up streak and stats in the cloud (restore after reinstall)'**
  String get backupSignInSubtitle;

  /// No description provided for @backupSignedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Google backup active'**
  String get backupSignedInTitle;

  /// No description provided for @backupSignedInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Synced as {email}'**
  String backupSignedInSubtitle(String email);

  /// No description provided for @backupSyncNow.
  ///
  /// In en, this message translates to:
  /// **'SYNC NOW'**
  String get backupSyncNow;

  /// No description provided for @backupSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out of backup'**
  String get backupSignOut;

  /// No description provided for @backupSignOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stats stay on this device'**
  String get backupSignOutSubtitle;

  /// No description provided for @backupSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in with Google. Please try again.'**
  String get backupSignInFailed;

  /// No description provided for @backupSignInDialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get backupSignInDialogOk;

  /// No description provided for @backupSignInDialogDeveloperTitle.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in (Android setup)'**
  String get backupSignInDialogDeveloperTitle;

  /// No description provided for @backupSignInDialogDeveloperBody.
  ///
  /// In en, this message translates to:
  /// **'Google blocked sign-in because the certificate that signed this install is not registered in Firebase.\n\nIf you installed from Google Play: Play Console → your app → Release (or Testing) → App integrity → App signing. Copy SHA-1 under App signing key certificate (not the upload key). In Firebase: Project settings → your Android app → Add fingerprint. Then download google-services.json again, replace android/app/google-services.json, and publish a new release.\n\nIf you use a local debug or release APK, add the SHA-1 from android/ gradlew signingReport (Variant: debug or release) instead.'**
  String get backupSignInDialogDeveloperBody;

  /// No description provided for @backupSignInDialogTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in (token)'**
  String get backupSignInDialogTokenTitle;

  /// No description provided for @backupSignInDialogTokenBody.
  ///
  /// In en, this message translates to:
  /// **'The app could not get an ID token from Google. In Firebase Console, re-download google-services.json after your SHA-1 fingerprints are added, and confirm lib/config/backup_sign_in_config.dart has the Web client ID (type 3 in json). Then create a new release build.'**
  String get backupSignInDialogTokenBody;

  /// No description provided for @backupSynced.
  ///
  /// In en, this message translates to:
  /// **'Stats backed up to Google.'**
  String get backupSynced;

  /// No description provided for @backupSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed. Check your connection.'**
  String get backupSyncFailed;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from cloud?'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'Your Google backup has {sessions} sessions and a {streak}-day streak. Restore it to this device? Current local data will be replaced.'**
  String backupRestoreBody(int sessions, int streak);

  /// No description provided for @backupRestoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'RESTORE'**
  String get backupRestoreConfirm;

  /// No description provided for @backupRestoreCancel.
  ///
  /// In en, this message translates to:
  /// **'KEEP LOCAL'**
  String get backupRestoreCancel;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Stats restored from your Google backup.'**
  String get backupRestored;

  /// No description provided for @backupSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of backup?'**
  String get backupSignOutConfirmTitle;

  /// No description provided for @backupSignOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your stats stay on this device but will no longer sync to Google.'**
  String get backupSignOutConfirmBody;

  /// No description provided for @backupSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'SIGN OUT'**
  String get backupSignOutConfirm;

  /// No description provided for @backupSignOutCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get backupSignOutCancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
