import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:parichay_candidate/features/auth/presentation/auth_shell.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const int _resendCooldownSeconds = 30;

  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _roleController = TextEditingController();
  final _otpController = TextEditingController();

  bool _termsAccepted = false;
  bool _otpRequested = false;
  bool _busy = false;
  int _secondsUntilResend = 0;
  String? _error;
  String? _info;
  Timer? _resendTimer;

  bool get _canRequestOtp =>
      !_busy &&
      !_otpRequested &&
      _termsAccepted &&
      _nameController.text.trim().isNotEmpty &&
      _identifierController.text.trim().isNotEmpty &&
      _roleController.text.trim().isNotEmpty;

  bool get _canVerifyOtp =>
      !_busy &&
      _otpRequested &&
      _identifierController.text.trim().isNotEmpty &&
      _otpController.text.trim().length == 6;

  bool get _canResendOtp => !_busy && _otpRequested && _secondsUntilResend == 0;

  @override
  void dispose() {
    _resendTimer?.cancel();
    _nameController.dispose();
    _identifierController.dispose();
    _roleController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validateIdentifier(AppLocalizations l10n) {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      return l10n.signInErrorIdentifierRequired;
    }

    if (identifier.contains('@')) {
      final isEmail = RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      ).hasMatch(identifier);
      if (!isEmail) {
        return l10n.signInErrorEmailInvalid;
      }
      return null;
    }

    final digits = identifier.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      return l10n.signInErrorPhoneInvalid;
    }
    return null;
  }

  String? _validateSignUp(AppLocalizations l10n) {
    if (_nameController.text.trim().length < 2) {
      return 'Enter your full name.';
    }

    final identifierError = _validateIdentifier(l10n);
    if (identifierError != null) {
      return identifierError;
    }

    if (_roleController.text.trim().length < 2) {
      return 'Enter your preferred role.';
    }

    if (!_termsAccepted) {
      return 'Accept terms to continue.';
    }
    return null;
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _secondsUntilResend = _resendCooldownSeconds;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsUntilResend <= 1) {
        timer.cancel();
        setState(() {
          _secondsUntilResend = 0;
        });
        return;
      }
      setState(() {
        _secondsUntilResend -= 1;
      });
    });
  }

  Future<void> _requestOtp({bool isResend = false}) async {
    final l10n = AppLocalizations.of(context)!;
    final validationError = _validateSignUp(l10n);
    if (validationError != null) {
      setState(() {
        _error = validationError;
        _info = null;
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final identifier = _identifierController.text.trim();
    final ok = await AppServices.instance.authRepository.requestOtp(identifier);

    if (!mounted) {
      return;
    }

    setState(() {
      _busy = false;
      if (!ok) {
        _error = l10n.signInErrorIdentifierInvalid;
        _info = null;
        return;
      }
      _otpRequested = true;
      _info = isResend ? 'OTP resent successfully.' : 'OTP sent to $identifier';
    });
    if (ok) {
      _startResendTimer();
    }
  }

  Future<void> _verifyOtp() async {
    final l10n = AppLocalizations.of(context)!;
    if (_otpController.text.trim().length != 6) {
      setState(() {
        _error = l10n.signInErrorOtpLength;
        _info = null;
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final identifier = _identifierController.text.trim();
    final otp = _otpController.text.trim();
    final ok = await AppServices.instance.authRepository.verifyOtp(
      identifier,
      otp,
    );

    if (!mounted) {
      return;
    }

    if (!ok) {
      setState(() {
        _busy = false;
        _error = l10n.signInErrorOtpInvalid;
        _info = null;
      });
      return;
    }

    final currentProfile = await AppServices.instance.profileRepository
        .getProfile();
    final nameParts = _nameController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    final firstName = nameParts.isEmpty
        ? currentProfile.firstName
        : nameParts.first;
    final lastName = nameParts.length < 2
        ? currentProfile.lastName
        : nameParts.sublist(1).join(' ');

    final updatedProfile = currentProfile.copyWith(
      firstName: firstName,
      lastName: lastName,
      phone: identifier.contains('@') ? currentProfile.phone : identifier,
      email: identifier.contains('@') ? identifier : currentProfile.email,
      preferredRole: _roleController.text.trim(),
      headline: '${_roleController.text.trim()} candidate',
    );
    await AppServices.instance.profileRepository.saveProfile(updatedProfile);
    await AppServices.instance.appSessionStore.setHasSeenWelcome(false);

    if (!mounted) {
      return;
    }

    setState(() {
      _busy = false;
      _error = null;
      _info = 'Account verified successfully.';
    });
    Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
  }

  void _resetOtpFlow() {
    _resendTimer?.cancel();
    setState(() {
      _otpRequested = false;
      _secondsUntilResend = 0;
      _otpController.clear();
      _error = null;
      _info = 'You can update your details and request OTP again.';
    });
  }

  String _resendTimerLabel() {
    final seconds = _secondsUntilResend.toString().padLeft(2, '0');
    return 'Resend available in 00:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthShell(
      maxWidth: 460,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppSectionHeader(
                  title: 'Create your account',
                  subtitle:
                      'Register your profile with OTP verification and start applying.',
                ),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.signIn),
                child: const Text('Sign in'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {
              _error = null;
            }),
            decoration: const InputDecoration(
              labelText: 'Full name',
              hintText: 'Anvi Singh',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _identifierController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {
              _error = null;
            }),
            decoration: InputDecoration(
              labelText: l10n.signInIdentifierLabel,
              hintText: l10n.signInIdentifierHint,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _roleController,
            textInputAction: _otpRequested
                ? TextInputAction.next
                : TextInputAction.done,
            onChanged: (_) => setState(() {
              _error = null;
            }),
            decoration: const InputDecoration(
              labelText: 'Preferred role',
              hintText: 'QA Engineer',
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          CheckboxListTile(
            value: _termsAccepted,
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('I confirm these details are accurate.'),
            onChanged: _busy
                ? null
                : (value) => setState(() {
                    _termsAccepted = value ?? false;
                    _error = null;
                  }),
          ),
          if (_otpRequested) ...[
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              onChanged: (_) => setState(() {
                _error = null;
              }),
              onSubmitted: (_) {
                if (_canVerifyOtp) {
                  _verifyOtp();
                }
              },
              decoration: InputDecoration(
                labelText: l10n.signInOtpLabel,
                hintText: l10n.signInOtpHint,
                counterText: '',
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _secondsUntilResend > 0
                        ? _resendTimerLabel()
                        : 'Didn\'t receive OTP?',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: _canResendOtp
                      ? () => _requestOtp(isResend: true)
                      : null,
                  child: const Text('Resend OTP'),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _busy ? null : _resetOtpFlow,
                icon: const Icon(AppIcons.arrowRight),
                label: const Text('Use a different phone/email'),
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _AuthBanner(message: _error!, isError: true),
          ] else if (_info != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _AuthBanner(message: _info!, isError: false),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            label: _otpRequested ? l10n.signInVerifyOtp : 'Create account',
            icon: _otpRequested ? AppIcons.verified : AppIcons.profile,
            isLoading: _busy,
            onPressed: _otpRequested
                ? (_canVerifyOtp ? _verifyOtp : null)
                : (_canRequestOtp ? _requestOtp : null),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.sm),
            AppStatusChip(label: l10n.signInDebugOtp, tone: AppStatusTone.info),
          ],
        ],
      ),
    );
  }
}

class _AuthBanner extends StatelessWidget {
  const _AuthBanner({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final fg = isError ? AppColors.danger : AppColors.info;
    final bg = isError ? AppColors.dangerSubtle : AppColors.infoSubtle;
    final icon = isError ? AppIcons.alertsActive : AppIcons.check;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
