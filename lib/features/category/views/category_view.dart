
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/category/views/add_category.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:company_application/providers/category_provider.dart';
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
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundcolor,
        appBar: AppBar(
          backgroundColor: AppColors.textPrimaryColor,
          title: Text('Categories for ${service.name}'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${service.name} Categories:',
                style: AppTextStyles.subheading(context),
              ),
            ),
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  if (categoryProvider.categories.isEmpty) {
                    return Center(child: Text('No categories available.'));
                  }

                  return ListView.builder(
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index].data() as Map<String, dynamic>;
                      final docId = categoryProvider.categories[index].id;

                      return Slidable(
                        key: Key(docId),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                bool? confirm = await _showConfirmationDialog(context);
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
                              onPressed: (context) async {
                                final newName = await _showEditDialog(context, category['name']);
                                if (newName != null) {
                                  categoryProvider.editCategory(docId, newName);
                                }
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap on category tile
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
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                              title: Text(category['name']),
                              onTap: () {
                                // Handle tap on category tile
                              },
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
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentName) async {
    final TextEditingController controller = TextEditingController(text: currentName);
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Category Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
