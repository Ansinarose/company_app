


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/common/widgets/category_selection.dart';
import 'package:company_application/common/widgets/experience_selection.dart';
import 'package:company_application/providers/category_provider.dart';
import 'package:company_application/providers/worker_provider.dart';

class CategoryAddScreen extends StatefulWidget {
  final Service service;

  const CategoryAddScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryNameController;

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).clearState();
      Provider.of<WorkerProvider>(context, listen: false).clearState();
    });
  }
   @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.scaffoldBackgroundcolor,
              appBar: AppBar(
                backgroundColor: AppColors.textPrimaryColor,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Category Details',
                        style: AppTextStyles.heading(context),
                      ),
                      SizedBox(height: 16.0),
                      CustomTextFormField(
  labelText: 'Category Name',
  controller: _categoryNameController,
  prefixIcon: Icons.category,
  onChanged: (value) {
    Provider.of<CategoryProvider>(context, listen: false).setCategoryName(value);
    _formKey.currentState?.validate();
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a category name';
    }
    return null;
  },
),
                      SizedBox(height: 16.0),
                      Text(
                        'Add Category Image',
                        style: AppTextStyles.subheading(context),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: _selectCategoryImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          alignment: Alignment.center,
                          child: _buildImagePreview(categoryProvider.categoryImage),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Add Additional Category Images',
                        style: AppTextStyles.subheading(context),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: _selectAdditionalCategoryImages,
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          alignment: Alignment.center,
                          child: categoryProvider.additionalCategoryImages.isEmpty
                              ? Icon(Icons.camera_alt, size: 50, color: AppColors.textPrimaryColor)
                              : _buildAdditionalImagesPreview(categoryProvider.additionalCategoryImages),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Workers Details',
                        style: AppTextStyles.heading(context),
                      ),
                      SizedBox(height: 16.0),
                      Consumer<WorkerProvider>(
                        builder: (context, workerProvider, _) => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: workerProvider.workers.length,
                          itemBuilder: (context, index) {
                            return _buildWorkerForm(workerProvider, index);
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Provider.of<WorkerProvider>(context, listen: false).addWorker();
                        },
                        child: Text(
                          '+ Add More Workers',
                          style: TextStyle(color: AppColors.textPrimaryColor),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          return TextButton(
                            style: AppButtonStyles.largeButton(context),
                            onPressed: categoryProvider.isSubmitting ? null : _submitData,
                            child: categoryProvider.isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('SUBMIT'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (categoryProvider.isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWorkerForm(WorkerProvider workerProvider, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Worker ${index + 1}',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Name',
          controller: workerProvider.workers[index].nameController,
          prefixIcon: Icons.person,
          onChanged: (value) {
            workerProvider.workers[index].nameController.text = value;
            _formKey.currentState?.validate();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Location',
          controller: workerProvider.workers[index].locationController,
          prefixIcon: Icons.location_on,
          onChanged: (value) {
            workerProvider.workers[index].locationController.text = value;
            _formKey.currentState?.validate();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a location';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),
        ExperienceSelectionWidget(
          controller: workerProvider.workers[index].experienceController,
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Contact',
          controller: workerProvider.workers[index].contactController,
          prefixIcon: Icons.phone,
          onChanged: (value) {
            workerProvider.workers[index].contactController.text = value;
            _formKey.currentState?.validate();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a contact number';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),
        CategorySelectionWidget(
          controller: TextEditingController(),
          onSelectedCategories: (categories) {
            workerProvider.updateWorkerCategories(index, categories);
          },
          selectedCategories: workerProvider.workers[index].categories,
        ),
        SizedBox(height: 16.0),
        Text(
          'Add Worker Image',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _selectWorkerImage(index),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            alignment: Alignment.center,
            child: _buildImagePreview(workerProvider.workers[index].image),
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildImagePreview(File? imageFile) {
    return imageFile != null
        ? Image.file(
            imageFile,
            width: 180,
            height: 180,
            fit: BoxFit.cover,
          )
        : Icon(Icons.camera_alt, size: 50, color: AppColors.textPrimaryColor);
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
                    Provider.of<CategoryProvider>(context, listen: false).removeAdditionalCategoryImage(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cancel,
                      color: AppColors.textPrimaryColor,
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

  void _selectCategoryImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<CategoryProvider>(context, listen: false).setCategoryImage(File(pickedFile.path));
    }
  }

  void _selectAdditionalCategoryImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (XFile pickedFile in pickedFiles) {
        Provider.of<CategoryProvider>(context, listen: false).addAdditionalCategoryImage(File(pickedFile.path));
      }
    }
  }

  void _selectWorkerImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<WorkerProvider>(context, listen: false).updateWorkerImage(index, File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(File imageFile, String path) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final workerProvider = Provider.of<WorkerProvider>(context, listen: false);

      categoryProvider.setSubmitting(true);

      try {
        // Upload category image
        String categoryImageUrl = '';
        if (categoryProvider.categoryImage != null) {
          categoryImageUrl = await _uploadImage(categoryProvider.categoryImage!, 'categories/${DateTime.now().millisecondsSinceEpoch}.jpg');
        }

        // Upload additional category images
        List<String> additionalCategoryImagesUrls = [];
        for (File image in categoryProvider.additionalCategoryImages) {
          String imageUrl = await _uploadImage(image, 'categories/${DateTime.now().millisecondsSinceEpoch}.jpg');
          additionalCategoryImagesUrls.add(imageUrl);
        }

        // Store category details in Firestore
        DocumentReference categoryDoc = await FirebaseFirestore.instance.collection('Companycategory').add({
         // 'name': categoryProvider.categoryName,
           'name': _categoryNameController.text,       
          'imageUrl': categoryImageUrl,
          'additionalImages': additionalCategoryImagesUrls,
          'serviceId': widget.service.id,
        });

        // Store worker details in Firestore
        for (var worker in workerProvider.workers) {
          String workerImageUrl = '';
          if (worker.image != null) {
            workerImageUrl = await _uploadImage(worker.image!, 'workers/${DateTime.now().millisecondsSinceEpoch}.jpg');
          }

          await categoryDoc.collection('workers').add({
            'name': worker.nameController.text,
            'location': worker.locationController.text,
            'experience': worker.experienceController.text,
            'contact': worker.contactController.text,
            'categories': worker.categories,
            'imageUrl': workerImageUrl,
            'categoryId': categoryDoc.id,
          });
        }
        
        // Fetch the new category document and update the local state
        DocumentSnapshot newCategory = await categoryDoc.get();
        Provider.of<CategoryProvider>(context, listen: false).addCategory(newCategory);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data successfully saved.')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data: $e')),
        );
      } finally {
        categoryProvider.setSubmitting(false);
      }
    }
  }
}