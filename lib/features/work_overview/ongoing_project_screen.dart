import 'package:company_application/features/work_overview/work_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class OngoingProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Projects'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Customerbookings')
            .where('workStartedAt', isNull: false)
            .where('workCompletedAt', isNull: true)
            .orderBy('workStartedAt', descending: true)  // Add this line
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ongoing projects'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(booking['productTitle'] ?? 'Unknown Product', style: AppTextStyles.subheading(context)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Started: ${(booking['workStartedAt'] as Timestamp?)?.toDate().toString() ?? 'Unknown'}'),
                      Text('Status: Ongoing'),
                    ],
                  ),
                 onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WorkDetailScreen(bookingId: booking.id),
    ),
  );
},
                ),
              );
            },
          );
        },
      ),
    );
  }
}