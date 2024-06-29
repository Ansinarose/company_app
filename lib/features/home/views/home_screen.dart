import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_application/features/category/views/category_view.dart';
import 'package:company_application/features/services/model/service.dart';
import 'package:company_application/features/services/views/add_services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:company_application/common/widgets/bottom_nav_bar.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/auth/models/user_model.dart';
import 'package:company_application/common/widgets/person_slider.dart';
import 'package:company_application/common/widgets/horrizontal_slider.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _addService(String name, String imageUrl) {
    // This function is not needed when using StreamBuilder, as the UI updates automatically
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAddService() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddServicePage(
          onAddService: _addService,
        ),
      ),
    );
  }

  void _navigateToServiceDetail(Service service) {
    // Implement navigation to the service detail page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryViewScreen (
          service: service),
      ),
    );
  }

  Future<void> _deleteService(String serviceId) async {
    try {
      await FirebaseFirestore.instance.collection('Companyservices').doc(serviceId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.textPrimaryColor,
          content: Text('Service deleted successfully.',style: AppTextStyles.whiteBody(context),)),
      );
    } catch (e) {
      print('Error deleting service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.textPrimaryColor,
          content: Text('Error deleting service. Please try again.',
          style: AppTextStyles.whiteBody(context),)),
      );
    }
  }

  void _showDeleteConfirmationDialog(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Service',style: AppTextStyles.heading(context),),
        content: Text('Are you sure you want to delete ${service.name}?',style: AppTextStyles.body(context),),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',style: AppTextStyles.body(context),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteService(service.id);
            },
            child: Text('Delete',style: AppTextStyles.body(context),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              user.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_important, color: AppColors.textsecondaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonSlider(itemCount: 10),
              SizedBox(height: screenHeight * 0.02),
              HorizontalSlider(),
              SizedBox(height: screenHeight * 0.03),
              Text('Services:', style: AppTextStyles.subheading(context)),
              SizedBox(height: screenHeight * 0.02),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Companyservices').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<Service> services = snapshot.data!.docs
                      .map((doc) => Service.fromMap(doc.data() as Map<String, dynamic>, doc.id)) // Pass document ID
                      .toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 14.0,
                      mainAxisSpacing: 14.0,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemCount: services.length + 1, // Add one more item for the "Add More Services" container
                    itemBuilder: (context, index) {
                      if (index == services.length) {
                        return GestureDetector(
                          onTap: _navigateToAddService,
                          child: Container(
                            width: screenWidth * 0.28,
                            height: screenHeight * 1,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 2, 107, 6),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 40),
                                SizedBox(height: 10),
                                Text(
                                  'Add More Services',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        final service = services[index];
                        return GestureDetector(
                          onTap: () => _navigateToServiceDetail(service),
                          onLongPress: () => _showDeleteConfirmationDialog(service),
                          child: Container(
                            width: screenWidth * 0.28,
                            height: screenHeight * 1,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 2, 107, 6),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    service.imageUrl,
                                    width: screenWidth * 0.2,
                                    height: screenHeight * 0.1,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    service.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}