
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';



class ImageFormScreen extends StatelessWidget {
  final String imageUrl;

  ImageFormScreen({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor, // Use your app's primary color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Consumer<ImageFormModel>(
          builder: (context, model, child) {
            return Form(
              key: model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Add Images from Different Angles',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  _buildAdditionalImagesSection(context, model),
                  SizedBox(height: 16.0),
                  CustomTextFormField(
                    labelText: 'Title',
                    controller: model.titleController,
                    prefixIcon: Icons.title,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
                  ),
                  SizedBox(height: 16.0),
                  CustomTextFormField(
                    labelText: 'Description',
                    controller: model.descriptionController,
                    prefixIcon: Icons.description,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
                  ),
                  SizedBox(height: 16.0),
                  CustomTextFormField(
                    labelText: 'Price',
                    controller: model.priceController,
                    prefixIcon: Icons.attach_money,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a price' : null,
                  ),
                  SizedBox(height: 16.0),
                  CustomTextFormField(
                    labelText: 'Overview',
                    controller: model.overviewController,
                    prefixIcon: Icons.info_outline,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter an overview' : null,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Available Colors',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  _buildColorsSection(context, model),
                  SizedBox(height: 16.0),
                  Text(
                    'Estimated Work Completion',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.0),
                  ElevatedButton(
                    onPressed: () => _showEstimatedCompletionDialog(context, model),
                    child: Text(
                      model.estimatedCompletion.isEmpty
                          ? 'Select Estimated Completion'
                          : model.estimatedCompletion,
                      style: TextStyle(color: AppColors.textPrimaryColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Use your app's primary color
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimaryColor, // Use your app's primary color
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () => _submitForm(context, model),
                    child: Text('SUBMIT',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdditionalImagesSection(BuildContext context, ImageFormModel model) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ...model.additionalImages.map((image) => _buildImageThumbnail(context, image, model)),
        _buildAddImageButton(context, model),
      ],
    );
  }

  Widget _buildImageThumbnail(BuildContext context, File image, ImageFormModel model) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            image,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => model.removeImage(image),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton(BuildContext context, ImageFormModel model) {
    return InkWell(
      onTap: () => _addImage(context, model),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(Icons.add, size: 40),
      ),
    );
  }

  void _addImage(BuildContext context, ImageFormModel model) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      model.addImage(File(image.path));
    }
  }

  Widget _buildColorsSection(BuildContext context, ImageFormModel model) {
    final List<String> availableColors = [
      'White', 'Black', 'Silver', 'Bronze', 'Grey', 'Champagne', 'Brown',
      'Blue', 'Green', 'Red', 'Gold', 'Wood grain finishes', 'Custom RAL colors'
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableColors.map((color) {
        bool isSelected = model.selectedColors.contains(color);
        return FilterChip(
          label: Text(color),
          selected: isSelected,
          onSelected: (_) => model.toggleColor(color),
          backgroundColor: isSelected ? AppColors.textPrimaryColor: null, // Use your app's primary color
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
      }).toList(),
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

  Future<void> _submitForm(BuildContext context, ImageFormModel model) async {
   {
    try {
      // 1. Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImages(model.additionalImages);

      // 2. Create a map of the form data
      Map<String, dynamic> formData = {
        'title': model.titleController.text,
        'description': model.descriptionController.text,
        'price': model.priceController.text,
        'overview': model.overviewController.text,
        'selectedColors': model.selectedColors,
        'estimatedCompletion': model.estimatedCompletion,
        'imageUrls': imageUrls,
      };

      // 3. Add the data to Firestore
      await FirebaseFirestore.instance.collection('categorydetails').add(formData);

      // 4. Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form submitted successfully')));
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors
      print('Error submitting form: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting form')));
    }
  }
}

Future<List<String>> _uploadImages(List<File> images) async {
  List<String> imageUrls = [];
  for (File image in images) {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('category_detailed_image/$fileName');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    imageUrls.add(downloadUrl);
  }
  return imageUrls;
}
}
