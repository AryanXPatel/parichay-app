import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class VerificationCenterScreen extends StatefulWidget {
  const VerificationCenterScreen({super.key});

  @override
  State<VerificationCenterScreen> createState() =>
      _VerificationCenterScreenState();
}

class _VerificationCenterScreenState extends State<VerificationCenterScreen> {
  final _messageController = TextEditingController();
  bool _sending = false;

  late Future<_VerificationData> _future;

  bool get _canSendQuery =>
      !_sending && _messageController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<_VerificationData> _load() async {
    final services = AppServices.instance;
    final docs = await services.documentRepository.listDocuments();
    final checklist = await services.documentRepository
        .getVerificationChecklist();
    final messages = await services.documentRepository
        .listVerificationMessages();
    return _VerificationData(
      docs: docs,
      checklist: checklist,
      messages: messages,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _sending = true;
    });
    await AppServices.instance.documentRepository.sendVerificationMessage(text);
    _messageController.clear();
    await _refresh();
    if (!mounted) {
      return;
    }
    setState(() {
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification center')),
      body: FutureBuilder<_VerificationData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppPageLoader();
          }
          if (snapshot.hasError) {
            return AppEmptyState(
              title: 'Unable to load verification center',
              message: 'Please refresh and try again.',
              icon: Icons.verified_user_outlined,
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          final data = snapshot.data;
          if (data == null) {
            return AppEmptyState(
              title: 'Unable to load verification center',
              message: 'Please refresh and try again.',
              icon: Icons.verified_user_outlined,
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          final verifiedCount = data.checklist
              .where((item) => item.isVerified)
              .length;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Verification checklist',
                        subtitle:
                            'Track checklist status and resolve admin queries quickly.',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppStatusChip(
                        label:
                            '$verifiedCount/${data.checklist.length} completed',
                        tone: verifiedCount == data.checklist.length
                            ? AppStatusTone.success
                            : AppStatusTone.warning,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...data.checklist.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            item.isVerified
                                ? Icons.check_circle_rounded
                                : Icons.pending_outlined,
                          ),
                          title: Text(item.label),
                          subtitle: item.note == null ? null : Text(item.note!),
                          trailing: AppStatusChip(
                            label: item.isVerified ? 'Verified' : 'Pending',
                            tone: item.isVerified
                                ? AppStatusTone.success
                                : AppStatusTone.warning,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Uploaded documents',
                        subtitle:
                            'Current verification state per document type.',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...data.docs.map((doc) {
                        final tone = switch (doc.status) {
                          VerificationStatus.pending => AppStatusTone.warning,
                          VerificationStatus.verified => AppStatusTone.success,
                          VerificationStatus.rejected => AppStatusTone.danger,
                        };
                        final label = switch (doc.status) {
                          VerificationStatus.pending => 'Pending',
                          VerificationStatus.verified => 'Verified',
                          VerificationStatus.rejected => 'Rejected',
                        };
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.description_outlined),
                          title: Text(doc.title),
                          subtitle: Text(doc.type),
                          trailing: AppStatusChip(label: label, tone: tone),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Verification queries',
                        subtitle:
                            'Candidate-admin thread for document clarifications in MVP.',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (data.messages.isEmpty)
                        const AppEmptyState(
                          title: 'No queries yet',
                          message:
                              'Send a message if you need help with document verification.',
                          icon: Icons.forum_outlined,
                        )
                      else
                        ...data.messages.map(
                          (item) => Align(
                            alignment: item.fromAdmin
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.xs,
                              ),
                              child: AppStatusChip(
                                label: item.message,
                                tone: item.fromAdmin
                                    ? AppStatusTone.warning
                                    : AppStatusTone.info,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _messageController,
                        minLines: 2,
                        maxLines: 4,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Send message to verification admin',
                          hintText:
                              'Describe your document verification query...',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppPrimaryButton(
                        label: 'Send query',
                        icon: Icons.send_rounded,
                        isLoading: _sending,
                        onPressed: _canSendQuery ? _sendMessage : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _VerificationData {
  const _VerificationData({
    required this.docs,
    required this.checklist,
    required this.messages,
  });

  final List<CandidateDocument> docs;
  final List<VerificationChecklistItem> checklist;
  final List<VerificationMessage> messages;
}
