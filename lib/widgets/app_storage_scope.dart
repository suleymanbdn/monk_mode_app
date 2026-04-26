import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Exposes [StorageService] and app [Locale] switching to descendant routes.
class AppStorageScope extends InheritedWidget {
  const AppStorageScope({
    super.key,
    required this.storage,
    required this.appLocale,
    required this.onAppLocaleChanged,
    required super.child,
  });

  final StorageService storage;
  final Locale appLocale;

  /// Persists language to disk; await so the choice survives app kill immediately after.
  final Future<void> Function(Locale) onAppLocaleChanged;

  static AppStorageScope _scope(BuildContext context) {
    final s = context.dependOnInheritedWidgetOfExactType<AppStorageScope>();
    assert(s != null, 'AppStorageScope not found in context');
    return s!;
  }

  static StorageService? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStorageScope>()
        ?.storage;
  }

  static StorageService of(BuildContext context) => _scope(context).storage;

  static Future<void> setLocale(BuildContext context, Locale locale) {
    return _scope(context).onAppLocaleChanged(locale);
  }

  @override
  bool updateShouldNotify(covariant AppStorageScope oldWidget) =>
      oldWidget.storage != storage ||
      oldWidget.appLocale != appLocale ||
      oldWidget.onAppLocaleChanged != onAppLocaleChanged;
}
