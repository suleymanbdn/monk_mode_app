import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../models/focus_room_models.dart';

/// Last 4 hex (or chars) of [id] so two people with the same nickname stay distinct.
String focusParticipantShortTag(String id) {
  final stripped = id.startsWith('u_') ? id.substring(2) : id;
  if (stripped.isEmpty) return '----';
  final hex = stripped.replaceAll(RegExp(r'[^a-fA-F0-9]'), '');
  if (hex.length >= 4) return hex.substring(hex.length - 4).toUpperCase();
  if (stripped.length >= 4) {
    return stripped.substring(stripped.length - 4).toUpperCase();
  }
  return stripped.toUpperCase().padRight(4, '0').substring(0, 4);
}

class FrParticipantTile extends StatelessWidget {
  const FrParticipantTile({
    super.key,
    required this.participant,
    this.localUserId,
  });

  final FocusParticipant participant;

  /// When set, this row is labeled "You" instead of the stored display name.
  final String? localUserId;

  Color get _avatarColor {
    final h = participant.id.hashCode.abs() % 360;
    return HSLColor.fromAHSL(1, h.toDouble(), 0.50, 0.58).toColor();
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (participant.presence) {
      case ParticipantPresence.inLobby:
        return l10n.ftPresenceWaiting;
      case ParticipantPresence.ready:
        return l10n.ftPresenceReady;
      case ParticipantPresence.focusing:
        return l10n.ftPresenceFocusing;
      case ParticipantPresence.paused:
        return l10n.ftPresencePaused;
      case ParticipantPresence.completed:
        return l10n.ftPresenceDone;
      case ParticipantPresence.left:
        return l10n.ftPresenceLeft;
    }
  }

  bool get _isSelf => localUserId != null && participant.id == localUserId;

  String get _titleLine {
    if (_isSelf) return 'You';
    return participant.displayName;
  }

  String _subtitleLine(AppLocalizations l10n) {
    final tag = focusParticipantShortTag(participant.id);
    if (_isSelf) {
      return '#$tag · ${participant.displayName} · ${_statusLabel(l10n)}';
    }
    return '#$tag · ${_statusLabel(l10n)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final title = _titleLine;
    final initial = participant.displayName.isNotEmpty
        ? participant.displayName[0].toUpperCase()
        : (title.isNotEmpty ? title[0].toUpperCase() : '?');

    final h = HSLColor.fromColor(_avatarColor).hue;
    final borderColor = HSLColor.fromAHSL(
      1,
      (h + 48) % 360,
      0.55,
      0.65,
    ).toColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _avatarColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (participant.isHost) ...[
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'HOST',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontSize: 9,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitleLine(l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
