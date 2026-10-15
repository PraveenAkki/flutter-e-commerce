import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/injection_container.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/password_form_field.dart';
import '../../../../core/utils/submit_status.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../domain/validators/login_validator.dart';
import '../../domain/validators/register_validator.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordBloc>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordBloc>().add(ResetPasswordSubmitted(
      email: _emailController.text,
      newPassword: _newPasswordController.text,
    ));
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.status == SubmitStatus.success) {
      AppFeedback.toast(AppStrings.passwordUpdated);
      Navigator.of(context).pop();
    } else if (state.status == SubmitStatus.failure) {
      AppFeedback.error(context, state.failureMessage ?? AppStrings.genericError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onStateChanged,
        builder: (context, state) => SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.resetPassword,
                          style: textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(AppStrings.resetPasswordSubtitle,
                          style: textTheme.bodyLarge),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _emailController,
                        enabled: !state.isSubmitting,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            LoginValidator.validateEmail(value ?? ''),
                        decoration: const InputDecoration(
                          labelText: AppStrings.emailLabel,
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PasswordFormField(
                        controller: _newPasswordController,
                        label: AppStrings.newPasswordLabel,
                        enabled: !state.isSubmitting,
                        validator: (value) =>
                            LoginValidator.validatePassword(value ?? ''),
                      ),
                      const SizedBox(height: 16),
                      PasswordFormField(
                        controller: _confirmPasswordController,
                        label: AppStrings.confirmPasswordLabel,
                        enabled: !state.isSubmitting,
                        validator: (value) => RegisterValidator.validateConfirmPassword(
                          _newPasswordController.text,
                          value ?? '',
                        ),
                      ),
                      const SizedBox(height: 24),
                      LoadingButton(
                        label: AppStrings.resetPassword,
                        isLoading: state.isSubmitting,
                        onPressed: _submit,
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