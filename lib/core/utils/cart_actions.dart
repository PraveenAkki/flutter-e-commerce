import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/bloc/cart_event.dart';
import '../../features/product/domain/entities/product.dart';
import '../constants/app_strings.dart';
import 'app_feedback.dart';
import 'login_gate.dart';

class CartActions {
  const CartActions._();


  static void addProduct(BuildContext context, Product product) {
    LoginGate.runIfLoggedIn(context, () {
      context.read<CartBloc>().add(AddToCart(product));
      AppFeedback.toast(AppStrings.addedToCart);
    });
  }
}