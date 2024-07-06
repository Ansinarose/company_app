
import 'dart:io';

import 'package:flutter/material.dart';

class ImageFormModel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();

  List<File> _additionalImages = [];
  List<File> get additionalImages => _additionalImages;

  List<String> _selectedColors = [];
  List<String> get selectedColors => _selectedColors;

  String _estimatedCompletion = '';
  String get estimatedCompletion => _estimatedCompletion;

  get formKey => null;

  void addImage(File image) {
    _additionalImages.add(image);
    notifyListeners();
  }

  void removeImage(File image) {
    _additionalImages.remove(image);
    notifyListeners();
  }

  void toggleColor(String color) {
    if (_selectedColors.contains(color)) {
      _selectedColors.remove(color);
    } else {
      _selectedColors.add(color);
    }
    notifyListeners();
  }

  void setEstimatedCompletion(String completion) {
    _estimatedCompletion = completion;
    notifyListeners();
  }

  String get title => titleController.text;
  String get description => descriptionController.text;
  String get price => priceController.text;
  String get overview => overviewController.text;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    overviewController.dispose();
    super.dispose();
  }
}