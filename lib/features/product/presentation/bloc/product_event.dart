import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class CategorySelected extends ProductEvent {
  final String? categoryId;
  const CategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}