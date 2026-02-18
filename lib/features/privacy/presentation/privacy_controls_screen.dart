import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class PrivacyControlsScreen extends StatefulWidget {
  const PrivacyControlsScreen({super.key});

  @override
  State<PrivacyControlsScreen> createState() => _PrivacyControlsScreenState();
}

class _PrivacyControlsScreenState extends State<PrivacyControlsScreen> {
  late Future<Map<String, bool>> _future;

  @override
  void initState() {
    super.initState();
    _future = AppServices.instance.profileRepository.getPrivacySettings();
  }

  Future<void> _updateSetting(String key, bool value) async {
    await AppServices.instance.profileRepository.updatePrivacySetting(
      key,
      value,
    );
    setState(() {
      _future = AppServices.instance.profileRepository.getPrivacySettings();
    });
  }

  Future<void> _reload() async {
    setState(() {
      _future = AppServices.instance.profileRepository.getPrivacySettings();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy controls')),
      body: FutureBuilder<Map<String, bool>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppPageLoader();
          }
          if (snapshot.hasError) {
            return AppEmptyState(
              title: 'Unable to load privacy controls',
              message: 'Please refresh and try again.',
              icon: AppIcons.lock,
              actionLabel: 'Refresh',
              onAction: _reload,
            );
          }

          final settings = snapshot.data ?? {};
          if (settings.isEmpty) {
            return const AppEmptyState(
              title: 'No privacy settings available',
              message: 'Please try again later.',
              icon: AppIcons.lock,
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                const AppCard(
                  tone: AppCardTone.muted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSectionHeader(
                        title: 'Field-level privacy',
                        subtitle:
                            'Control what recruiters see in preview before profile unlock/download.',
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppStatusChip(
                        label: 'Changes apply instantly',
                        tone: AppStatusTone.info,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  tone: AppCardTone.surface,
                  child: Column(
                    children: settings.entries.toList().asMap().entries.map((
                      item,
                    ) {
                      final entry = item.value;
                      return Column(
                        children: [
                          _PrivacyToggleRow(
                            label: _humanize(entry.key),
                            value: entry.value,
                            onChanged: (value) =>
                                _updateSetting(entry.key, value),
                          ),
                          if (item.key != settings.length - 1)
                            const Divider(height: AppSpacing.lg),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _humanize(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map(
          (part) => part.isEmpty
              ? ''
              : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _PrivacyToggleRow extends StatelessWidget {
  const _PrivacyToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                value ? 'Visible in recruiter preview' : 'Masked until unlock',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
