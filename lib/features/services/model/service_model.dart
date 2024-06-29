
// ignore_for_file: unnecessary_cast

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'service.dart';

class ServiceModel extends ChangeNotifier {
  final TextEditingController serviceController = TextEditingController();
  XFile? _selectedImage;
  List<Service> _services = [];

  XFile? get selectedImage => _selectedImage;
  List<Service> get services => _services;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  ServiceModel() {
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final snapshot = await FirebaseFirestore.instance.collection('Companyservices').get();
    _services = snapshot.docs
        .map((doc) => Service.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    _selectedImage = pickedImage;
    notifyListeners();
  }



  Future<void> submitService(BuildContext context) async {
  if (_selectedImage == null || serviceController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(
        backgroundColor: AppColors.textPrimaryColor,
        content: Text('Please enter a service name and select an image.',style: AppTextStyles.whiteBody(context),)),
    );
    return;
  }

  // Start loading indicator
  _isSubmitting = true;
  notifyListeners();

  String imageUrl = '';
  try {
    final storageRef = FirebaseStorage.instance.ref().child('service_images/${_selectedImage!.name}');
    final uploadTask = storageRef.putFile(File(_selectedImage!.path));
    final taskSnapshot = await uploadTask;
    imageUrl = await taskSnapshot.ref.getDownloadURL();
  } catch (e) {
    print('Error uploading image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
         backgroundColor: AppColors.textPrimaryColor,
        content: Text('Error uploading image. Please try again.',
        style: AppTextStyles.whiteBody(context),
        )),
    );
    // Stop loading indicator on error
    _isSubmitting = false;
    notifyListeners();
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('Companyservices').add({
      'name': serviceController.text,
      'imageUrl': imageUrl,
    });
    serviceController.clear();
    _selectedImage = null;
    notifyListeners();
    Navigator.of(context).pop();
  } catch (e) {
    print('Error adding service: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.textPrimaryColor,
        content: Text('Error adding service. Please try again.',
      style: AppTextStyles.whiteBody(context),)),
    );
  } finally {
    // Stop loading indicator
    _isSubmitting = false;
    notifyListeners();
  }
}


  Future<void> deleteService(String serviceId) async {
    try {
      await FirebaseFirestore.instance.collection('Companyservices').doc(serviceId).delete();
      _services.removeWhere((service) => service.id == serviceId);
      notifyListeners();
    } catch (e) {
      print('Error deleting service: $e');
      throw Exception('Error deleting service. Please try again.');
    }
  }
}
