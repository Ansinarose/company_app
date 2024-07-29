import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/widgets/categoryformset_widget.dart';
import 'package:company_application/common/widgets/workerform_widget.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:company_application/providers/category_provider.dart';
import 'package:company_application/providers/worker_provider.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';

class CategoryAddItemScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryAddItemScreen({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  State<CategoryAddItemScreen> createState() => _CategoryAddItemScreenState();
}

class _CategoryAddItemScreenState extends State<CategoryAddItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CategoryFormSet> categoryFormSets = [];

  @override
  void initState() {
    super.initState();
    categoryFormSets.add(CategoryFormSet());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).clearState();
      Provider.of<WorkerProvider>(context, listen: false).clearState();
    });
  }

  @override
  void dispose() {
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
                  title: Text('Add Item to ${widget.categoryName}'),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Item Details',
                          style: AppTextStyles.heading(context),
                        ),
                        SizedBox(height: 16.0),
                        ...categoryFormSets.asMap().entries.map((entry) {
                          int index = entry.key;
                          CategoryFormSet formSet = entry.value;
                          return CategoryFormSetWidget(
                            index: index,
                            formSet: formSet,
                            categoryProvider: categoryProvider,
                          );
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
                            '+ADD more item images',
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
                              return WorkerFormWidget(
                                index: index,
                                workerProvider: workerProvider,
                              );
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
          ),
        );
      },
    );
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final workerProvider = Provider.of<WorkerProvider>(context, listen: false);
      categoryProvider.setSubmitting(true);

      try {
        List<Map<String, dynamic>> itemData = [];

        for (int i = 0; i < categoryFormSets.length; i++) {
          CategoryFormSet formSet = categoryFormSets[i];
          CategoryImageSet imageSet = categoryProvider.categorySets[i];
          ImageFormModel model = formSet.imageFormModel;
          
          String productId = FirebaseFirestore.instance.collection('products').doc().id;

          String itemImageUrl = '';
          if (imageSet.categoryImage != null) {
            itemImageUrl = await _uploadImage(imageSet.categoryImage!, 'items/${DateTime.now().millisecondsSinceEpoch}.jpg');
          }

          List<String> additionalItemImagesUrls = [];
          for (File image in imageSet.additionalCategoryImages) {
            String imageUrl = await _uploadImage(image, 'items/${DateTime.now().millisecondsSinceEpoch}.jpg');
            additionalItemImagesUrls.add(imageUrl);
          }

          itemData.add({
            'productId': productId,
            'title': formSet.titleController.text,
            'description': formSet.descriptionController.text,
            'price': formSet.priceController.text,
            'overview': formSet.overviewController.text,
            'colors': model.selectedColors,
            'estimatedCompletion': formSet.imageFormModel.estimatedCompletion,
            'imageUrl': itemImageUrl,
            'additionalImages': additionalItemImagesUrls,
          });
        }

        // Store item details in Firestore
        DocumentReference itemDoc = await FirebaseFirestore.instance
            .collection('Companycategory')
            .doc(widget.categoryId)
            .collection('items')
            .add({
          'itemData': itemData,
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

        // Add worker data to the item document
        await itemDoc.update({
          'workers': workerData,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item successfully added to category.')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add item: $e')),
        );
      } finally {
        categoryProvider.setSubmitting(false);
      }
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
}