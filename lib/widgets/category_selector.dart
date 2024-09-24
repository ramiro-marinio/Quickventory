import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory/models/asset.dart';

class CategorySelector extends StatelessWidget {
  final Category? initialCategory;
  const CategorySelector(
      {super.key, required this.onChange, this.initialCategory});
  final Function(AssetCategory newCat) onChange;
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: initialCategory ?? AssetCategory.others,
      dropdownMenuEntries: [
        ...AssetCategory.values.map(
          (category) {
            return DropdownMenuEntry(
              value: category,
              label: category.displayName,
            );
          },
        )
      ],
    );
  }
}
