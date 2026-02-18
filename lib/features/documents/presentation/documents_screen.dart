import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/l10n/app_localizations.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late Future<List<CandidateDocument>> _future;
  bool _uploading = false;
  String? _uploadMessage;
  AppStatusTone _uploadMessageTone = AppStatusTone.info;

  @override
  void initState() {
    super.initState();
    _future = AppServices.instance.documentRepository.listDocuments();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = AppServices.instance.documentRepository.listDocuments();
    });
    await _future;
  }

  Future<void> _uploadMockDoc() async {
    if (_uploading) {
      return;
    }
    setState(() {
      _uploading = true;
      _uploadMessage = null;
    });
    try {
      await AppServices.instance.documentRepository.uploadDocument(
        'Experience Letter',
        'Employment',
      );
      await _refresh();
      if (!mounted) {
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _uploadMessage = l10n.documentsUploadSuccess;
        _uploadMessageTone = AppStatusTone.success;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _uploadMessage = l10n.documentsUploadError;
        _uploadMessageTone = AppStatusTone.danger;
      });
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<List<CandidateDocument>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageLoader();
        }
        if (snapshot.hasError) {
          return AppEmptyState(
            title: l10n.documentsLoadErrorTitle,
            message: l10n.documentsLoadErrorMessage,
            icon: Icons.description_outlined,
            actionLabel: l10n.commonRefresh,
            onAction: _refresh,
          );
        }

        final docs = snapshot.data ?? [];
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: l10n.documentsHeaderTitle,
                      subtitle: l10n.documentsHeaderSubtitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppPrimaryButton(
                            label: _uploading
                                ? l10n.documentsUploadingButton
                                : l10n.documentsUploadButton,
                            icon: Icons.upload_file_rounded,
                            isLoading: _uploading,
                            onPressed: _uploading ? null : _uploadMockDoc,
                          ),
                        ),
                      ],
                    ),
                    if (_uploadMessage != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      AppStatusChip(
                        label: _uploadMessage!,
                        tone: _uploadMessageTone,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.verification),
                      icon: const Icon(Icons.verified_user_outlined),
                      label: Text(l10n.documentsOpenVerification),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (docs.isEmpty)
                AppEmptyState(
                  title: l10n.documentsEmptyTitle,
                  message: l10n.documentsEmptyMessage,
                  icon: Icons.description_outlined,
                )
              else
                ...docs.map((doc) {
                  final status = switch (doc.status) {
                    VerificationStatus.pending => AppStatusTone.warning,
                    VerificationStatus.verified => AppStatusTone.success,
                    VerificationStatus.rejected => AppStatusTone.danger,
                  };
                  final statusLabel = switch (doc.status) {
                    VerificationStatus.pending => l10n.commonPending,
                    VerificationStatus.verified => l10n.commonVerified,
                    VerificationStatus.rejected => l10n.commonRejected,
                  };
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.brand50,
                        child: Icon(
                          Icons.description_outlined,
                          color: AppColors.brand700,
                        ),
                      ),
                      title: Text(doc.title),
                      subtitle: Text(
                        '${doc.type} • ${_dateLabel(doc.uploadedAt)}',
                      ),
                      trailing: AppStatusChip(label: statusLabel, tone: status),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }
}
