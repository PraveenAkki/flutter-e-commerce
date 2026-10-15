import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;

  ProductBloc({
    required GetProductsUseCase getProducts,
    required GetCategoriesUseCase getCategories,
  })  : _getProducts = getProducts,
        _getCategories = getCategories,
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CategorySelected>(_onCategorySelected);
  }

  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());
    try {
      final (products, categories) =
      await (_getProducts(), _getCategories()).wait;

      if (products.isEmpty) {
        emit(const ProductEmpty());
      } else {
        emit(ProductLoaded(allProducts: products, categories: categories));
      }
    } on Failure catch (failure) {
      emit(ProductError(failure.message));
    }
  }

  void _onCategorySelected(
      CategorySelected event,
      Emitter<ProductState> emit,
      ) {
    final current = state;
    if (current is ProductLoaded) {
      emit(current.withCategory(event.categoryId));
    }
  }
}