import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_id.dart';
import 'package:company_application/utils/dateformat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/features/chat/views/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
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
            return Center(child: Text('No chats found'));
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              List<dynamic> participants = data['participants'] ?? [];
              String workerId = participants.firstWhere(
                (id) => id != AppConstants.COMPANY_ID,
                orElse: () => 'Unknown',
              );
              Timestamp lastMessageTimestamp = data['lastMessageTimestamp'] as Timestamp;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('worker_profiles').doc(workerId).get(),
                builder: (context, workerSnapshot) {
                  if (workerSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text('Loading...'));
                  }

                  String workerName = 'Unknown Worker';
                  if (workerSnapshot.hasData && workerSnapshot.data!.exists) {
                    workerName = (workerSnapshot.data!.data() as Map<String, dynamic>)['name'] ?? 'Unknown Worker';
                  }

                  return ListTile(
                    title: Text(workerName),
                   // subtitle: Text('Worker ID: $workerId'),
                    trailing: Text(formatMessageTime(lastMessageTimestamp.toDate())),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatRoomId: doc.id,
                            workerId: workerId,
                            workerName: workerName,
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
      ),
    );
  }
}


