import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/category/views/add_category.dart';
import 'package:company_application/features/category/views/details_category.dart';
import 'package:company_application/features/category/views/edit_category_screen.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:company_application/providers/category_provider.dart';
import 'package:company_application/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/app_colors.dart';

class CategoryViewScreen extends StatelessWidget {
  final Service service;

  const CategoryViewScreen({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryProvider()..fetchCategories(service.id),
      child: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackgroundcolor,
            appBar: AppBar(
              backgroundColor: AppColors.textPrimaryColor,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${service.name} :',
                    style: AppTextStyles.subheading(context),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Companycategory')
                        .where('serviceId', isEqualTo: service.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No categories available.'));
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final categoryDoc = snapshot.data!.docs[index];
                          final category = categoryDoc.data() as Map<String, dynamic>;
                          final docId = categoryDoc.id;

                          return Slidable(
                            key: Key(docId),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    bool? confirm = await Dialogs.showConfirmationDialog(
                                        context, 'Delete Category', 'Are you sure you want to delete this category?');
                                    if (confirm == true) {
                                      categoryProvider.deleteCategory(docId);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Category deleted successfully.')),
                                      );
                                    }
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
  onPressed: (context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryAddItemScreen(
          categoryId: docId,
          categoryName: category['name'],
        ),
      ),
    );
  },
  backgroundColor: AppColors.textPrimaryColor,
  foregroundColor: Colors.white,
  icon: Icons.add,
  label: 'Add',
),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryDetailPage(
                                      categoryName: category['name'],
                                      categoryId: docId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                padding: EdgeInsets.all(16.0),
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
                                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                                  title: Text(category['name']),
                                 
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.textPrimaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryAddScreen(service: service)),
                );
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
        },
      ),
    );
  }
}
