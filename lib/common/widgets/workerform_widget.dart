import 'dart:io';

import 'package:company_application/common/widgets/imagepreview_widget.dart';
import 'package:flutter/material.dart';
import 'package:company_application/providers/worker_provider.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/common/widgets/experience_selection.dart';
import 'package:company_application/common/widgets/category_selection.dart';

import 'package:image_picker/image_picker.dart';

class WorkerFormWidget extends StatelessWidget {
  final int index;
  final WorkerProvider workerProvider;

  const WorkerFormWidget({
    Key? key,
    required this.index,
    required this.workerProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onTap: () => _selectWorkerImage(context),
          child: ImagePreviewWidget(
            imageFile: workerProvider.workers[index].image,
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  void _selectWorkerImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      workerProvider.updateWorkerImage(index, File(pickedFile.path));
    }
  }
}