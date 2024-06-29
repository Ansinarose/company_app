import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/textform_field.dart';
import 'package:company_application/common/widgets/curved_appbar.dart';


class AddServicePage extends StatefulWidget {
  final Function(String, String) onAddService;

  AddServicePage({required this.onAddService});

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController _serviceController = TextEditingController();
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _submitService() async {
    if (_selectedImage == null || _serviceController.text.isEmpty) {
      // Show an error or handle the invalid state
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a service name and select an image.')),
      );
      return;
    }

    // Upload image to Firebase Storage
    String imageUrl = '';
    try {
      final storageRef = FirebaseStorage.instance.ref().child('service_images/${_selectedImage!.name}');
      final uploadTask = storageRef.putFile(File(_selectedImage!.path));
      final taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      // Handle image upload error
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image. Please try again.')),
      );

      return;
    }

    // Store service details in Firestore
    try {
      await FirebaseFirestore.instance.collection('Companyservices').add({
        'name': _serviceController.text,
        'imageUrl': imageUrl,
      });
      widget.onAddService(_serviceController.text, imageUrl);
      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
      if(mounted){
   Navigator.of(context).pop();
    }
    } catch (e) {
      // Handle Firestore error
      print('Error adding service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding service. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: CurvedAppBar(title: ''),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('ADD A SERVICE', style: AppTextStyles.subheading(context)),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Service Name',
                controller: _serviceController,
                prefixIcon: Icons.design_services_sharp,
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage == null
                    ? Icon(Icons.add_a_photo, size: 100, color: AppColors.textPrimaryColor)
                    : Image.file(File(_selectedImage!.path), width: 100, height: 100),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: _submitService,
                
                child: Text('SUBMIT'),
                
                style: AppButtonStyles.largeButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

