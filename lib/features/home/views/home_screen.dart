import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/widgets/service_grid_widget.dart';
import 'package:company_application/common/widgets/worksfrom_workers_widget.dart';
import 'package:company_application/common/widgets/bottom_nav_bar.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/auth/models/user_model.dart';
import 'package:company_application/common/widgets/person_slider.dart';
import 'package:company_application/common/widgets/horrizontal_slider.dart';
import 'package:company_application/features/notification/views/notification_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = path.basename(file.path);
      final storageRef = FirebaseStorage.instance.ref().child('highlights/$fileName');

      try {
        await storageRef.putFile(file);
        String downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('CompanyHighlights').add({
          'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _fetchImages();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _fetchImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('CompanyHighlights')
          .orderBy('timestamp', descending: true)
          .get();

      final imageUrls = snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();

      setState(() {
        _imageUrls = imageUrls;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      // Delete the image from Firebase Storage
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      // Delete the image record from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('CompanyHighlights')
          .where('imageUrl', isEqualTo: imageUrl)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        _fetchImages();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  void _showDeleteDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Image"),
          content: Text("Are you sure you want to delete this image?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteImage(imageUrl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.textPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              user.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationScreen()));
            },
            icon: Icon(Icons.notification_important, color: AppColors.textsecondaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonSlider(itemCount: 10),
              SizedBox(height: screenHeight * 0.02),
              HorizontalSlider(),
              SizedBox(height: screenHeight * 0.03),
              ServicesGridWidget(),
              SizedBox(height: screenHeight * 0.03),
              WorksFromWorkersWidget(),
              SizedBox(height: screenHeight * 0.03),
              Text('Highlights of the day:', style: AppTextStyles.subheading(context)),
              SizedBox(height: screenHeight * 0.02),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  ..._imageUrls.map((url) => GestureDetector(
                    onLongPress: () => _showDeleteDialog(url),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 12,
                      height: MediaQuery.of(context).size.width / 3 - 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )).toList(),
                  Container(
                    width: MediaQuery.of(context).size.width / 3 - 12,
                    height: MediaQuery.of(context).size.width / 3 - 12,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.add, size: 40, color: AppColors.textsecondaryColor),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}