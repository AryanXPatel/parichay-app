import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_gradients.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _identifierController = TextEditingController();
  final _otpController = TextEditingController();

  bool _otpRequested = false;
  bool _busy = false;
  String? _error;

  bool get _canRequestOtp =>
      !_busy && _identifierController.text.trim().isNotEmpty;

  bool get _canVerifyOtp =>
      !_busy &&
      _identifierController.text.trim().isNotEmpty &&
      _otpController.text.trim().length == 6;

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

  @override
  void dispose() {
    _identifierController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    final l10n = AppLocalizations.of(context)!;
    final validationError = _validateIdentifier(l10n);
    if (validationError != null) {
      setState(() {
        _error = validationError;
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final ok = await AppServices.instance.authRepository.requestOtp(
      _identifierController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _busy = false;
      _otpRequested = ok;
      if (!ok) {
        _error = l10n.signInErrorIdentifierInvalid;
      }
    });
  }

  Future<void> _verifyOtp() async {
    final l10n = AppLocalizations.of(context)!;
    if (_otpController.text.trim().length != 6) {
      setState(() {
        _error = l10n.signInErrorOtpLength;
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final ok = await AppServices.instance.authRepository.verifyOtp(
      _identifierController.text.trim(),
      _otpController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _busy = false;
      if (!ok) {
        _error = l10n.signInErrorOtpInvalid;
      }
    });

    if (ok) {
      await AppServices.instance.appSessionStore.setHasSeenWelcome(false);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.spotlight),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: AppCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppSectionHeader(
                                title: l10n.signInTitle,
                                subtitle: l10n.signInSubtitle,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextField(
                                controller: _identifierController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: _otpRequested
                                    ? TextInputAction.next
                                    : TextInputAction.done,
                                onChanged: (_) {
                                  if (_error == null) {
                                    setState(() {});
                                    return;
                                  }
                                  setState(() => _error = null);
                                },
                                onSubmitted: (_) {
                                  if (!_otpRequested && _canRequestOtp) {
                                    _requestOtp();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: l10n.signInIdentifierLabel,
                                  hintText: l10n.signInIdentifierHint,
                                ),
                              ),
                              if (_otpRequested) ...[
                                const SizedBox(height: AppSpacing.sm),
                                TextField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  maxLength: 6,
                                  onChanged: (_) {
                                    if (_error == null) {
                                      setState(() {});
                                      return;
                                    }
                                    setState(() => _error = null);
                                  },
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
                              ],
                              if (_error != null) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  _error!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.danger),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.sm),
                              AppPrimaryButton(
                                label: _otpRequested
                                    ? l10n.signInVerifyOtp
                                    : l10n.signInRequestOtp,
                                icon: _otpRequested
                                    ? AppIcons.verified
                                    : AppIcons.message,
                                isLoading: _busy,
                                onPressed: _otpRequested
                                    ? (_canVerifyOtp ? _verifyOtp : null)
                                    : (_canRequestOtp ? _requestOtp : null),
                              ),
                              if (kDebugMode) ...[
                                const SizedBox(height: AppSpacing.sm),
                                AppStatusChip(
                                  label: l10n.signInDebugOtp,
                                  tone: AppStatusTone.info,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
