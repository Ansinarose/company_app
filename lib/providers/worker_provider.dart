
import 'dart:io';

import 'package:company_application/features/category/model/worker_info.dart';
import 'package:flutter/material.dart';

class WorkerProvider with ChangeNotifier {
  List<WorkerInfo> workers = [WorkerInfo()];

  void addWorker() {
    workers.add(WorkerInfo());
    notifyListeners();
  }

  void updateWorkerImage(int index, File image) {
    if (index >= 0 && index < workers.length) {
      workers[index].image = image;
      notifyListeners();
    }
  }

  void updateWorkerCategories(int index, List<String> categories) {
    if (index >= 0 && index < workers.length) {
      workers[index].categories = categories;
      notifyListeners();
    }
  }

  void clearWorkers() {
    workers = [WorkerInfo()];
    notifyListeners();
  }
  void clearState() {
  workers.clear();
  addWorker(); // Add one empty worker
  notifyListeners();
}
}
