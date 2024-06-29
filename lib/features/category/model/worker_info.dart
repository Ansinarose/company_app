import 'dart:io';

import 'package:flutter/material.dart';

class WorkerInfo {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<String> categories = [];
  File? image;
}