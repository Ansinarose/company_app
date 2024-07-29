

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CategoryImageSet {
//   File? categoryImage;
//   List<File> additionalCategoryImages = [];

//   CategoryImageSet({this.categoryImage, List<File>? additionalCategoryImages})
//       : additionalCategoryImages = additionalCategoryImages ?? [];
// }

// class CategoryProvider with ChangeNotifier {
//   String categoryName = '';
//   File? categoryImage;
//   List<File> additionalCategoryImages = [];
//   List<DocumentSnapshot> _categories = [];
//   Stream<List<DocumentSnapshot>>? _categoriesStream;

//   List<DocumentSnapshot> get categories => _categories;

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

//   void fetchCategories(String serviceId) {
//     _categoriesStream = FirebaseFirestore.instance
//         .collection('Companycategory')
//         .where('serviceId', isEqualTo: serviceId)
//         .snapshots()
//         .map((snapshot) => snapshot.docs);

//     _categoriesStream?.listen((List<DocumentSnapshot> documents) {
//       _categories = documents;
//       notifyListeners();
//     });
//   }

//   void addCategory(DocumentSnapshot category) {
//     _categories.add(category);
//     notifyListeners();
//   }


//   Future<void> deleteCategory(String docId) async {
//     await FirebaseFirestore.instance.collection('Companycategory').doc(docId).delete();
//     _categories.removeWhere((doc) => doc.id == docId);
//     notifyListeners();
//   }

//   Future<void> editCategory(String docId, String newName) async {
//     await FirebaseFirestore.instance.collection('Companycategory').doc(docId).update({'name': newName});
//     final index = _categories.indexWhere((doc) => doc.id == docId);
//     if (index != -1) {
//       _categories[index] = await FirebaseFirestore.instance.collection('Companycategory').doc(docId).get();
//     }
//     notifyListeners();
//   }
//   void clearState() {
//   categoryName = '';
//   categoryImage = null;
//   additionalCategoryImages.clear();
//   notifyListeners();
// }
//  bool _isSubmitting = false;
//   bool get isSubmitting => _isSubmitting;

//   void setSubmitting(bool value) {
//     _isSubmitting = value;
//     notifyListeners();
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:flutter/material.dart';

class CategoryImageSet {
  File? categoryImage;
  List<File> additionalCategoryImages = [];

  CategoryImageSet({this.categoryImage, List<File>? additionalCategoryImages})
      : additionalCategoryImages = additionalCategoryImages ?? [];
}

class CategoryProvider with ChangeNotifier {
  String categoryName = '';
  List<CategoryImageSet> categorySets = [CategoryImageSet()];
  //List<File> additionalCategoryImages = [];
  List<DocumentSnapshot> _categories = [];
  Stream<List<DocumentSnapshot>>? _categoriesStream;

  List<DocumentSnapshot> get categories => _categories;

  void setCategoryName(String name) {
    categoryName = name;
    notifyListeners();
  }


  void addCategoryImageSet() {
    categorySets.add(CategoryImageSet());
    notifyListeners();
  }
 
 void setCategoryImage(File image, int index) {
    categorySets[index].categoryImage = image;
    notifyListeners();
  }
  void addAdditionalCategoryImage(File image,int index) {
    categorySets[index].additionalCategoryImages.add(image);
    notifyListeners();
  }

 void removeAdditionalCategoryImage(int setIndex, int imageIndex) {
    if (setIndex >= 0 && setIndex < categorySets.length &&
        imageIndex >= 0 && imageIndex < categorySets[setIndex].additionalCategoryImages.length) {
      categorySets[setIndex].additionalCategoryImages.removeAt(imageIndex);
      notifyListeners();
    }
  }

  void clearCategory() {
    categoryName = '';
    categorySets = [CategoryImageSet()];
  
    notifyListeners();
  }

  void fetchCategories(String serviceId) {
    _categoriesStream = FirebaseFirestore.instance
        .collection('Companycategory')
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    _categoriesStream?.listen((List<DocumentSnapshot> documents) {
      _categories = documents;
      notifyListeners();
    });
  }

  void addCategory(DocumentSnapshot category) {
    _categories.add(category);
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
  void clearState() {
  categoryName = '';
  categorySets = [CategoryImageSet()];
  notifyListeners();
}
 bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  void setSubmitting(bool value) {
    _isSubmitting = value;
    notifyListeners();
  }
  
}

class CategoryFormSet {
  final TextEditingController titleController;
  final TextEditingController descriptionController; // Add this
  final TextEditingController priceController;
  final TextEditingController overviewController;
  final ImageFormModel imageFormModel;

  CategoryFormSet({
    TextEditingController? titleController,
    TextEditingController? descriptionController, // Add this
    TextEditingController? priceController,
    TextEditingController? overviewController,
    ImageFormModel? imageFormModel,
  }) : 
    this.titleController = titleController ?? TextEditingController(),
    this.descriptionController = descriptionController ?? TextEditingController(), // Add this
    this.priceController = priceController ?? TextEditingController(),
    this.overviewController = overviewController ?? TextEditingController(),
    this.imageFormModel = imageFormModel ?? ImageFormModel();

  void dispose() {
    titleController.dispose();
    descriptionController.dispose(); // Add this
    priceController.dispose();
    overviewController.dispose();
  }
}