import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import '../../../../config/di/injection_container.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/test_credentials.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../../../core/widgets/password_text_field.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';

/// Pops with `true` when the user logs in, so the caller can continue
/// whatever the guest was trying to do.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  void _onLoginStateChanged(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.success) {
      context.read<SessionBloc>().add(const UserLoggedIn());
      Navigator.of(context).pop(true);
    } else if (state.status == LoginStatus.failure) {
      AppFeedback.error(context, state.failureMessage ?? AppStrings.genericError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onLoginStateChanged,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.welcomeBack,
                        style: textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(AppStrings.loginSubtitle, style: textTheme.bodyLarge),
                    const SizedBox(height: 28),
                    const _LoginForm(),
                    const SizedBox(height: 8),
                    const _AuthLinks(),
                    const SizedBox(height: 16),
                    const _TestCredentialsHint(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => Column(
        children: [
          TextField(
            enabled: !state.isSubmitting,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) => bloc.add(LoginEmailChanged(value)),
            decoration: InputDecoration(
              labelText: AppStrings.emailLabel,
              errorText: state.emailError,
              prefixIcon: const Icon(Icons.mail_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            enabled: !state.isSubmitting,
            errorText: state.passwordError,
            onChanged: (value) => bloc.add(LoginPasswordChanged(value)),
            onSubmitted: () => bloc.add(const LoginSubmitted()),
          ),
          const SizedBox(height: 24),
          LoadingButton(
            label: AppStrings.login,
            isLoading: state.isSubmitting,
            onPressed:
            state.canSubmit ? () => bloc.add(const LoginSubmitted()) : null,
          ),
        ],
      ),
    );
  }
}

class _TestCredentialsHint extends StatelessWidget {
  const _TestCredentialsHint();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.testLoginTitle,
              style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          SelectableText('Email: ${TestCredentials.email}'),
          SelectableText('Password: ${TestCredentials.password}'),
        ],
      ),
    );
  }
}


class _AuthLinks extends StatelessWidget {
  const _AuthLinks();

  void _openForgotPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
    );
  }

  Future<void> _openRegister(BuildContext context) async {
    final didRegister = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );

    // A new account is already logged in, so close the login page too.
    if (didRegister == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => _openForgotPassword(context),
          child: const Text(AppStrings.forgotPassword),
        ),
        TextButton(
          onPressed: () => _openRegister(context),
          child: const Text(AppStrings.createAccount),
        ),
      ],
    );
  }
}