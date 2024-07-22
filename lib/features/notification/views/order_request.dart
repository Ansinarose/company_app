import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/notification/views/order_details.dart';
import 'package:flutter/material.dart';

class NewOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Customerbookings')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No new orders'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var order = snapshot.data!.docs[index];
            return Column(
              children: [
                ListTile(
                  title: Text('Work Order Request: ${order['productTitle']}', style: AppTextStyles.body(context)),
                  subtitle: Text('Requested by: ${order['address']['name']} from ${order['address']['city']}', style: AppTextStyles.body(context)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
                      ),
                    ); 
                  },
                ),
                Divider(),  // Add the Divider here
              ],
            );
          },
        );
      },
    );
  }
}
