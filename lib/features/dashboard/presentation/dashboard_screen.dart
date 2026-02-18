import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/theme/app_theme_extensions.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<_DashboardViewData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageLoader();
        }
        if (snapshot.hasError) {
          return AppEmptyState(
            title: l10n.dashboardLoadErrorTitle,
            message: l10n.dashboardLoadErrorMessage,
            icon: Icons.dashboard_outlined,
            actionLabel: l10n.commonRefresh,
            onAction: _refresh,
          );
        }
        if (!snapshot.hasData) {
          return AppEmptyState(
            title: l10n.dashboardLoadErrorTitle,
            message: l10n.dashboardLoadErrorMessage,
            icon: Icons.dashboard_outlined,
            actionLabel: l10n.commonRefresh,
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
                      l10n.dashboardHello(data.profile.firstName),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.dashboardWalletCredits(
                        data.walletBalance.toStringAsFixed(0),
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.dashboardYearDownloads('${data.metrics.downloads}'),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        AppStatusChip(
                          label: l10n.dashboardProfileCompleteChip(
                            '${data.completeness.percentage}',
                          ),
                          tone: profileTone,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        AppStatusChip(
                          label: l10n.dashboardDocsVerifiedChip(
                            '$verifiedDocs',
                          ),
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
                    AppSectionHeader(
                      title: l10n.dashboardCompletenessTitle,
                      subtitle: l10n.dashboardCompletenessSubtitle,
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
                      label: l10n.dashboardImproveButton,
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
                      label: l10n.dashboardWeeklyViews,
                      value: '${data.metrics.weeklyViews}',
                      icon: Icons.remove_red_eye_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppMetricCard(
                      label: l10n.dashboardMonthlyViews,
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
                      label: l10n.dashboardWeeklyDownloads,
                      value: '${data.metrics.weeklyDownloads}',
                      icon: Icons.download_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppMetricCard(
                      label: l10n.dashboardMonthlyDownloads,
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
                      label: l10n.dashboardYearlyDownloads,
                      value: '${data.metrics.yearlyDownloads}',
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppMetricCard(
                      label: l10n.dashboardUnreadAlerts,
                      value: '$unread',
                      icon: Icons.notifications_active_outlined,
                      hint: unread > 0
                          ? l10n.dashboardActionNeeded
                          : l10n.dashboardAllClear,
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
                      title: l10n.dashboardRecentTitle,
                      subtitle: l10n.dashboardRecentSubtitle,
                      trailing: TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.notifications),
                        child: Text(l10n.dashboardViewAll),
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
                      label: Text(l10n.dashboardVerification),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.payouts),
                      icon: const Icon(Icons.account_balance_outlined),
                      label: Text(l10n.dashboardPayouts),
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
