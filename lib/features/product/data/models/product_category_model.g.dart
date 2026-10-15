// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductCategoryModel _$ProductCategoryModelFromJson(
  Map<String, dynamic> json,
) => _ProductCategoryModel(
  id: json['id'] as String,
  name: json['name'] as String,
  thumbnailUrl: json['thumbnail_url'] as String,
);

Map<String, dynamic> _$ProductCategoryModelToJson(
  _ProductCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'thumbnail_url': instance.thumbnailUrl,
};
