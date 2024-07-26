import 'package:company_application/features/workers/workers_workdetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class AllWorksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        title: Text('All Works and corresponding Workers', style: AppTextStyles.whiteBody(context)),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workers_works').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No works found'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75, // Adjust this value to change the card's aspect ratio
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var work = snapshot.data!.docs[index];
              var imageUrl = (work['imageUrls'] as List).isNotEmpty 
                  ? work['imageUrls'][0] 
                  : null;
              var workerName = work['workerName'] ?? 'Unknown';

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Workers_WorkDetailScreen(workId: work.id),
                  ),
                ),
                onLongPress: () => _showDeleteConfirmationDialog(context, work.id),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            image: imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: imageUrl == null
                              ? Center(child: Text('No Image'))
                              : null,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ' ${workerName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteWork(BuildContext context, String workId) async {
    try {
      await FirebaseFirestore.instance.collection('workers_works').doc(workId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Work deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting work: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String workId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete',style: AppTextStyles.subheading(context),),
          content: Text('Are you sure you want to delete this work?',style: AppTextStyles.body(context),),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: AppTextStyles.body(context),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete',style: AppTextStyles.body(context),),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteWork(context, workId);
              },
            ),
          ],
        );
      },
    );
  }
}