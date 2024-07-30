import 'package:company_application/features/workers/workerdetails_card.dart';
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PersonSlider extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('isAvailable', isEqualTo: true)
          .where('timestamp', isGreaterThan: DateTime.now().subtract(Duration(hours: 24)))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No available workers'));
        }

        final workers = snapshot.data!.docs;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    var workerData = workers[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkerDetailsCard(worker: workerData),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: ClipOval(
                          child: workerData['imageUrl'] != null && workerData['imageUrl'].isNotEmpty
                              ? Image.network(
                                  workerData['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/placeholderimage.jpeg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/placeholderimage.jpeg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _pageController,
              count: workers.length,
              effect: WormEffect(
                dotWidth: 8.0,
                dotHeight: 8.0,
                activeDotColor: AppColors.textPrimaryColor,
                dotColor: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}