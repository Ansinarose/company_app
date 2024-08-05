import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_id.dart';
import 'package:company_application/features/chat/views/customer_chatscreen.dart';
import 'package:company_application/utils/dateformat.dart';
import 'package:flutter/material.dart';

class CustomerChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: AppConstants.COMPANY_ID)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No customer chats found'));
        }

        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String chatRoomId = doc.id;
            List<dynamic> participants = data['participants'] ?? [];
            String customerId = participants.firstWhere(
              (id) => id != AppConstants.COMPANY_ID,
              orElse: () => 'Unknown',
            );
            Timestamp? lastMessageTimestamp = data['lastMessageTimestamp'] as Timestamp?;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('customer').doc(customerId).get(),
              builder: (context, customerSnapshot) {
                if (customerSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(title: Text('Loading...'));
                }

                String customerName = 'Unknown';
                if (customerSnapshot.hasData && customerSnapshot.data!.exists) {
                  customerName = (customerSnapshot.data!.data() as Map<String, dynamic>)['name'] ?? 'Unknown';
                }

                return ListTile(
                  title: Text(customerName),
                  subtitle: Text('Customer ID: $customerId'),
                  trailing: Text(lastMessageTimestamp != null ? formatMessageTime(lastMessageTimestamp.toDate()) : 'No messages'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyCustomerChatScreen(
                          chatRoomId: chatRoomId,
                          customerId: customerId,
                          customerName: customerName,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      },
    );
  }
}
