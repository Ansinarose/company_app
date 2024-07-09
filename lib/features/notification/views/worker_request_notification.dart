
import 'package:company_application/features/notification/views/worker_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';



class WorkerRequestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('worker_request').snapshots(),
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

            String name = data['name'] ?? 'Unknown';
            String email = data['email'] ?? 'Unknown';
            String phoneNumber = data['phoneNumber'] ?? 'Unknown';
            String address = data['address'] ?? 'Unknown';
            String dob = data['dob'] ?? 'Unknown';
            String category = data['category'] ?? 'Unknown';
            String experience = data['experience'] ?? 'Unknown';
            String photoUrl = data['photo'] ?? '';
           
            return Column(
              children: [
                ListTile(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WorkerDetailsScreen(
                    name: name, 
                  email: email, 
                  phoneNumber: phoneNumber,
                   address: address,
                    dob: dob, 
                  category: category,
                   experience: experience,
                    photoUrl: photoUrl,
                    
                  )));
                },
                  leading: CircleAvatar(
                    backgroundImage: photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : AssetImage('assets/images/th (35).jpeg') as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading image: $exception');
                    },
                    radius: 25,
                  ),
                  title: Text('Worker request: $name has requested to join categories : ${category} on ${DateFormat('yyyy-mm-dd').format(DateTime.now())} '),
                  // subtitle: Text(
                  //   'Email: $email\n'
                  //   'Phone: $phoneNumber\n'
                  //   'Address: $address\n'
                  //   'DOB: $dob\n'
                  //   'Category: $category\n'
                  //   'Experience: $experience\n'
                  //   'Request Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'
                  // ),
                 // isThreeLine: true,
                 trailing: Icon(Icons.arrow_forward_ios),
                 
                ),
                Divider(
                   thickness: 2,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}