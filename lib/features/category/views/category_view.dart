
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/features/category/views/add_category.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:flutter/material.dart';

import '../../../common/constants/app_colors.dart';

class CategoryViewScreen extends StatelessWidget {
  final Service service;

  const CategoryViewScreen({Key? key, required this.service}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Companycategory')
        .where('serviceId', isEqualTo: service.id) // Filter by serviceId
        .get();
    
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text(service.name),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching categories.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available.'));
          }

          List<Map<String, dynamic>> categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category['name']),
                // leading: category['imageUrl'] != null
                //     ? Image.network(category['imageUrl'])
                //     : null,
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.textPrimaryColor,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CategoryAddScreen(service: service),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.textPrimaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryAddScreen(service: service)));
        },
        tooltip: 'Add Category',
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.textPrimaryColor,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                // Handle settings tap
              },
              icon: Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
      ),
    );
    
  }
}
