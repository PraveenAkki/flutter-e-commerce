import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_category.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> allProducts;
  final List<ProductCategory> categories;
  final String? selectedCategoryId;

  const ProductLoaded({
    required this.allProducts,
    required this.categories,
    this.selectedCategoryId,
  });

  List<Product> get visibleProducts => selectedCategoryId == null
      ? allProducts
      : allProducts.where((p) => p.category == selectedCategoryId).toList();

  ProductLoaded withCategory(String? categoryId) => ProductLoaded(
    allProducts: allProducts,
    categories: categories,
    selectedCategoryId: categoryId,
  );

  @override
  List<Object?> get props => [allProducts, categories, selectedCategoryId];
}

class ProductEmpty extends ProductState {
  const ProductEmpty();
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}