import 'dart:io';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class WorkerDetailsScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String dob;
  final String category;
  final String experience;
  final String photoUrl;
  final String idProofUrl;
  final String certificationUrl;
  final String resumeUrl;
  final String workerId;

  const WorkerDetailsScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dob,
    required this.category,
    required this.experience,
    required this.photoUrl,
    required this.idProofUrl,
    required this.certificationUrl,
    required this.resumeUrl,
    required this.workerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        title: Text('Worker Request Details'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : AssetImage('assets/images/default_user.png') as ImageProvider,
                radius: 50,
              ),
            ),
            SizedBox(height: 16),
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: $phoneNumber', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Address: $address', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('DOB: $dob', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Category: $category', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Experience: $experience', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDocumentButton(context, 'View ID Proof', idProofUrl),
                  SizedBox(width: 8),
                  _buildDocumentButton(context, 'View Certificate', certificationUrl),
                  SizedBox(width: 8),
                  _buildDocumentButton(context, 'View Resume', resumeUrl),
                ],
              ),
            ),
            SizedBox(height: 80),
            Row(
              children: [
                ElevatedButton(
                  style: AppButtonStyles.smallButton(context),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('workers_request')
                        .doc(workerId)
                        .update({'registrationAccepted': true});
                    print("Updated worker document with ID: $workerId");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Worker accepted successfully')),
                    );
                  },
                  child: Text('Accept'),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  style: AppButtonStyles.smallButton(context),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('workers_request')
                        .doc(workerId)
                        .update({'registrationRejected': true});
                    print("Rejected worker with ID: $workerId");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Worker rejected')),
                    );
                  },
                  child: Text('Reject'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _viewDocument(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No document available')),
      );
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempDocumentPath = '${tempDir.path}/temp_document.pdf';
      final file = await File(tempDocumentPath).writeAsBytes(bytes);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(backgroundColor: AppColors.textPrimaryColor,
            //  title: Text('Document Viewer')
            ),
            body: PDFView(
              filePath: file.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error viewing document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load the document. Please try again.')),
      );
    }
  }

  Widget _buildDocumentButton(BuildContext context, String label, String url) {
    return ElevatedButton(
      style: AppButtonStyles.smallButton(context),
      onPressed: url.isNotEmpty ? () => _viewDocument(context, url) : null,
      child: Text(label),
    );
  }
}
