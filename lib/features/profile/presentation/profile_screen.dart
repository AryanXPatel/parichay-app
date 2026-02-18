import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _headlineController = TextEditingController();
  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _preferredRoleController = TextEditingController();
  final _salaryController = TextEditingController();
  final _noticeController = TextEditingController();

  String? _photoPath;
  bool _resumeUploaded = false;
  bool _loading = true;
  bool _saving = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _headlineController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _preferredRoleController.dispose();
    _salaryController.dispose();
    _noticeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await AppServices.instance.profileRepository.getProfile();
    if (!mounted) {
      return;
    }

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _phoneController.text = profile.phone;
    _emailController.text = profile.email;
    _locationController.text = profile.location;
    _headlineController.text = profile.headline;
    _skillsController.text = profile.skills.join(', ');
    _educationController.text = profile.education;
    _experienceController.text = profile.experienceYears.toString();
    _preferredRoleController.text = profile.preferredRole;
    _salaryController.text = profile.salaryExpectedLpa.toString();
    _noticeController.text = profile.noticePeriodDays.toString();
    _photoPath = profile.photoPath;
    _resumeUploaded = profile.resumeUploaded;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final validationMessage = _validateProfile(l10n);
    if (validationMessage != null) {
      setState(() {
        _message = validationMessage;
        _messageIsError = true;
      });
      return;
    }

    final experienceYears = int.parse(_experienceController.text.trim());
    final expectedSalaryLpa = int.parse(_salaryController.text.trim());
    final noticePeriodDays = int.parse(_noticeController.text.trim());

    setState(() {
      _saving = true;
      _message = null;
      _messageIsError = false;
    });

    final profile = CandidateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photoPath: _photoPath,
      location: _locationController.text.trim(),
      headline: _headlineController.text.trim(),
      skills: _skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toList(),
      education: _educationController.text.trim(),
      experienceYears: experienceYears,
      preferredRole: _preferredRoleController.text.trim(),
      salaryExpectedLpa: expectedSalaryLpa,
      noticePeriodDays: noticePeriodDays,
      resumeUploaded: _resumeUploaded,
    );

    try {
      await AppServices.instance.profileRepository.saveProfile(profile);
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
        _message = l10n.profileSaveSuccess;
        _messageIsError = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _message = l10n.profileSaveError;
        _messageIsError = true;
      });
    }
  }

  String? _validateProfile(AppLocalizations l10n) {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final skills = _skillsController.text
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();

    if (firstName.isEmpty || lastName.isEmpty) {
      return l10n.profileValidationName;
    }
    if (phone.replaceAll(RegExp(r'\D'), '').length < 10) {
      return l10n.profileValidationPhone;
    }
    final validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!validEmail) {
      return l10n.profileValidationEmail;
    }
    if (skills.isEmpty) {
      return l10n.profileValidationSkills;
    }

    final numericInputs = {
      l10n.profileFieldExperience: _experienceController.text.trim(),
      l10n.profileFieldSalary: _salaryController.text.trim(),
      l10n.profileFieldNotice: _noticeController.text.trim(),
    };

    for (final entry in numericInputs.entries) {
      final value = int.tryParse(entry.value);
      if (value == null || value < 0) {
        return l10n.profileValidationNumeric(entry.key);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const AppPageLoader();
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              120,
            ),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: l10n.profilePhotoTitle,
                      subtitle: l10n.profilePhotoSubtitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          child: Text(
                            _photoPath == null ? '?' : 'P',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _photoPath == null
                                ? l10n.profilePhotoPlaceholder
                                : l10n.profilePhotoAttached,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _photoPath = _photoPath == null
                                  ? 'mock://candidate-photo'
                                  : null;
                            });
                          },
                          child: Text(
                            _photoPath == null
                                ? l10n.profilePhotoActionAdd
                                : l10n.profilePhotoActionRemove,
                          ),
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
                      title: l10n.profileBasicTitle,
                      subtitle: l10n.profileBasicSubtitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildField(
                      controller: _firstNameController,
                      label: l10n.profileFieldFirstName,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _lastNameController,
                      label: l10n.profileFieldLastName,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _phoneController,
                      label: l10n.profileFieldPhone,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _emailController,
                      label: l10n.profileFieldEmail,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _locationController,
                      label: l10n.profileFieldLocation,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _headlineController,
                      label: l10n.profileFieldHeadline,
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
                      title: l10n.profileProfessionalTitle,
                      subtitle: l10n.profileProfessionalSubtitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildField(
                      controller: _skillsController,
                      label: l10n.profileFieldSkills,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _educationController,
                      label: l10n.profileFieldEducation,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _experienceController,
                      label: l10n.profileFieldExperience,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _preferredRoleController,
                      label: l10n.profileFieldRole,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _salaryController,
                      label: l10n.profileFieldSalary,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildField(
                      controller: _noticeController,
                      label: l10n.profileFieldNotice,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SwitchListTile(
                      value: _resumeUploaded,
                      onChanged: (value) =>
                          setState(() => _resumeUploaded = value),
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.profileResumeUploaded),
                      subtitle: Text(l10n.profileResumeSubtitle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_message != null) ...[
                  Text(
                    _message!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _messageIsError
                          ? AppColors.danger
                          : AppColors.success,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                AppPrimaryButton(
                  label: _saving
                      ? l10n.profileSaveBusy
                      : l10n.profileSaveButton,
                  icon: Icons.save_outlined,
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }
}
