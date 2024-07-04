
// import 'dart:io';

// import 'package:flutter/material.dart';

// class CategoryProvider with ChangeNotifier {
//   String categoryName = '';
//   File? categoryImage;
//   List<File> additionalCategoryImages = [];

//   void setCategoryName(String name) {
//     categoryName = name;
//     notifyListeners();
//   }

//   void setCategoryImage(File image) {
//     categoryImage = image;
//     notifyListeners();
//   }

//   void addAdditionalCategoryImage(File image) {
//     additionalCategoryImages.add(image);
//     notifyListeners();
//   }

//   void removeAdditionalCategoryImage(int index) {
//     if (index >= 0 && index < additionalCategoryImages.length) {
//       additionalCategoryImages.removeAt(index);
//       notifyListeners();
//     }
//   }

//   void clearCategory() {
//     categoryName = '';
//     categoryImage = null;
//     additionalCategoryImages.clear();
//     notifyListeners();
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String categoryName = '';
  File? categoryImage;
  List<File> additionalCategoryImages = [];
  List<DocumentSnapshot> _categories = [];

  List<DocumentSnapshot> get categories => _categories;

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

  Future<void> fetchCategories(String serviceId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Companycategory')
        .where('serviceId', isEqualTo: serviceId)
        .get();

    _categories = querySnapshot.docs;
    notifyListeners();
  }

  Future<void> deleteCategory(String docId) async {
    await FirebaseFirestore.instance.collection('Companycategory').doc(docId).delete();
    _categories.removeWhere((doc) => doc.id == docId);
    notifyListeners();
  }

  Future<void> editCategory(String docId, String newName) async {
    await FirebaseFirestore.instance.collection('Companycategory').doc(docId).update({'name': newName});
    final index = _categories.indexWhere((doc) => doc.id == docId);
    if (index != -1) {
      _categories[index] = await FirebaseFirestore.instance.collection('Companycategory').doc(docId).get();
    }
    notifyListeners();
  }
}
