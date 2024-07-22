

// ignore_for_file: unused_import

import 'package:company_application/features/category/views/category_image_details.dart';
import 'package:company_application/features/photos/views/category_image.dart';
import 'package:company_application/features/workers/worker_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const CategoryDetailPage({
    Key? key, 
    required this.categoryName,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

 class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late Future<DocumentSnapshot> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = FirebaseFirestore.instance
        .collection('Companycategory')
        .doc(widget.categoryId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Category not found'));
        }

        Map<String, dynamic> categoryData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> categoryDataSets = categoryData['categoryData'] ?? [];
        List<dynamic> workers = categoryData['workers'] ?? [];

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackgroundcolor,
            appBar: AppBar(
              backgroundColor: AppColors.textPrimaryColor,
              title: Text(widget.categoryName,style: TextStyle(color: Colors.white),),
              bottom: TabBar(labelStyle: TextStyle(color: Colors.white),
              indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Photos'),
                  Tab(text: 'Total Workers'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Photos Tab
                ListView.builder(
                  itemCount: categoryDataSets.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> categorySet = categoryDataSets[index];
                    String imageUrl = categorySet['imageUrl'] ?? '';
                    String title = categorySet['title'] ?? 'No Title';
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        if (imageUrl.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryImageDetailPage(categorySet: categorySet),
                                ),
                              );
                            },
                            child: Center(
                              child: Image.network(
                                imageUrl, 
                                height: 200, 
                                width: 300, 
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                        SizedBox(height: 8),
                        Divider(),
                      ],
                    );
                  },
                ),
                // Workers Tab
                ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> worker = workers[index];
                    return ListTile(
                      leading: worker['imageUrl'] != null && worker['imageUrl'].isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(worker['imageUrl']))
                          : Icon(Icons.person),
                      title: Text(worker['name']),
                      subtitle: Text('${worker['experience']} • ${worker['location']}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to worker detail page if needed
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context)=> WorkerDetailPage(worker: worker)));

                      },
                      
                    );
                    
                  },
                  
                ),
                
              ],
            ),
          ),
        );
      },
    );
  }
}