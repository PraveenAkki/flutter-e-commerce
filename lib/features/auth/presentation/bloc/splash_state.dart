import 'package:equatable/equatable.dart';

sealed class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoggedIn extends SplashState {
  const SplashLoggedIn();
}

class SplashGuest extends SplashState {
  const SplashGuest();
}