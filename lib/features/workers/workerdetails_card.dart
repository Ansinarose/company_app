// ignore_for_file: deprecated_member_use

import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerDetailsCard extends StatelessWidget {
  final Map<String, dynamic> worker;

  const WorkerDetailsCard({Key? key, required this.worker}) : super(key: key);

  void _launchCaller(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Details'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('workers_request').doc(worker['userId']).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No additional details available'));
          }

          Map<String, dynamic> additionalData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Center(
              child: Card(
                margin: EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: worker['imageUrl'] != null && worker['imageUrl'].isNotEmpty
                              ? NetworkImage(worker['imageUrl'])
                              : null,
                          child: worker['imageUrl'] == null || worker['imageUrl'].isEmpty
                              ? Image.asset(
                                  'assets/images/placeholderimage.jpeg',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Name: ${worker['name'] ?? 'N/A'}', style: AppTextStyles.subheading(context)),
                      SizedBox(height: 8),
                      Text('Email: ${additionalData['email'] ?? 'N/A'}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Phone: ${worker['contact'] ?? 'N/A'}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('DOB: ${additionalData['dob'] ?? 'N/A'}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Experience: ${additionalData['experience'] ?? 'N/A'}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Location: ${worker['address'] ?? 'N/A'}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Categories: ${worker['categories'] ?? 'N/A'}', style: AppTextStyles.body(context)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _launchCaller(worker['contact'] ?? ''),
                        child: Text('Call Worker'),
                        style: AppButtonStyles.smallButton(context))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}