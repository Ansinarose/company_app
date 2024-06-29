
import 'dart:io';

import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String categoryName = '';
  File? categoryImage;
  List<File> additionalCategoryImages = [];

  void setCategoryName(String name) {
    categoryName = name;
    notifyListeners();
  }

  void setCategoryImage(File image) {
    categoryImage = image;
    notifyListeners();
  }

  void addAdditionalCategoryImage(File image) {
    additionalCategoryImages.add(image);
    notifyListeners();
  }

  void removeAdditionalCategoryImage(int index) {
    if (index >= 0 && index < additionalCategoryImages.length) {
      additionalCategoryImages.removeAt(index);
      notifyListeners();
    }
  }

  void clearCategory() {
    categoryName = '';
    categoryImage = null;
    additionalCategoryImages.clear();
    notifyListeners();
  }
}
