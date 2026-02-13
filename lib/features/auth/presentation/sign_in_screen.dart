import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_gradients.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  String? _validateIdentifier() {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      return 'Enter phone number or email.';
    }

    if (identifier.contains('@')) {
      final isEmail = RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      ).hasMatch(identifier);
      if (!isEmail) {
        return 'Enter a valid email address.';
      }
      return null;
    }

    final digits = identifier.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      return 'Enter a valid phone number.';
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
    final validationError = _validateIdentifier();
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
        _error = 'Enter a valid phone number or email.';
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      setState(() {
        _error = 'Enter a valid 6-digit OTP.';
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
        _error = 'Invalid OTP. Please try again.';
      }
    });

    if (ok) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.appShell);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              const AppSectionHeader(
                                title: 'Welcome to Parichay',
                                subtitle:
                                    'Sign in with phone/email and OTP to continue your candidate journey.',
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
                                decoration: const InputDecoration(
                                  labelText: 'Phone or Email',
                                  hintText: '+91 98XXXXXX10 or you@email.com',
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
                                  decoration: const InputDecoration(
                                    labelText: 'OTP',
                                    hintText: 'Enter 6-digit OTP',
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
                                    ? 'Verify OTP'
                                    : 'Request OTP',
                                icon: _otpRequested
                                    ? Icons.verified_user_outlined
                                    : Icons.sms_outlined,
                                isLoading: _busy,
                                onPressed: _otpRequested
                                    ? (_canVerifyOtp ? _verifyOtp : null)
                                    : (_canRequestOtp ? _requestOtp : null),
                              ),
                              if (kDebugMode) ...[
                                const SizedBox(height: AppSpacing.sm),
                                const AppStatusChip(
                                  label: 'Debug OTP: 123456',
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
