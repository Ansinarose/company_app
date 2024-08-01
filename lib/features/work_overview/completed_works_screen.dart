import 'package:company_application/features/work_overview/work_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class CompletedWorksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Works'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Customerbookings')
            .where('workCompletedAt', isNull: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No completed works'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(booking['productTitle'], style: AppTextStyles.subheading(context)),
                  subtitle: Text('Completed: ${booking['workCompletedAt'].toDate().toString()}'),
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