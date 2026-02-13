import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/theme/app_theme_extensions.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<_DashboardViewData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashboardViewData> _load() async {
    final services = AppServices.instance;
    final profile = await services.profileRepository.getProfile();
    final completeness = await services.profileRepository.getCompleteness();
    final docs = await services.documentRepository.listDocuments();
    final wallet = await services.walletRepository.getBalance();
    final metrics = await services.profileRepository.getActivityMetrics();
    final notifications = await services.notificationRepository
        .listNotifications();
    final suggestions = await services.profileRepository
        .getImprovementSuggestions();
    return _DashboardViewData(
      profile: profile,
      completeness: completeness,
      documents: docs,
      walletBalance: wallet,
      metrics: metrics,
      notifications: notifications,
      suggestions: suggestions,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardViewData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageLoader();
        }
        if (snapshot.hasError) {
          return AppEmptyState(
            title: 'Unable to load dashboard',
            message: 'Try refreshing to fetch your latest candidate metrics.',
            icon: Icons.dashboard_outlined,
            actionLabel: 'Refresh',
            onAction: _refresh,
          );
        }
        if (!snapshot.hasData) {
          return AppEmptyState(
            title: 'Unable to load dashboard',
            message: 'Try refreshing to fetch your latest candidate metrics.',
            icon: Icons.dashboard_outlined,
            actionLabel: 'Refresh',
            onAction: _refresh,
          );
        }

        final data = snapshot.data!;
        final verifiedDocs = data.documents
            .where((item) => item.status == VerificationStatus.verified)
            .length;
        final unread = data.notifications.where((item) => !item.isRead).length;
        final profileTone = data.completeness.percentage >= 80
            ? AppStatusTone.success
            : data.completeness.percentage >= 60
            ? AppStatusTone.warning
            : AppStatusTone.danger;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                gradient: context.surfaceStyles.heroGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello ${data.profile.firstName}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${data.walletBalance.toStringAsFixed(0)} credits in wallet',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your profile was downloaded ${data.metrics.downloads} times this year.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        AppStatusChip(
                          label: '${data.completeness.percentage}% complete',
                          tone: profileTone,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        AppStatusChip(
                          label: '$verifiedDocs docs verified',
                          tone: AppStatusTone.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSectionHeader(
                      title: 'Profile completeness',
                      subtitle:
                          'Complete missing fields to increase recruiter conversion.',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: data.completeness.percentage / 100,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(999),
                      backgroundColor: AppColors.brand100,
                      color: AppColors.brand600,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: data.suggestions
                          .take(3)
                          .map(
                            (item) => AppStatusChip(
                              label: item,
                              tone: AppStatusTone.info,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppPrimaryButton(
                      label: 'Improve profile views',
                      icon: Icons.trending_up_rounded,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.profile),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppMetricCard(
                      label: 'Weekly views',
                      value: '${data.metrics.weeklyViews}',
                      icon: Icons.remove_red_eye_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppMetricCard(
                      label: 'Monthly views',
                      value: '${data.metrics.monthlyViews}',
                      icon: Icons.stacked_line_chart_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppMetricCard(
                      label: 'Weekly downloads',
                      value: '${data.metrics.weeklyDownloads}',
                      icon: Icons.download_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppMetricCard(
                      label: 'Monthly downloads',
                      value: '${data.metrics.monthlyDownloads}',
                      icon: Icons.download_for_offline_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppMetricCard(
                      label: 'Yearly downloads',
                      value: '${data.metrics.yearlyDownloads}',
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppMetricCard(
                      label: 'Unread alerts',
                      value: '$unread',
                      icon: Icons.notifications_active_outlined,
                      hint: unread > 0 ? 'Action needed' : 'All clear',
                      tone: unread > 0
                          ? AppStatusTone.warning
                          : AppStatusTone.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: 'Recent activity',
                      subtitle:
                          'Latest profile events and verification updates.',
                      trailing: TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.notifications),
                        child: const Text('View all'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ...data.notifications
                        .take(3)
                        .map(
                          (item) => ListTile(
                            dense: true,
                            leading: Icon(
                              item.isRead
                                  ? Icons.mark_email_read_outlined
                                  : Icons.mark_email_unread_outlined,
                            ),
                            title: Text(item.title),
                            subtitle: Text(item.message),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.verification),
                      icon: const Icon(Icons.verified_user_outlined),
                      label: const Text('Verification'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.payouts),
                      icon: const Icon(Icons.account_balance_outlined),
                      label: const Text('Payouts'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardViewData {
  const _DashboardViewData({
    required this.profile,
    required this.completeness,
    required this.documents,
    required this.walletBalance,
    required this.metrics,
    required this.notifications,
    required this.suggestions,
  });

  final CandidateProfile profile;
  final ProfileCompleteness completeness;
  final List<CandidateDocument> documents;
  final double walletBalance;
  final CandidateActivityMetrics metrics;
  final List<AppNotificationItem> notifications;
  final List<String> suggestions;
}
