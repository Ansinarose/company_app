import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AvailableWorkerScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;
  const AvailableWorkerScreen({super.key, required this.orderDetails});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

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
                subtitle: Text(
                  '${workerData['categories'] ?? 'No categories'}\n${workerData['address'] ?? 'No address'}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    if (workerData['contact'] != null) {
                      _makePhoneCall(workerData['contact']);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No contact number available')),
                      );
                    }
                  },
                ),
                onTap: () {
                  // Implement action when tapping on a worker
                  // For example, show more details or navigate to a detail screen
                   _showConfirmationDialog(context, workerData, orderDetails);
                },
              );
            },
          );
        },
      ),
    );
  }
   void _showConfirmationDialog(BuildContext context, Map<String, dynamic> workerData, Map<String, dynamic> orderDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Forward'),
          content: Text('Are you sure you want to forward this work to ${workerData['name']}?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _forwardOrderToWorker(context, workerData, orderDetails);
              },
            ),
          ],
        );
      },
    );
  }

  void _forwardOrderToWorker(BuildContext context, Map<String, dynamic> workerData, Map<String, dynamic> orderDetails) {
    FirebaseFirestore.instance.collection('worker_orders').add({
      'workerId': workerData['userId'],
      'workerName': workerData['name'],
      'orderDetails': orderDetails,
      'forwardedAt': FieldValue.serverTimestamp(),
      'status': 'forwarded',
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order forwarded to ${workerData['name']}')));
      Navigator.of(context).pop(); // Go back to the OrderDetailsScreen
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to forward order: $error')));
    });
  }
}
