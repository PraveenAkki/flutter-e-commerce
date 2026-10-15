import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'config/di/injection_container.dart';
import 'config/routes/app_navigator.dart';
import 'config/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/utils/app_feedback.dart';
import 'features/auth/presentation/bloc/session_bloc.dart';
import 'features/auth/presentation/bloc/session_event.dart';
import 'features/auth/presentation/bloc/session_state.dart';
import 'features/auth/presentation/pages/splash_page.dart';

import 'features/product/presentation/page/product_list_page.dart';
import 'features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'features/watchlist/presentation/bloc/watchlist_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  void _goToProductListAfterLogout() {
    AppFeedback.toast(AppStrings.loggedOut);
    appNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ProductListPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Session and watchlist live above MaterialApp so every screen shares them.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SessionBloc>()..add(const SessionChecked())),
        BlocProvider.value(value: sl<WatchlistBloc>()..add(const LoadWatchlist())),
        BlocProvider.value(value: sl<CartBloc>()..add(const LoadCart())),
      ],
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashPage(),
        builder: (context, child) => BlocListener<SessionBloc, SessionState>(
          listenWhen: (previous, current) =>
          previous is SessionAuthenticated && current is SessionGuest,
          listener: (context, _) {
            context.read<WatchlistBloc>().add(const ClearWatchlist());
            context.read<CartBloc>().add(const ClearCart());
            _goToProductListAfterLogout();
          },
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}