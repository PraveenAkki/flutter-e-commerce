import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/session_bloc.dart';
import '../../features/auth/presentation/bloc/session_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';


class LoginGate {
  const LoginGate._();

  static Future<void> runIfLoggedIn(
      BuildContext context,
      VoidCallback action,
      ) async {
    final isLoggedIn = context.read<SessionBloc>().state is SessionAuthenticated;
    if (isLoggedIn) {
      action();
      return;
    }

    final didLogin = await openLoginPage(context);
    if (didLogin && context.mounted) action();
  }

  /// Returns true when the user logged in, false when they went back.
  static Future<bool> openLoginPage(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    return result ?? false;
  }
}