class Worker {
  final String name;
  final String location;
  final String experience;
  final List<String> categories; // List of category names
  final String contact;
  final String imageUrl; // Firebase Storage URL or path

  Worker({
    required this.name,
    required this.location,
    required this.experience,
    required this.categories,
    required this.contact,
    required this.imageUrl,
  });
}