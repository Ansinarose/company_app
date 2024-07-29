import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryImageDetailPage extends StatelessWidget {
  final Map<String, dynamic> categorySet;

  const CategoryImageDetailPage({Key? key, required this.categorySet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> additionalImages = categorySet['additionalImages'] ?? [];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
      //  title: Text(categorySet['title'] ?? 'Category Details'),
       // elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (categorySet['imageUrl'] != null)
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          categorySet['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    'Images of different angles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (additionalImages.isNotEmpty)
                    Container(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: additionalImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                additionalImages[index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 20),
                  _buildDetailRow('Description', categorySet['description']),
                  _buildDetailRow('Price', categorySet['price']),
                  _buildDetailRow('Overview', categorySet['overview']),
                  _buildDetailRow('Available Colors', categorySet['colors']?.join(', ')),
                  _buildDetailRow('Estimated Completion', categorySet['estimatedCompletion']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
