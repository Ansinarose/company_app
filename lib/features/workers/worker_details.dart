// ignore_for_file: deprecated_member_use

import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerDetailPage extends StatefulWidget {
  final Map<String, dynamic> worker;

  const WorkerDetailPage({Key? key, required this.worker}) : super(key: key);

  @override
  _WorkerDetailPageState createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  bool isFavorite = false;

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
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: widget.worker['imageUrl'] != null
                          ? NetworkImage(widget.worker['imageUrl'])
                          : null,
                      child: widget.worker['imageUrl'] == null
                          ? Icon(Icons.person, size: 60)
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Name: ${widget.worker['name']}',
                    style: AppTextStyles.subheading(context),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Experience: ${widget.worker['experience']}',
                    style: AppTextStyles.body(context),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Location: ${widget.worker['location']}',
                    style: AppTextStyles.body(context),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchCaller(widget.worker['contact']),
                    child: Text(
                      'Contact: ${widget.worker['contact']}',
                      style: AppTextStyles.body(context).copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Categories: ${widget.worker['categories'].join(', ')}',
                    style: AppTextStyles.body(context),
                  ),
                  // Add more details as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
