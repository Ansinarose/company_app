import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WorkerDetailsScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String dob;
  final String category;
  final String experience;
  final String photoUrl;

  const WorkerDetailsScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dob,
    required this.category,
    required this.experience,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : AssetImage('assets/images/th (35).jpeg') as ImageProvider,
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
            SizedBox(height: 20,),
            Row(
              children: [
                ElevatedButton(style: AppButtonStyles.smallButton(context),
                  onPressed: (){}, child: Text('Accept')),
                  SizedBox(width: 30,),
                  ElevatedButton(style: AppButtonStyles.smallButton(context),
                    onPressed: (){}, child: Text('Reject'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
