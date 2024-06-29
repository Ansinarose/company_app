import 'package:company_application/features/category/model/category.dart';
import 'package:company_application/features/category/model/worker.dart';
import 'package:flutter/material.dart';


class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.add(category);
    // Implement Firestore update here
    notifyListeners();
  }
}

class WorkerProvider extends ChangeNotifier {
  List<Worker> _workers = [];

  List<Worker> get workers => _workers;

  void addWorker(Worker worker) {
    _workers.add(worker);
    // Implement Firestore update here
    notifyListeners();
  }
}
