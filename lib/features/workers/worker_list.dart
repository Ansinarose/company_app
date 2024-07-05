import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class WorkersListView extends StatelessWidget {
  final String categoryId;

  const WorkersListView({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Companycategory')
          .doc(categoryId)
          .collection('workers')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No workers available.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var worker = snapshot.data!.docs[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                 borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
            ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: worker['imageUrl'] != null && worker['imageUrl'].isNotEmpty ? 
                  NetworkImage(worker['imageUrl'])
                  :AssetImage('assets/images/th (35).jpeg') as ImageProvider,
                  radius: 35,
                ),
                title: Center(child: Text(worker['name'], style: AppTextStyles.body(context))),
                subtitle: Center(child: Text(worker['location'], style: AppTextStyles.caption(context))),
                // You can add more details or customize the ListTile as needed
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        );
      },
    );
  }
}