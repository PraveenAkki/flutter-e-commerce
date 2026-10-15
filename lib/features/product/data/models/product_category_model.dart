import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_category.dart';

part 'product_category_model.freezed.dart';
part 'product_category_model.g.dart';

@freezed
abstract class ProductCategoryModel with _$ProductCategoryModel {
  const ProductCategoryModel._();

  const factory ProductCategoryModel({
    required String id,
    required String name,
    @JsonKey(name: 'thumbnail_url') required String thumbnailUrl,
  }) = _ProductCategoryModel;

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryModelFromJson(json);

  ProductCategory toEntity() =>
      ProductCategory(id: id, name: name, thumbnailUrl: thumbnailUrl);
}