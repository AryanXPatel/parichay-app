import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

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
        if (snapshot.hasError || !snapshot.hasData) {
          return AppEmptyState(
            title: l10n.dashboardLoadErrorTitle,
            message: l10n.dashboardLoadErrorMessage,
            icon: AppIcons.home,
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
                tone: AppCardTone.elevated,
                gradient: context.surfaceStyles.heroGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dashboardHello(data.profile.firstName),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textOnBrand,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.dashboardWalletCredits(
                        data.walletBalance.toStringAsFixed(0),
                      ),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textOnBrand,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.dashboardYearDownloads('${data.metrics.downloads}'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.brand100,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        AppStatusChip(
                          label: l10n.dashboardProfileCompleteChip(
                            '${data.completeness.percentage}',
                          ),
                          tone: profileTone,
                        ),
                        AppStatusChip(
                          label: l10n.dashboardDocsVerifiedChip(
                            '$verifiedDocs',
                          ),
                          tone: AppStatusTone.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.payouts),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.brand100),
                        foregroundColor: AppColors.brand50,
                      ),
                      icon: const Icon(AppIcons.bank),
                      label: Text(l10n.walletRequestPayout),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                tone: AppCardTone.muted,
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
                      backgroundColor: AppColors.brand200,
                      color: AppColors.brand700,
                    ),
                    if (data.suggestions.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.infoSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.suggestions.first,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    AppPrimaryButton(
                      label: l10n.dashboardImproveButton,
                      icon: AppIcons.trendUp,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.profile),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                tone: AppCardTone.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: 'Activity snapshot',
                      subtitle: 'Core profile engagement this month.',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MetricRow(
                      label: l10n.dashboardWeeklyViews,
                      value: '${data.metrics.weeklyViews}',
                      icon: AppIcons.eye,
                    ),
                    const Divider(height: AppSpacing.lg),
                    _MetricRow(
                      label: l10n.dashboardMonthlyViews,
                      value: '${data.metrics.monthlyViews}',
                      icon: AppIcons.chart,
                    ),
                    const Divider(height: AppSpacing.lg),
                    _MetricRow(
                      label: l10n.dashboardMonthlyDownloads,
                      value: '${data.metrics.monthlyDownloads}',
                      icon: AppIcons.downloadAlt,
                    ),
                    const Divider(height: AppSpacing.lg),
                    _MetricRow(
                      label: l10n.dashboardUnreadAlerts,
                      value: '$unread',
                      icon: AppIcons.alertsActive,
                      statusLabel: unread > 0
                          ? l10n.dashboardActionNeeded
                          : l10n.dashboardAllClear,
                      statusTone: unread > 0
                          ? AppStatusTone.warning
                          : AppStatusTone.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                tone: AppCardTone.surface,
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
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              item.isRead
                                  ? AppIcons.emailRead
                                  : AppIcons.emailUnread,
                            ),
                            title: Text(item.title),
                            subtitle: Text(item.message),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.verification),
                    icon: const Icon(AppIcons.verified),
                    label: Text(l10n.dashboardVerification),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.payouts),
                    icon: const Icon(AppIcons.bank),
                    label: Text(l10n.dashboardPayouts),
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

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
    this.statusLabel,
    this.statusTone,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? statusLabel;
  final AppStatusTone? statusTone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.brand100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.brand700),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        if (statusLabel != null && statusTone != null) ...[
          const SizedBox(width: AppSpacing.xs),
          AppStatusChip(label: statusLabel!, tone: statusTone!),
        ],
      ],
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
