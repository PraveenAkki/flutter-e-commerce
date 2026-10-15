import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/session_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/session_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/session_repository.dart';
import '../../features/auth/domain/usecases/check_session_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/bloc/session_bloc.dart';
import '../../features/auth/presentation/bloc/splash_bloc.dart';
import '../../features/product/data/datasource/product_local_data_source.dart';
import '../../features/product/data/repository/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_categories_usecase.dart';
import '../../features/product/domain/usecases/get_products_usecase.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/presentation/bloc/forgot_password_bloc.dart';
import '../../features/auth/presentation/bloc/register_bloc.dart';
import '../../features/watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../features/watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../features/watchlist/domain/repositories/watchlist_repository.dart';
import '../../features/watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import '../../features/watchlist/domain/usecases/clear_watchlist_usecase.dart';
import '../../features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import '../../features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import '../../features/watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/payment/data/datasources/payment_local_data_source.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/process_dummy_payment_usecase.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';


final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initSession();
  _initAuth();
  _initProduct();
  _initWatchlist();
  _initCart();
  _initPayment();
}

void _initSession() {
  sl
    ..registerFactory(() => SplashBloc(checkSession: sl()))

    ..registerLazySingleton(() => SessionBloc(checkSession: sl(), logout: sl()))
    ..registerLazySingleton(() => const FlutterSecureStorage())
    ..registerLazySingleton(() => CheckSessionUseCase(sl()))
    ..registerLazySingleton<SessionRepository>(
          () => SessionRepositoryImpl(sl()),
    )
    ..registerLazySingleton<SessionLocalDataSource>(
          () => SessionLocalDataSourceImpl(sl()),
    );
}

void _initAuth() {
  sl
    ..registerFactory(() => LoginBloc(login: sl()))
    ..registerFactory(() => RegisterBloc(register: sl()))
    ..registerFactory(() => ForgotPasswordBloc(resetPassword: sl()))
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => ResetPasswordUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl(sl()),
    );
}

void _initProduct() {
  sl
    ..registerFactory(
          () => ProductBloc(getProducts: sl(), getCategories: sl()),
    )
    ..registerLazySingleton(() => GetProductsUseCase(sl()))
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    ..registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ProductLocalDataSource>(
          () => ProductLocalDataSourceImpl(),
    );
}

void _initWatchlist() {
  sl

    ..registerLazySingleton(
          () => WatchlistBloc(
        getWatchlist: sl(),
        addToWatchlist: sl(),
        removeFromWatchlist: sl(),
        clearWatchlist: sl(),
      ),
    )
    ..registerLazySingleton(() => GetWatchlistUseCase(sl()))
    ..registerLazySingleton(() => AddToWatchlistUseCase(sl()))
    ..registerLazySingleton(() => RemoveFromWatchlistUseCase(sl()))
    ..registerLazySingleton(() => ClearWatchlistUseCase(sl()))
    ..registerLazySingleton<WatchlistRepository>(
          () => WatchlistRepositoryImpl(sl()),
    )

    ..registerLazySingleton<WatchlistLocalDataSource>(
          () => WatchlistLocalDataSourceImpl(),
    );
}

void _initCart() {
  sl

    ..registerLazySingleton(
          () => CartBloc(
        getCart: sl(),
        addToCart: sl(),
        removeFromCart: sl(),
        updateQuantity: sl(),
        clearCart: sl(),
      ),
    )
    ..registerLazySingleton(() => GetCartUseCase(sl()))
    ..registerLazySingleton(() => AddToCartUseCase(sl()))
    ..registerLazySingleton(() => RemoveFromCartUseCase(sl()))
    ..registerLazySingleton(() => UpdateCartQuantityUseCase(sl()))
    ..registerLazySingleton(() => ClearCartUseCase(sl()))
    ..registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()))

    ..registerLazySingleton<CartLocalDataSource>(
          () => CartLocalDataSourceImpl(),
    );
}

void _initPayment() {
  sl

    ..registerFactory(() => PaymentBloc(processPayment: sl()))
    ..registerLazySingleton(() => ProcessDummyPaymentUseCase(sl()))
    ..registerLazySingleton<PaymentRepository>(
          () => PaymentRepositoryImpl(sl()),
    )
    ..registerLazySingleton<PaymentLocalDataSource>(
          () => PaymentLocalDataSourceImpl(),
    );
}