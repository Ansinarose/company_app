import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableWorkerScreen extends StatelessWidget {
  const AvailableWorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text('Available Workers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .where('isAvailable', isEqualTo: true)
            .where('timestamp', isGreaterThan: DateTime.now().subtract(Duration(hours: 24)))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No available workers'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var workerData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: workerData['imageUrl'] != null
                      ? NetworkImage(workerData['imageUrl'])
                      : null,
                  child: workerData['imageUrl'] == null
                      ? Icon(Icons.person)
                      : null,
                ),
                title: Text(workerData['name'] ?? 'Unknown'),
                subtitle: Text(workerData['categories'] ?? 'No categories'),
                trailing: IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    // Implement call functionality here
                    // You can use url_launcher package to make a call
                    // launch("tel:${workerData['contact']}");
                  },
                ),
                onTap: () {
                  // Implement action when tapping on a worker
                  // For example, show more details or navigate to a detail screen
                },
              );
            },
          );
        },
      ),
    );
  }
}