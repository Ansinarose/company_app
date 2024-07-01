

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/category/views/add_category.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:flutter/material.dart';

class CategoryViewScreen extends StatelessWidget {
  const CategoryViewScreen({Key? key, required Service service}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('CompanyServices').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found.'));
          } else {
            List<Map<String, dynamic>> categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    categories[index]['name'] ?? 'No Name',
                    style: TextStyle(
                      color: AppColors.textPrimaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () {
                    // Handle category tap if needed
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.textPrimaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryAddScreen()));
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
