import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final String workerId; // New parameter for workerId

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
    required this.workerId, // Initialize workerId in the constructor
  }) : super(key: key);

  Future<void> _viewDocument(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No document available')),
      );
      return;
    }

    if (url.toLowerCase().endsWith('.pdf')) {
      await _viewPdf(context, url);
    } else {
      await _launchUrl(context, url);
    }
  }

  Future<void> _viewPdf(BuildContext context, String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempDocumentPath = '${tempDir.path}/temp_document.pdf';
      final file = await File(tempDocumentPath).writeAsBytes(bytes);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Document Viewer')),
            body: PDFView(
              filePath: file.path,
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error loading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load the PDF document.')),
      );
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      print('Attempting to launch URL: $url'); // Debug statement
      final Uri uri = Uri.parse(url);
      if (await canLaunch(uri.toString())) { // Corrected function call
        await launch(uri.toString()); // Corrected function call
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the document.')),
      );
    }
  }

  Widget _buildDocumentButton(BuildContext context, String label, String url) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: url.isNotEmpty ? () => _viewDocument(context, url) : null,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : AssetImage('assets/images/default_user.png') as ImageProvider,
              radius: 50,
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
            _buildDocumentButton(context, 'View ID Proof', idProofUrl),
            SizedBox(height: 8),
            _buildDocumentButton(context, 'View Certificate', certificationUrl),
            SizedBox(height: 8),
            _buildDocumentButton(context, 'View Resume', resumeUrl),
            SizedBox(height: 20),
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
    // Show confirmation to the company owner
  },
  child: Text('Accept'),
),
                SizedBox(width: 30),
                ElevatedButton(
                  style: AppButtonStyles.smallButton(context),
                  onPressed: () {
                    // Implement your reject logic here
                    print('Reject worker with ID: $workerId');
                    // You can update Firestore here to mark the worker as rejected
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
}
