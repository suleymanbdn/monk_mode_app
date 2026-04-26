import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'models/app_language.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/app_update_checker.dart';
import 'services/app_update_navigation.dart';
import 'services/storage_service.dart';
import 'widgets/app_storage_scope.dart';

class App extends StatefulWidget {
  const App({super.key, required this.storage});

  final StorageService storage;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  late Locale _appLocale;
  DateTime? _launchAt;

  @override
  void initState() {
    super.initState();
    _launchAt = DateTime.now();
    WidgetsBinding.instance.addObserver(this);
    _appLocale = _localeForLanguage(widget.storage.loadAppLanguage());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _promptUpdateIfNeeded(),
    );
    // Backup: first Firestore read can be slow right after cold start.
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _promptUpdateIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final t0 = _launchAt;
    if (t0 != null &&
        DateTime.now().difference(t0) < const Duration(seconds: 2)) {
      return;
    }
    _promptUpdateIfNeeded();
  }

  static Locale _localeForLanguage(AppLanguage lang) =>
      lang == AppLanguage.tr ? const Locale('tr') : const Locale('en');

  Future<void> _onAppLocaleChanged(Locale locale) async {
    setState(() => _appLocale = locale);
    await widget.storage.saveAppLanguage(
      locale.languageCode == 'tr' ? AppLanguage.tr : AppLanguage.en,
    );
  }

  Future<void> _promptUpdateIfNeeded() async {
    final r = await AppUpdateChecker.check();
    if (!mounted || !r.shouldPrompt) return;

    void pushWhenReady(int attempt) {
      if (!mounted) return;
      final nav = _navKey.currentState;
      if (nav != null) {
        presentAppUpdateScreenIfNeeded(nav, r);
        return;
      }
      if (attempt < 20) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => pushWhenReady(attempt + 1),
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => pushWhenReady(0));
  }

  @override
  Widget build(BuildContext context) {
    return AppStorageScope(
      storage: widget.storage,
      appLocale: _appLocale,
      onAppLocaleChanged: _onAppLocaleChanged,
      child: MaterialApp(
        navigatorKey: _navKey,
        title: 'Monk Mode: Dopamine Detox',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        locale: _appLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(storage: widget.storage),
      ),
    );
  }
}
