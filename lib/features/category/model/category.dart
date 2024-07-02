// class Category {
//   final String name;
//   final String mainImageUrl; // Firebase Storage URL or path for the main image
//   final List<String> additionalImageUrls
// ; // Firebase Storage URL or path for the secondary image

//   Category({
//     required this.name,
//     required this.mainImageUrl,
//    // this.additionalImageUrls = const [],
//     required this.additionalImageUrls,
//   });
// }
class Category {
  final String id;
  final String name;
  final String serviceId; // Add serviceId field

  Category({
    required this.id,
    required this.name,
    required this.serviceId,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      serviceId: map['serviceId'], // Update to match your Firestore structure
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'serviceId': serviceId,
    };
  }
}
