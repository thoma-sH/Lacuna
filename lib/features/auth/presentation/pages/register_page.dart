import 'package:first_flutter_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:first_flutter_app/shared/constants/legal_urls.dart';
import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_motion.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:first_flutter_app/shared/utils/url_launch.dart';
import 'package:first_flutter_app/shared/widgets/tap_bounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _showAgreementError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final formOk = _formKey.currentState!.validate();
    if (!_agreedToTerms) {
      setState(() => _showAgreementError = true);
    }
    if (!formOk || !_agreedToTerms) return;
    context.read<AuthCubit>().register(
          _usernameController.text.trim().toLowerCase(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pop();
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          TapBounce(
                            scaleTo: 0.85,
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              child: Icon(
                                PhosphorIconsLight.arrowLeft,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'create account',
                            style: textTheme.headlineSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _AuthField(
                        controller: _usernameController,
                        label: 'username',
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'username is required';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_-]{3,20}$').hasMatch(value)) {
                            return '3–20 chars: letters, numbers, _ or -';
                          }
                          if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                            return 'must contain at least one letter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _AuthField(
                        controller: _passwordController,
                        label: 'password',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _AgreementBlock(
                        checked: _agreedToTerms,
                        showError: _showAgreementError && !_agreedToTerms,
                        onChanged: (v) {
                          setState(() {
                            _agreedToTerms = v;
                            if (v) _showAgreementError = false;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final loading = state is AuthLoading;
                          return _PrimaryButton(
                            label: loading ? 'creating account' : 'create',
                            onTap: loading ? null : _submit,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      autocorrect: false,
      enableSuggestions: !obscureText,
      cursorColor: AppColors.accent,
      style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final disabled = onTap == null;
    return TapBounce(
      scaleTo: 0.96,
      onTap: onTap ?? () {},
      child: AnimatedOpacity(
        duration: AppMotion.short,
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppRadii.md),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGlow,
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.bgBase,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementBlock extends StatelessWidget {
  const _AgreementBlock({
    required this.checked,
    required this.showError,
    required this.onChanged,
  });

  final bool checked;
  final bool showError;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final borderColor = showError
        ? AppColors.downvote
        : (checked ? AppColors.accent : AppColors.borderSubtle);
    return AnimatedContainer(
      duration: AppMotion.short,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: borderColor, width: showError ? 1.2 : 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    value: checked,
                    onChanged: (v) => onChanged(v ?? false),
                    activeColor: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _AgreementText()),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'lacuna has zero tolerance for objectionable content or abusive '
            'users. reports are reviewed within 24 hours.',
            style: t.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          if (showError) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'please agree to continue.',
              style: t.labelSmall?.copyWith(color: AppColors.downvote),
            ),
          ],
        ],
      ),
    );
  }
}

class _AgreementText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final base = t.bodySmall?.copyWith(
      color: AppColors.textSecondary,
      height: 1.4,
    );
    final link = base?.copyWith(
      color: AppColors.accent,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.accent,
    );
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'i agree to the '),
          TextSpan(
            text: 'terms of service',
            style: link,
            recognizer: _tap(
              () => launchExternalUrl(context, LegalUrls.termsOfService),
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'privacy policy',
            style: link,
            recognizer: _tap(
              () => launchExternalUrl(context, LegalUrls.privacyPolicy),
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

TapGestureRecognizer _tap(VoidCallback onTap) =>
    TapGestureRecognizer()..onTap = onTap;
