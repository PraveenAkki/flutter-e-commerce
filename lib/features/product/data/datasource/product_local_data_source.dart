import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_category_model.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductCategoryModel>> getCategories();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AssetBundle _bundle;

  // The bundle is injectable so tests can feed in their own JSON.
  ProductLocalDataSourceImpl({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  @override
  Future<List<ProductModel>> getProducts() async {
    final items = await _readJsonList(AssetPaths.products);
    return items.map(ProductModel.fromJson).toList();
  }

  @override
  Future<List<ProductCategoryModel>> getCategories() async {
    final items = await _readJsonList(AssetPaths.categories);
    return items.map(ProductCategoryModel.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> _readJsonList(String path) async {
    try {
      final raw = await _bundle.loadString(path);
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      throw const CacheException();
    }
  }
}