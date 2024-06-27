
class Service {
  final String name;
  final String imageUrl;

  Service({required this.name, required this.imageUrl});

  factory Service.fromMap(Map<String, dynamic> data) {
    return Service(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
