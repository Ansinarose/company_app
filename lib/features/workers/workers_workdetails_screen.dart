import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workers_WorkDetailScreen extends StatelessWidget {
  final String workId;

  const Workers_WorkDetailScreen({Key? key, required this.workId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        //title: Text('Work Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workers_works')
            .doc(workId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Work not found'));
          }

          var work = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(work['title'], style: AppTextStyles.subheading(context)),
                      SizedBox(height: 16),
                      Text('Price: \$${work['price']}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Description: ${work['description']}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Overview: ${work['overview']}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Dimensions: ${work['dimensions']}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Colors: ${work['colors'].join(', ')}', style: AppTextStyles.body(context)),
                      SizedBox(height: 8),
                      Text('Completion Time: ${work['completionTime']}', style: AppTextStyles.body(context)),
                      SizedBox(height: 16),
                      Text('Images:', style: AppTextStyles.subheading(context)),
                      SizedBox(height: 8),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (work['imageUrls'] as List).length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  work['imageUrls'][index],
                                  fit: BoxFit.cover,
                                  width: 150,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
