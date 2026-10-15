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
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';

/// Pops with `true` after a successful registration (the user is logged in).
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<RegisterBloc>().add(RegisterSubmitted(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }

  void _onStateChanged(BuildContext context, RegisterState state) {
    if (state.status == SubmitStatus.success) {
      context.read<SessionBloc>().add(const UserLoggedIn());
      Navigator.of(context).pop(true);
    } else if (state.status == SubmitStatus.failure) {
      AppFeedback.error(context, state.failureMessage ?? AppStrings.genericError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RegisterBloc, RegisterState>(
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
                      Text(AppStrings.createAccount,
                          style: textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(AppStrings.registerSubtitle, style: textTheme.bodyLarge),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _nameController,
                        enabled: !state.isSubmitting,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            RegisterValidator.validateName(value ?? ''),
                        decoration: const InputDecoration(
                          labelText: AppStrings.nameLabel,
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                        controller: _passwordController,
                        label: AppStrings.passwordLabel,
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
                          _passwordController.text,
                          value ?? '',
                        ),
                      ),
                      const SizedBox(height: 24),
                      LoadingButton(
                        label: AppStrings.register,
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