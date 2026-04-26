import '../models/focus_together_circle_progress.dart';
import 'app_localizations.dart';

extension FocusTogetherCircleProgressL10n on FocusTogetherCircleProgress {
  String localizedHeadline(AppLocalizations l10n) {
    if (allNamedTiersComplete) return l10n.ftCircleHeadlineAllBadges;
    if (nextTier == null) return l10n.ftCircleHeadlineKeepFinishing;
    final n = sessionsUntilNext;
    if (n <= 0) return l10n.ftCircleHeadlineNextReady;
    final badge = badgeShortName(l10n, nextTier!.at);
    if (n == 1) return l10n.ftCircleOneSessionToBadge(badge);
    return l10n.ftCircleSessionsToBadge(n, badge);
  }

  String localizedSubline(AppLocalizations l10n) {
    if (allNamedTiersComplete) return l10n.ftCircleSublineAllDone;
    final t = nextTier;
    if (t == null) return l10n.ftCircleSublineStart;
    return chaseLineForAt(l10n, t.at);
  }

  String localizedFooterLine(AppLocalizations l10n) {
    if (allNamedTiersComplete) {
      return l10n.ftFooterAllDone(naturalCompletions);
    }
    if (naturalCompletions == 1) return l10n.ftFooterFinishesOne;
    return l10n.ftFooterFinishesMany(naturalCompletions);
  }
}

String badgeShortName(AppLocalizations l10n, int at) {
  switch (at) {
    case 1:
      return l10n.ftBadgeAt1;
    case 3:
      return l10n.ftBadgeAt3;
    case 5:
      return l10n.ftBadgeAt5;
    case 10:
      return l10n.ftBadgeAt10;
    case 15:
      return l10n.ftBadgeAt15;
    case 25:
      return l10n.ftBadgeAt25;
    case 50:
      return l10n.ftBadgeAt50;
    default:
      return '';
  }
}

String chaseLineForAt(AppLocalizations l10n, int at) {
  switch (at) {
    case 1:
      return l10n.ftChaseAt1;
    case 3:
      return l10n.ftChaseAt3;
    case 5:
      return l10n.ftChaseAt5;
    case 10:
      return l10n.ftChaseAt10;
    case 15:
      return l10n.ftChaseAt15;
    case 25:
      return l10n.ftChaseAt25;
    case 50:
      return l10n.ftChaseAt50;
    default:
      return l10n.ftCircleSublineStart;
  }
}

/// Localized milestone card on session summary (tier `at` from [FocusTogetherReward.togetherSessionsAllTime] when a milestone fired).
abstract final class FocusTogetherMilestoneL10n {
  static String? title(AppLocalizations l10n, int at) {
    switch (at) {
      case 1:
        return l10n.ftMil1Title;
      case 3:
        return l10n.ftMil3Title;
      case 5:
        return l10n.ftMil5Title;
      case 10:
        return l10n.ftMil10Title;
      case 15:
        return l10n.ftMil15Title;
      case 25:
        return l10n.ftMil25Title;
      case 50:
        return l10n.ftMil50Title;
      default:
        return null;
    }
  }

  static String? subtitle(AppLocalizations l10n, int at) {
    switch (at) {
      case 1:
        return l10n.ftMil1Sub;
      case 3:
        return l10n.ftMil3Sub;
      case 5:
        return l10n.ftMil5Sub;
      case 10:
        return l10n.ftMil10Sub;
      case 15:
        return l10n.ftMil15Sub;
      case 25:
        return l10n.ftMil25Sub;
      case 50:
        return l10n.ftMil50Sub;
      default:
        return null;
    }
  }
}
