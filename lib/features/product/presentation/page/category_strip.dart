import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/product_category.dart';

class CategoryStrip extends StatelessWidget {
  final List<ProductCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  const CategoryStrip({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _CategoryItem(
            label: AppStrings.allCategories,
            isSelected: selectedCategoryId == null,
            onTap: () => onSelected(null),
            child: const Icon(Icons.grid_view_rounded),
          ),
          for (final category in categories)
            _CategoryItem(
              label: category.name,
              isSelected: selectedCategoryId == category.id,
              onTap: () => onSelected(category.id),
              child: CachedNetworkImage(
                imageUrl: category.thumbnailUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.checkroom),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _CategoryItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceContainerHighest,
                border: Border.all(
                  color: isSelected ? colors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: child,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}