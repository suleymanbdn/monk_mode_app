import 'package:flutter/material.dart';

import '../screens/app_update_screen.dart';
import 'app_update_checker.dart';

/// Prevents stacking multiple update screens (e.g. init + delayed check + resume).
bool _appUpdateScreenOpen = false;

/// Pushes [AppUpdateScreen] when [result.shouldPrompt] is true.
void presentAppUpdateScreenIfNeeded(
  NavigatorState navigator,
  AppUpdateCheckResult result,
) {
  if (!result.shouldPrompt || _appUpdateScreenOpen) return;
  _appUpdateScreenOpen = true;
  navigator
      .push<void>(
        PageRouteBuilder<void>(
          opaque: true,
          barrierDismissible: false,
          settings: const RouteSettings(name: 'app_update'),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: AppUpdateScreen(result: result),
            );
          },
        ),
      )
      .whenComplete(() {
        _appUpdateScreenOpen = false;
      });
}
