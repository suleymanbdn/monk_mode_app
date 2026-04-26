import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
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
    return HSLColor.fromAHSL(1, h.toDouble(), 0.35, 0.42).toColor();
  }

  String get _statusLabel {
    switch (participant.presence) {
      case ParticipantPresence.inLobby:
        return 'Waiting';
      case ParticipantPresence.ready:
        return 'Ready';
      case ParticipantPresence.focusing:
        return 'In focus';
      case ParticipantPresence.paused:
        return 'Paused';
      case ParticipantPresence.completed:
        return 'Done';
      case ParticipantPresence.left:
        return 'Left';
    }
  }

  bool get _isSelf => localUserId != null && participant.id == localUserId;

  String get _titleLine {
    if (_isSelf) return 'You';
    return participant.displayName;
  }

  String get _subtitleLine {
    final tag = focusParticipantShortTag(participant.id);
    if (_isSelf) {
      return '#$tag · ${participant.displayName} · $_statusLabel';
    }
    return '#$tag · $_statusLabel';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _titleLine;
    final initial = participant.displayName.isNotEmpty
        ? participant.displayName[0].toUpperCase()
        : (title.isNotEmpty ? title[0].toUpperCase() : '?');

    final h = HSLColor.fromColor(_avatarColor).hue;
    final borderColor = HSLColor.fromAHSL(
      1,
      (h + 48) % 360,
      0.5,
      0.5,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HOST',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitleLine,
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
