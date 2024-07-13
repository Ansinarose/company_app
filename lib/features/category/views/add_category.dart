import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
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
  List<CategoryFormSet> categoryFormSets = [];

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();
    categoryFormSets.add(CategoryFormSet());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).clearState();
      Provider.of<WorkerProvider>(context, listen: false).clearState();
    });
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    for (var formSet in categoryFormSets) {
      formSet.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return ChangeNotifierProvider(
          create: (_) => categoryFormSets[0].imageFormModel,
          child: Stack(
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
                            categoryProvider.setCategoryName(value);
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
                        ...categoryFormSets.asMap().entries.map((entry) {
                          int index = entry.key;
                          CategoryFormSet formSet = entry.value;
                          return _buildCategoryFormSet(categoryProvider, index, formSet);
                        }).toList(),
                        SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              categoryFormSets.add(CategoryFormSet());
                              categoryProvider.addCategoryImageSet();
                            });
                          },
                          child: Text(
                            '+ADD more category images',
                            style: AppTextStyles.body(context),
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
                              onPressed: categoryProvider.isSubmitting ? null : 
                              _submitData,
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
          ),
        );
      },
    );
  }

  Widget _buildCategoryFormSet(CategoryProvider categoryProvider, int index, CategoryFormSet formSet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Category Image Set ${index + 1}',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 16.0),
        Text(
          'Add Category Image',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _selectCategoryImage(index),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            alignment: Alignment.center,
            child: _buildImagePreview(categoryProvider.categorySets[index].categoryImage),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          'Add Images from Different Angles',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _selectAdditionalCategoryImages(index),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            alignment: Alignment.center,
            child: categoryProvider.categorySets[index].additionalCategoryImages.isEmpty
                ? Icon(Icons.camera_alt, size: 50, color: AppColors.textPrimaryColor)
                : _buildAdditionalImagesPreview(categoryProvider.categorySets[index].additionalCategoryImages, index),
          ),
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Title',
          controller: formSet.titleController,
          prefixIcon: Icons.title,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Description',
          controller: formSet.descriptionController,
          prefixIcon: Icons.description,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Price',
          controller: formSet.priceController,
          prefixIcon: Icons.attach_money,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter a price' : null,
        ),
        SizedBox(height: 16.0),
        CustomTextFormField(
          labelText: 'Overview',
          controller: formSet.overviewController,
          prefixIcon: Icons.info_outline,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter an overview' : null,
        ),
        SizedBox(height: 16.0),
        Text(
          'Available Colors',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 16.0),
        _buildColorsSection(context, formSet.imageFormModel),
        Text(
          'Estimated Work Completion',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.0),
        ElevatedButton(
          onPressed: () => _showEstimatedCompletionDialog(context, formSet.imageFormModel),
          child: Text(
            formSet.imageFormModel.estimatedCompletion.isEmpty
                ? 'Select Estimated Completion'
                : formSet.imageFormModel.estimatedCompletion,
            style: TextStyle(color: AppColors.textPrimaryColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 32.0),
      ],
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
  selectedCategories: workerProvider.workers[index].categories,
  onSelectedCategories: (categories) {
    workerProvider.updateWorkerCategories(index, categories);
  },
),
        SizedBox(height: 16.0),
        Text(
          'Add Worker Image',
          style: AppTextStyles.subheading(context),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => 
          _selectWorkerImage(index),
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
void _selectAdditionalCategoryImages(int index) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (XFile pickedFile in pickedFiles) {
        Provider.of<CategoryProvider>(context, listen: false).addAdditionalCategoryImage(File(pickedFile.path), index);
      }
    }
  }
  Widget _buildAdditionalImagesPreview(List<File> imageFiles, int setIndex) {
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
                    Provider.of<CategoryProvider>(context, listen: false).removeAdditionalCategoryImage(setIndex, index);
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

  void _selectCategoryImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<CategoryProvider>(context, listen: false).setCategoryImage(File(pickedFile.path), index);
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
      List<Map<String, dynamic>> categoryData = [];

      for (int i = 0; i < categoryFormSets.length; i++) {
        CategoryFormSet formSet = categoryFormSets[i];
        CategoryImageSet imageSet = categoryProvider.categorySets[i];

        String categoryImageUrl = '';
        if (imageSet.categoryImage != null) {
          categoryImageUrl = await _uploadImage(imageSet.categoryImage!, 'categories/${DateTime.now().millisecondsSinceEpoch}.jpg');
        }

        List<String> additionalCategoryImagesUrls = [];
        for (File image in imageSet.additionalCategoryImages) {
          String imageUrl = await _uploadImage(image, 'categories/${DateTime.now().millisecondsSinceEpoch}.jpg');
          additionalCategoryImagesUrls.add(imageUrl);
        }

        categoryData.add({
          'title': formSet.titleController.text,
          'description': formSet.descriptionController.text,
          'price': formSet.priceController.text,
          'overview': formSet.overviewController.text,
          'colors': formSet.imageFormModel.selectedColors,
          'estimatedCompletion': formSet.imageFormModel.estimatedCompletion,
          'imageUrl': categoryImageUrl,
          'additionalImages': additionalCategoryImagesUrls,
        });
      }

      // Store category details in Firestore
      DocumentReference categoryDoc = await FirebaseFirestore.instance.collection('Companycategory').add({
        'name': _categoryNameController.text,
        'categoryData': categoryData,
        'serviceId': widget.service.id,
      });

      // Store worker details in Firestore
      List<Map<String, dynamic>> workerData = [];
      for (var worker in workerProvider.workers) {
        String workerImageUrl = '';
        if (worker.image != null) {
          workerImageUrl = await _uploadImage(worker.image!, 'workers/${DateTime.now().millisecondsSinceEpoch}.jpg');
        }

        workerData.add({
          'name': worker.nameController.text,
          'location': worker.locationController.text,
          'experience': worker.experienceController.text,
          'contact': worker.contactController.text,
          'categories': worker.categories,
          'imageUrl': workerImageUrl,
        });
      }

      // Add worker data to the category document
      await categoryDoc.update({
        'workers': workerData,
      });

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
   Widget _buildColorsSection(BuildContext context, ImageFormModel imageFormModel) {
  final List<String> availableColors = [
    'White', 'Black', 'Silver', 'Bronze', 'Grey', 'Champagne', 'Brown',
    'Blue', 'Green', 'Red', 'Gold', 'Wood grain finishes', 'Custom RAL colors'
  ];

  return Consumer<ImageFormModel>(
    builder: (context, model, child) {
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: availableColors.map((color) {
          bool isSelected = model.selectedColors.contains(color);
          return FilterChip(
            label: Text(color),
            selected: isSelected,
            onSelected: (_) => model.toggleColor(color),
            backgroundColor: isSelected ? AppColors.textPrimaryColor : null,
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          );
        }).toList(),
      );
    },
  );
}
 void _showEstimatedCompletionDialog(BuildContext context, ImageFormModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Estimated Completion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEstimationOption(context, 'Upto 10 days', model),
              _buildEstimationOption(context, 'In between 10-20 days', model),
              _buildEstimationOption(context, 'Approximately 1 month', model),
              _buildEstimationOption(context, 'More than 1 month', model),
            ],
          ),
        );
      },
    );
  }
Widget _buildEstimationOption(BuildContext context, String option, ImageFormModel model) {
    return ListTile(
      title: Text(option),
      onTap: () {
        model.setEstimatedCompletion(option);
        Navigator.of(context).pop();
      },
    );
  }
   void _selectWorkerImage(int index) async {
   final ImagePicker _picker = ImagePicker();
   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
   if (pickedFile != null) {
     Provider.of<WorkerProvider>(context, listen: false).updateWorkerImage(index, File(pickedFile.path));
   }
 }
  }
