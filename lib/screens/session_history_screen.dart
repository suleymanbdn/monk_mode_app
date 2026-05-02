import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_formatting.dart';
import '../models/session_log_entry.dart';
import '../services/storage_service.dart';
import '../utils/time_utils.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  late List<SessionLogEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = widget.storage.loadSessionLog();
  }

  String _timeLabel(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _sectionLabel(String dateKey, String localeName) {
    if (dateKey == TimeUtils.todayKey) return 'BUGÜN';
    if (dateKey == TimeUtils.yesterdayKey) return 'DÜN';
    final parsed = DateTime.tryParse(dateKey);
    if (parsed == null) return dateKey;
    return DateFormat.MMMd(localeName).format(parsed);
  }

  /// Builds a flat list of items: each item is either a _SectionHeader (String)
  /// or a _EntryTile (SessionLogEntry).
  List<Object> _buildFlatList() {
    // Group entries by dateKey preserving insertion order (entries already sorted newest-first).
    final Map<String, List<SessionLogEntry>> groups = {};
    for (final e in _entries) {
      groups.putIfAbsent(e.dateKey, () => []).add(e);
    }

    final flat = <Object>[];
    for (final key in groups.keys) {
      flat.add(_SectionKey(key));
      flat.addAll(groups[key]!);
    }
    return flat;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _entries.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.history_rounded,
                          size: 32,
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.historyEmptyTitle,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.historyEmptyBody,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : _buildGroupedList(theme, l10n, localeName),
      ),
    );
  }

  Widget _buildGroupedList(
    ThemeData theme,
    AppLocalizations l10n,
    String localeName,
  ) {
    final flat = _buildFlatList();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      itemCount: flat.length,
      itemBuilder: (context, index) {
        final item = flat[index];

        if (item is _SectionKey) {
          // Section header
          final label = _sectionLabel(item.dateKey, localeName);
          final isFirst = index == 0;
          return Padding(
            padding: EdgeInsets.only(top: isFirst ? 8 : 24, bottom: 10),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceSubtle,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          );
        }

        // Entry tile
        final e = item as SessionLogEntry;
        final durationLabel = l10n.formatSessionMinutes(e.durationMinutes);
        final isLast =
            index == flat.length - 1 || flat[index + 1] is _SectionKey;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.historyRowDetail(
                          durationLabel,
                          _timeLabel(e.completedAtMs),
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A marker object representing a section header with its date key.
class _SectionKey {
  const _SectionKey(this.dateKey);
  final String dateKey;
}
