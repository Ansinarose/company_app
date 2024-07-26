import 'package:flutter/material.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:company_application/common/constants/app_colors.dart';

class ColorSelectionWidget extends StatelessWidget {
  final ImageFormModel model;

  const ColorSelectionWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> availableColors = [
      'White', 'Black', 'Silver', 'Bronze', 'Grey', 'Champagne', 'Brown',
      'Blue', 'Green', 'Red', 'Gold', 'Wood grain finishes', 'Custom RAL colors'
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableColors.map((color) {
        bool isSelected = model.selectedColors.contains(color);
        return FilterChip(
          label: Text(color),
          selected: isSelected,
          onSelected: (_) => model.toggleColor(color),
          backgroundColor: isSelected ? AppColors.textPrimaryColor : null,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
      }).toList(),
    );
  }
}