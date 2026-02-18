import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
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

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month';
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
              icon: AppIcons.verified,
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          final data = snapshot.data;
          if (data == null) {
            return AppEmptyState(
              title: 'Unable to load verification center',
              message: 'Please refresh and try again.',
              icon: AppIcons.verified,
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          final verifiedCount = data.checklist
              .where((item) => item.isVerified)
              .length;
          final pendingDocs = data.docs
              .where((doc) => doc.status == VerificationStatus.pending)
              .length;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  tone: AppCardTone.muted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Verification progress',
                        subtitle:
                            'Finish pending items to improve recruiter trust.',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          AppStatusChip(
                            label:
                                '$verifiedCount/${data.checklist.length} completed',
                            tone: verifiedCount == data.checklist.length
                                ? AppStatusTone.success
                                : AppStatusTone.warning,
                          ),
                          AppStatusChip(
                            label: '$pendingDocs documents pending',
                            tone: pendingDocs == 0
                                ? AppStatusTone.success
                                : AppStatusTone.warning,
                          ),
                        ],
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
                      const AppSectionHeader(
                        title: 'Verification checklist',
                        subtitle:
                            'Track checklist status and resolve admin queries quickly.',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...data.checklist.asMap().entries.map((item) {
                        final entry = item.value;
                        return Column(
                          children: [
                            _ChecklistRow(item: entry),
                            if (item.key != data.checklist.length - 1)
                              const Divider(height: AppSpacing.lg),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  tone: AppCardTone.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Uploaded documents',
                        subtitle:
                            'Current verification state per document type.',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...data.docs.asMap().entries.map((item) {
                        return Column(
                          children: [
                            _DocumentStatusRow(doc: item.value),
                            if (item.key != data.docs.length - 1)
                              const Divider(height: AppSpacing.lg),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  tone: AppCardTone.muted,
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
                          icon: AppIcons.chat,
                        )
                      else
                        ...data.messages.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: _QueryBubble(
                              message: item,
                              dateLabel: _dateLabel(item.createdAt),
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
                        label: 'Send query to admin',
                        icon: AppIcons.send,
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

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final VerificationChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final tone = item.isVerified
        ? AppStatusTone.success
        : AppStatusTone.warning;
    final iconBg = item.isVerified
        ? AppColors.successSubtle
        : AppColors.warningSubtle;
    final iconColor = item.isVerified ? AppColors.success : AppColors.warning;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            item.isVerified ? AppIcons.check : AppIcons.pending,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.label, style: Theme.of(context).textTheme.titleSmall),
              if (item.note != null && item.note!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(item.note!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
        AppStatusChip(
          label: item.isVerified ? 'Verified' : 'Pending',
          tone: tone,
        ),
      ],
    );
  }
}

class _DocumentStatusRow extends StatelessWidget {
  const _DocumentStatusRow({required this.doc});

  final CandidateDocument doc;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (doc.status) {
      VerificationStatus.pending => ('Pending', AppStatusTone.warning),
      VerificationStatus.verified => ('Verified', AppStatusTone.success),
      VerificationStatus.rejected => ('Rejected', AppStatusTone.danger),
    };

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.brand100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            AppIcons.document,
            size: 18,
            color: AppColors.brand700,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doc.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(doc.type, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        AppStatusChip(label: label, tone: tone),
      ],
    );
  }
}

class _QueryBubble extends StatelessWidget {
  const _QueryBubble({required this.message, required this.dateLabel});

  final VerificationMessage message;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final isAdmin = message.fromAdmin;
    final status = context.statusStyles;
    final bg = isAdmin ? status.warningSubtle : status.infoSubtle;
    final fg = isAdmin ? status.warning : status.info;

    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: fg.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${isAdmin ? 'Admin' : 'You'} • $dateLabel',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: fg.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
