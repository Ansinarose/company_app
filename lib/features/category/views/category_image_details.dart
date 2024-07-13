import 'package:flutter/material.dart';

class CategoryImageDetailPage extends StatelessWidget {
  final Map<String, dynamic> categorySet;

  const CategoryImageDetailPage({Key? key, required this.categorySet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> additionalImages = categorySet['additionalImages'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(categorySet['title'] ?? 'Category Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (categorySet['imageUrl'] != null)
              Image.network(categorySet['imageUrl'], height: 200, width: double.infinity, fit: BoxFit.cover),
            
            SizedBox(height: 16),
            Text('Images of different angles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            
            // Horizontal slider for additional images
            if (additionalImages.isNotEmpty)
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: additionalImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        additionalImages[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            
            SizedBox(height: 16),
            Text('Description: ${categorySet['description'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Price: ${categorySet['price'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Overview: ${categorySet['overview'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Available Colors: ${categorySet['colors']?.join(', ') ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Estimated Completion: ${categorySet['estimatedCompletion'] ?? 'N/A'}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}