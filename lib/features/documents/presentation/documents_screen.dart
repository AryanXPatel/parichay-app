import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

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
      setState(() {
        _uploadMessage = 'Document uploaded and queued for verification.';
        _uploadMessageTone = AppStatusTone.success;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _uploadMessage = 'Unable to upload document. Please try again.';
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
    return FutureBuilder<List<CandidateDocument>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageLoader();
        }
        if (snapshot.hasError) {
          return AppEmptyState(
            title: 'Unable to load documents',
            message: 'Please refresh and try again.',
            icon: Icons.description_outlined,
            actionLabel: 'Refresh',
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
                    const AppSectionHeader(
                      title: 'Upload and verify documents',
                      subtitle:
                          'Resume + supporting documents increase ranking and recruiter trust.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppPrimaryButton(
                            label: _uploading
                                ? 'Uploading document...'
                                : 'Upload mock document',
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
                      label: const Text('Open verification center'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (docs.isEmpty)
                const AppEmptyState(
                  title: 'No documents yet',
                  message:
                      'Upload resume, education, and ID documents to begin verification.',
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
                    VerificationStatus.pending => 'Pending',
                    VerificationStatus.verified => 'Verified',
                    VerificationStatus.rejected => 'Rejected',
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
