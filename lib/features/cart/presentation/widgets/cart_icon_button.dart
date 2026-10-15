import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/login_gate.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../pages/cart_page.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  void _openCart(BuildContext context) {
    LoginGate.runIfLoggedIn(
      context,
          () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CartPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) => IconButton(
        tooltip: AppStrings.cart,
        onPressed: () => _openCart(context),
        icon: Badge(
          isLabelVisible: state.totalItems > 0,
          label: Text('${state.totalItems}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}