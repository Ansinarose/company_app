import 'dart:io';

import 'package:company_application/common/widgets/colorselection_widget.dart';
import 'package:company_application/common/widgets/estimatedCompletion_widget.dart';
import 'package:company_application/common/widgets/imagepreview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:company_application/providers/category_provider.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';

import 'package:image_picker/image_picker.dart';

class CategoryFormSetWidget extends StatelessWidget {
  final int index;
  final CategoryFormSet formSet;
  final CategoryProvider categoryProvider;

  const CategoryFormSetWidget({
    Key? key,
    required this.index,
    required this.formSet,
    required this.categoryProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: formSet.imageFormModel,
      child: Consumer<ImageFormModel>(
        builder: (context, model, _) {
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
                onTap: () => _selectCategoryImage(context),
                child: ImagePreviewWidget(
                  imageFile: categoryProvider.categorySets[index].categoryImage,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Add Images from Different Angles',
                style: AppTextStyles.subheading(context),
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: () => _selectAdditionalCategoryImages(context),
                child: ImagePreviewWidget(
                  imageFiles: categoryProvider.categorySets[index].additionalCategoryImages,
                  onRemove: (i) => categoryProvider.removeAdditionalCategoryImage(index, i),
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
                labelText: 'Material Price for Sq.ft',
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
              ColorSelectionWidget(model: model),
              Text(
                'Estimated Work Completion',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15.0),
              EstimatedCompletionWidget(model: model),
              SizedBox(height: 32.0),
            ],
          );
        },
      ),
    );
  }

  void _selectCategoryImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      categoryProvider.setCategoryImage(File(pickedFile.path), index);
    }
  }

  void _selectAdditionalCategoryImages(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (XFile pickedFile in pickedFiles) {
        categoryProvider.addAdditionalCategoryImage(File(pickedFile.path), index);
      }
    }
  }
}