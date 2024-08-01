import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class HighlightsWidget extends StatefulWidget {
  @override
  _HighlightsWidgetState createState() => _HighlightsWidgetState();
}

class _HighlightsWidgetState extends State<HighlightsWidget> {
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Highlights of the day:', style: AppTextStyles.subheading(context)),
        SizedBox(height: 10),
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
    );
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
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

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
}