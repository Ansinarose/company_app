
import 'dart:io';
import 'package:company_application/common/widgets/category_selection.dart';
import 'package:company_application/common/widgets/experience_selection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/features/category/model/category.dart';
import 'package:company_application/features/category/model/worker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerInfo {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<String> categories = [];
  File? image;
}

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({Key? key}) : super(key: key);

  @override
  _CategoryAddScreenState createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  TextEditingController _categoryNameController = TextEditingController();
  File? _categoryImage;
  List<File> _additionalCategoryImages = [];
  List<WorkerInfo> _workers = [WorkerInfo()]; // List to manage multiple workers

  final ImagePicker _picker = ImagePicker();

  void _selectCategoryImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _categoryImage = File(pickedFile.path);
      });
    }
  }

  void _selectAdditionalCategoryImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _additionalCategoryImages.addAll(
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList(),
        );
      });
    }
  }

  void _selectWorkerImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _workers[index].image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImageToStorage(File imageFile, String path) async {
    try {
      String imagePath = '$path/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
      await FirebaseStorage.instance.ref(imagePath).putFile(imageFile);
      String downloadURL = await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  void _submitForm() async {
    if (_categoryNameController.text.isNotEmpty && _categoryImage != null) {
      String mainImageUrl = await _uploadImageToStorage(_categoryImage!, 'categories');
      List<String> additionalImageUrls = [];
      for (File imageFile in _additionalCategoryImages) {
        String imageUrl = await _uploadImageToStorage(imageFile, 'categories');
        additionalImageUrls.add(imageUrl);
      }
      Category newCategory = Category(
        name: _categoryNameController.text,
        mainImageUrl: mainImageUrl,
        additionalImageUrls: additionalImageUrls,
      );

      List<Worker> newWorkers = [];
      for (WorkerInfo workerInfo in _workers) {
        if (workerInfo.nameController.text.isNotEmpty &&
            workerInfo.locationController.text.isNotEmpty &&
            workerInfo.experienceController.text.isNotEmpty &&
            workerInfo.categories.isNotEmpty &&
            workerInfo.image != null) {
          String workerImageUrl = await _uploadImageToStorage(workerInfo.image!, 'workers');
          Worker newWorker = Worker(
            name: workerInfo.nameController.text,
            location: workerInfo.locationController.text,
            experience: workerInfo.experienceController.text,
            categories: workerInfo.categories,
            contact: workerInfo.contactController.text,
            imageUrl: workerImageUrl,
          );
          newWorkers.add(newWorker);
        }
      }

      // Clear form fields and state after submission
      _categoryNameController.clear();
      setState(() {
        _categoryImage = null;
        _additionalCategoryImages.clear();
        _workers = [WorkerInfo()];
      });

      // Save the new category and workers to Firestore
      _saveToFirestore(newCategory: newCategory, newWorkers: newWorkers);
    } else {
      // Show error message or handle invalid input
    }
  }

  void _saveToFirestore({Category? newCategory, List<Worker>? newWorkers}) {
    final companyServices = FirebaseFirestore.instance.collection('Companyservices').doc();

    Map<String, dynamic> data = {};
    if (newCategory != null) {
      data['category'] = {
        'name': newCategory.name,
        'mainImageUrl': newCategory.mainImageUrl,
        'additionalImageUrls': newCategory.additionalImageUrls,
      };
    }
    if (newWorkers != null && newWorkers.isNotEmpty) {
      data['workers'] = newWorkers.map((worker) => {
        'name': worker.name,
        'location': worker.location,
        'experience': worker.experience,
        'categories': worker.categories,
        'contact': worker.contact,
        'imageUrl': worker.imageUrl,
      }).toList();
    }

    companyServices.set(data);
  }

  Widget _buildImagePreview(File? imageFile) {
    return imageFile != null
        ? Image.file(
            imageFile,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
        : Icon(Icons.camera_alt, size: 50, color: Colors.grey);
  }

  Widget _buildAdditionalImagesPreview(List<File> imageFiles) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageFiles.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image.file(
                  imageFiles[index],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _additionalCategoryImages.removeAt(index);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ADD a category and worker',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            CustomTextFormField(
              labelText: 'Category Name',
              controller: _categoryNameController,
              prefixIcon: Icons.category,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Add category image',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: _selectCategoryImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: _buildImagePreview(_categoryImage),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Add multiple category images',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: _selectAdditionalCategoryImages,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: _additionalCategoryImages.isEmpty
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                    : _buildAdditionalImagesPreview(_additionalCategoryImages),
              ),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _workers.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Worker ${index + 1}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    CustomTextFormField(
                      labelText: 'Worker Name',
                      controller: _workers[index].nameController,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the worker\'s name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    CustomTextFormField(
                      labelText: 'Worker Location',
                      controller: _workers[index].locationController,
                      prefixIcon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the worker\'s location';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ExperienceSelectionWidget(
                      controller: _workers[index].experienceController,
                    ),
                    SizedBox(height: 16.0),
                    CustomTextFormField(
                      labelText: 'Worker Contact',
                      controller: _workers[index].contactController,
                      prefixIcon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the worker\'s contact number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    CategorySelectionWidget(
                      controller: TextEditingController(),
                      onSelectedCategories: (categories) {
                        setState(() {
                          _workers[index].categories = categories;
                        });
                      }, selectedCategories: [],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Add worker image',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () => _selectWorkerImage(index),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: _buildImagePreview(_workers[index].image),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                );
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _workers.add(WorkerInfo());
                });
              },
              child: Text(
                'Add More Workers',
                style: TextStyle(color: AppColors.textPrimaryColor),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
