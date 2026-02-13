import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
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
              icon: Icons.lock_outline_rounded,
              actionLabel: 'Refresh',
              onAction: () {
                setState(() {
                  _future = AppServices.instance.profileRepository
                      .getPrivacySettings();
                });
              },
            );
          }

          final settings = snapshot.data ?? {};
          if (settings.isEmpty) {
            return const AppEmptyState(
              title: 'No privacy settings available',
              message: 'Please try again later.',
              icon: Icons.lock_outline_rounded,
            );
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const AppCard(
                child: AppSectionHeader(
                  title: 'Field-level privacy',
                  subtitle:
                      'Control what recruiters see in preview before profile unlock/download.',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...settings.entries.map(
                (entry) => AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SwitchListTile(
                    title: Text(_humanize(entry.key)),
                    subtitle: Text(
                      entry.value
                          ? 'Visible in preview'
                          : 'Masked until unlock',
                    ),
                    value: entry.value,
                    onChanged: (value) => _updateSetting(entry.key, value),
                  ),
                ),
              ),
            ],
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
