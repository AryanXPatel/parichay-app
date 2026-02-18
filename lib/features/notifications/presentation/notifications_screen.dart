import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotificationItem>> _future;
  bool _markingAllRead = false;
  final Set<String> _markingIds = <String>{};

  @override
  void initState() {
    super.initState();
    _future = AppServices.instance.notificationRepository.listNotifications();
  }

  Future<void> _reload() async {
    setState(() {
      _future = AppServices.instance.notificationRepository.listNotifications();
    });
    await _future;
  }

  Future<void> _markAllRead() async {
    if (_markingAllRead) {
      return;
    }
    setState(() {
      _markingAllRead = true;
    });
    try {
      final notifications = await AppServices.instance.notificationRepository
          .listNotifications();
      final unreadCount = notifications.where((item) => !item.isRead).length;
      if (unreadCount == 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All notifications are already read.'),
            ),
          );
        }
        return;
      }

      await AppServices.instance.notificationRepository.markAllRead();
      await _reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _markingAllRead = false;
        });
      }
    }
  }

  Future<void> _markOneRead(AppNotificationItem item) async {
    if (item.isRead || _markingIds.contains(item.id)) {
      return;
    }
    setState(() {
      _markingIds.add(item.id);
    });
    try {
      await AppServices.instance.notificationRepository.markRead(item.id);
      await _reload();
    } finally {
      if (mounted) {
        setState(() {
          _markingIds.remove(item.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markingAllRead ? null : _markAllRead,
            child: Text(_markingAllRead ? 'Marking...' : 'Mark all read'),
          ),
        ],
      ),
      body: FutureBuilder<List<AppNotificationItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppPageLoader();
          }
          if (snapshot.hasError) {
            return AppEmptyState(
              title: 'Unable to load notifications',
              message: 'Please refresh and try again.',
              icon: AppIcons.alerts,
              actionLabel: 'Refresh',
              onAction: _reload,
            );
          }

          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const AppEmptyState(
              title: 'No notifications yet',
              message:
                  'Profile views and verification updates will appear here.',
              icon: AppIcons.alerts,
            );
          }

          final unreadCount = notifications
              .where((item) => !item.isRead)
              .length;

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  tone: AppCardTone.muted,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          unreadCount == 0
                              ? 'You are all caught up.'
                              : '$unreadCount unread updates need attention.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      AppStatusChip(
                        label: unreadCount == 0 ? 'All read' : 'Unread',
                        tone: unreadCount == 0
                            ? AppStatusTone.success
                            : AppStatusTone.warning,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...notifications.map(
                  (item) => AppCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    tone: item.isRead ? AppCardTone.surface : AppCardTone.muted,
                    onTap: item.isRead ? null : () => _markOneRead(item),
                    child: _NotificationRow(
                      item: item,
                      dateLabel: _dateLabel(item.createdAt),
                      marking: _markingIds.contains(item.id),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month';
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.item,
    required this.dateLabel,
    required this.marking,
  });

  final AppNotificationItem item;
  final String dateLabel;
  final bool marking;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: item.isRead
                  ? AppColors.slate100
                  : AppColors.brand600,
              child: Icon(
                item.isRead ? AppIcons.alerts : AppIcons.alertsActive,
                color: item.isRead ? AppColors.textSecondary : Colors.white,
              ),
            ),
            if (!item.isRead)
              const Positioned(
                right: -1,
                top: -1,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: AppColors.danger,
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 2),
              Text(item.message, style: Theme.of(context).textTheme.bodyMedium),
              if (!item.isRead) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  marking ? 'Marking as read...' : 'Tap to mark as read',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
