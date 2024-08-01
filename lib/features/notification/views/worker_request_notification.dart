
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:company_application/features/notification/views/worker_details.dart';

class WorkerRequestList extends StatefulWidget {
  @override
  State<WorkerRequestList> createState() => _WorkerRequestListState();
}

class _WorkerRequestListState extends State<WorkerRequestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Requests'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
    body:  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workers_request').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Loading...');
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print('No worker requests found.');
          return Center(child: Text('No worker requests found.'));
        }

        print('Worker requests found: ${snapshot.data!.docs.length}');

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            print('Document data: $data');
            String workerId = document.id;
            String name = data['name'] ?? 'Unknown';
            String email = data['email'] ?? 'Unknown';
            String phoneNumber = data['phoneNumber'] ?? 'Unknown';
            String address = data['address'] ?? 'Unknown';
            String dob = data['dob'] ?? 'Unknown';
            String category = data['category'] ?? 'Unknown';
            String experience = data['experience'] ?? 'Unknown';
            String photoUrl = data['photoUrl'] ?? '';
            String idProofUrl = data['idProofUrl'] ?? '';
            String certificationUrl = data['certificationUrl'] ?? '';
            String resumeUrl = data['resumeUrl'] ?? '';

            return Dismissible(
              key: Key(workerId),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion',style: AppTextStyles.subheading(context),),
                      content: Text('Are you sure you want to delete $name\'s request?',style: AppTextStyles.body(context),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('CANCEL',style: AppTextStyles.body(context),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('DELETE',style: AppTextStyles.body(context),),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                _deleteWorkerRequest(workerId);
              },
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WorkerDetailsScreen(
                          name: name,
                          email: email,
                          phoneNumber: phoneNumber,
                          address: address,
                          dob: dob,
                          category: category,
                          experience: experience,
                          photoUrl: photoUrl,
                          idProofUrl: idProofUrl,
                          certificationUrl: certificationUrl,
                          resumeUrl: resumeUrl,
                          workerId: workerId,
                        ),
                      ));
                    },
                    leading: CircleAvatar(
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl) as ImageProvider<Object>
                          : AssetImage('assets/images/default_avatar.jpg') as ImageProvider<Object>,
                      radius: 25,
                    ),
                    title: Text(
                        'Worker request: $name has requested to join category: $category on ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(thickness: 2),
                ],
              ),
            );
          }).toList(),
        );
      },
    )
  );}

  Future<void> _deleteWorkerRequest(String workerId) async {
    try {
      await FirebaseFirestore.instance.collection('workers_request').doc(workerId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Worker request deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting worker request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to delete worker request. Please try again.'),
        ),
      );
    }
  }
}
