// ignore_for_file: unused_import, unused_element

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/common/constants/app_button_styles.dart';

class WorkDetailScreen extends StatelessWidget {
  final String bookingId;

  const WorkDetailScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        title: Text('Work Details'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Customerbookings')
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Work not found'));
          }

          var workData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              workData['productImage'] ?? '',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error),
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Product Details', style: AppTextStyles.heading(context)),
                        Divider(),
                        _buildDetailRow('Title', workData['productTitle'] ?? 'N/A'),
                        _buildDetailRow('Price', '₹${workData['productPrice'] ?? 'N/A'}'),
                        _buildDetailRow('Color', workData['selectedColor'] ?? 'N/A'),
                        _buildDetailRow('Estimated Completion', workData['productEstimatedCompletion'] ?? 'N/A'),
                        SizedBox(height: 16),
                        Text('Customer Details', style: AppTextStyles.heading(context)),
                        Divider(),
                        _buildDetailRow('Name', workData['address']['name'] ?? 'N/A'),
                        _buildDetailRow('Phone', workData['address']['phone'] ?? 'N/A'),
                        _buildDetailRow('Address', '${workData['address']['houseNo']}, ${workData['address']['road']}, ${workData['address']['city']}, ${workData['address']['state']} - ${workData['address']['pincode']}'),
                        SizedBox(height: 16),
                        Text('Work Status', style: AppTextStyles.heading(context)),
                        Divider(),
                        _buildDetailRow('Started At', _formatTimestamp(workData['workStartedAt'])),
                     //   _buildDetailRow('Current Status', 'Ongoing'),
                         _buildDetailRow('Completed At', _formatTimestamp(workData['workCompletedAt'])),
                      //  _buildDetailRow('Current Status', 'completed'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Center(
                //   child: ElevatedButton(
                //     style: AppButtonStyles.smallButton(context),
                //     onPressed: () => _markAsCompleted(context, bookingId),
                //     child: Text('Mark as Completed'),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text('$label:', ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return timestamp.toDate().toString();
    }
    return timestamp.toString();
  }

  void _markAsCompleted(BuildContext context, String bookingId) {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Completion'),
          content: Text('Are you sure you want to mark this work as completed?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateWorkStatus(context, bookingId);
              },
            ),
          ],
        );
      },
    );
  }

  void _updateWorkStatus(BuildContext context, String bookingId) {
    FirebaseFirestore.instance
        .collection('Customerbookings')
        .doc(bookingId)
        .update({
      'workCompletedAt': FieldValue.serverTimestamp(),
      'status': 'completed'
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Work marked as completed successfully')),
      );
      Navigator.of(context).pop(); // Go back to the previous screen
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update work status: $error')),
      );
    });
  }
}