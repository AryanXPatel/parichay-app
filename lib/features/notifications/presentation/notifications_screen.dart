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

  @override
  void initState() {
    super.initState();
    _future = AppServices.instance.notificationRepository.listNotifications();
  }

  Future<void> _reload() async {
    setState(() {
      _future = AppServices.instance.notificationRepository.listNotifications();
    });
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

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.isRead
                          ? AppColors.brand100
                          : AppColors.brand600,
                      child: Icon(
                        item.isRead
                            ? AppIcons.alerts
                            : AppIcons.alertsActive,
                        color: item.isRead ? AppColors.brand700 : Colors.white,
                      ),
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.message),
                    trailing: Text(
                      _dateLabel(item.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
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
