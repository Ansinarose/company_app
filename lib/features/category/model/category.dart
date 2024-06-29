class Category {
  final String name;
  final String mainImageUrl; // Firebase Storage URL or path for the main image
  final List<String> additionalImageUrls
; // Firebase Storage URL or path for the secondary image

  Category({
    required this.name,
    required this.mainImageUrl,
   // this.additionalImageUrls = const [],
    required this.additionalImageUrls,
  });
}
