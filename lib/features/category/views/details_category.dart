// ignore_for_file: unused_import

import 'package:company_application/features/category/views/category_image_details.dart';
import 'package:company_application/features/category/views/edit_category_screen.dart';
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
  Future<void> _deleteItem(Map<String, dynamic> item) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        // Delete from main document
        await FirebaseFirestore.instance
            .collection('Companycategory')
            .doc(widget.categoryId)
            .update({
          'categoryData': FieldValue.arrayRemove([item])
        });

        // Delete from 'items' subcollection
        QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
            .collection('Companycategory')
            .doc(widget.categoryId)
            .collection('items')
            .get();

        for (var doc in itemsSnapshot.docs) {
          List<dynamic> itemData = (doc.data() as Map<String, dynamic>)['itemData'] ?? [];
          itemData.removeWhere((element) => element['title'] == item['title']);
          await doc.reference.update({'itemData': itemData});
          if (itemData.isEmpty) {
            await doc.reference.delete();
          }
        }

        setState(() {}); // Trigger a rebuild of the widget

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item: $e')),
        );
      }
    }
  }

  Future<void> _deleteWorker(Map<String, dynamic> worker) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this worker?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        // Delete from main document
        await FirebaseFirestore.instance
            .collection('Companycategory')
            .doc(widget.categoryId)
            .update({
          'workers': FieldValue.arrayRemove([worker])
        });

        // Delete from 'items' subcollection
        QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
            .collection('Companycategory')
            .doc(widget.categoryId)
            .collection('items')
            .get();

        for (var doc in itemsSnapshot.docs) {
          List<dynamic> workers = (doc.data() as Map<String, dynamic>)['workers'] ?? [];
          workers.removeWhere((element) => element['name'] == worker['name']);
          await doc.reference.update({'workers': workers});
        }

        setState(() {}); // Trigger a rebuild of the widget

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Worker deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete worker: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundcolor,
        appBar: AppBar(
          backgroundColor: AppColors.textPrimaryColor,
          title: Text(
            widget.categoryName,
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(color: Colors.white),
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Items'),
              Tab(text: 'Workers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Items Tab
            FutureBuilder<List<dynamic>>(
              future: _fetchItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<dynamic> allItems = snapshot.data ?? [];
                if (allItems.isEmpty) {
                  return Center(child: Text('No items found'));
                }
                return ListView.builder(
                  itemCount: allItems.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> item = allItems[index];
                    String imageUrl = item['imageUrl'] ?? '';
                    String title = item['title'] ?? 'No Title';

                    return GestureDetector(
                      onLongPress: () => _deleteItem(item),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              title,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (imageUrl.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryImageDetailPage(categorySet: item),
                                  ),
                                );
                              },
                              child: Center(
                                child: Container(
                                  height: 180,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 8),
                          Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            // Workers Tab
            FutureBuilder<List<dynamic>>(
              future: _fetchWorkers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<dynamic> allWorkers = snapshot.data ?? [];
                if (allWorkers.isEmpty) {
                  return Center(child: Text('No workers found'));
                }
                return ListView.builder(
                  itemCount: allWorkers.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> worker = allWorkers[index];
                    return GestureDetector(
                      onLongPress: () => _deleteWorker(worker),
                      child: ListTile(
                        leading: worker['imageUrl'] != null && worker['imageUrl'].isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(worker['imageUrl']),
                              )
                            : Icon(Icons.person),
                        title: Text(worker['name']),
                        subtitle: Text('${worker['experience']} • ${worker['location']}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkerDetailPage(worker: worker),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryAddItemScreen(
                  categoryId: widget.categoryId,
                  categoryName: widget.categoryName,
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: AppColors.textPrimaryColor,
        ),
      ),
    );
  }

  Future<List<dynamic>> _fetchItems() async {
    DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
        .collection('Companycategory')
        .doc(widget.categoryId)
        .get();

    Map<String, dynamic> categoryData = categoryDoc.data() as Map<String, dynamic>;
    List<dynamic> categoryItems = categoryData['categoryData'] ?? [];

    QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
        .collection('Companycategory')
        .doc(widget.categoryId)
        .collection('items')
        .get();

    List<dynamic> itemsData = [];
    for (var doc in itemsSnapshot.docs) {
      Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
      itemsData.addAll(item['itemData'] ?? []);
    }

    return [...categoryItems, ...itemsData];
  }

  Future<List<dynamic>> _fetchWorkers() async {
    DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
        .collection('Companycategory')
        .doc(widget.categoryId)
        .get();

    Map<String, dynamic> categoryData = categoryDoc.data() as Map<String, dynamic>;
    List<dynamic> categoryWorkers = categoryData['workers'] ?? [];

    QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
        .collection('Companycategory')
        .doc(widget.categoryId)
        .collection('items')
        .get();

    List<dynamic> itemWorkers = [];
    for (var doc in itemsSnapshot.docs) {
      Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
      itemWorkers.addAll(item['workers'] ?? []);
    }

    return [...categoryWorkers, ...itemWorkers];
  }
}