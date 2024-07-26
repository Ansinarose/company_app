import 'package:company_application/features/workers/allwork_image_scree.dart';
import 'package:company_application/features/workers/workers_workdetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';


class WorksFromWorkersWidget extends StatelessWidget {
  const WorksFromWorkersWidget({Key? key}) : super(key: key);

  void _navigateToWorkDetail(BuildContext context, String workId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Workers_WorkDetailScreen(workId: workId),
      ),
    );
  }

  void _navigateToAllWorks(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AllWorksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Works of Alfa Aluminium:', style: AppTextStyles.subheading(context)),
        SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('workers_works')
              .limit(3)
              .snapshots(),
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

            return Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var work = snapshot.data!.docs[index];
                    var imageUrl = (work['imageUrls'] as List).isNotEmpty 
                        ? work['imageUrls'][0] 
                        : null;

                    return GestureDetector(
                      onTap: () => _navigateToWorkDetail(context, work.id),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                    );
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _navigateToAllWorks(context),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}