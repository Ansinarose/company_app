class Service {
  final String id;
  final String name;
  final String imageUrl;

  Service({required this.id, required this.name, required this.imageUrl});

  factory Service.fromMap(Map<String, dynamic> data, String documentId) {
    return Service(
      id: documentId,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
