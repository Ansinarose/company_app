import 'package:flutter/material.dart';

class WorkerDetailPage extends StatefulWidget {
  final Map<String, dynamic> worker;

  const WorkerDetailPage({Key? key, required this.worker}) : super(key: key);

  @override
  _WorkerDetailPageState createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Details'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              // TODO: Implement adding/removing from favorites in your data storage
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: widget.worker['imageUrl'] != null
                    ? NetworkImage(widget.worker['imageUrl'])
                    : null,
                child: widget.worker['imageUrl'] == null
                    ? Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Text('Name: ${widget.worker['name']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Experience: ${widget.worker['experience']}'),
            SizedBox(height: 8),
            Text('Location: ${widget.worker['location']}'),
            SizedBox(height: 8),
            Text('Contact: ${widget.worker['contact']}'),
            SizedBox(height: 8),
            Text('Categories: ${widget.worker['categories'].join(', ')}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}