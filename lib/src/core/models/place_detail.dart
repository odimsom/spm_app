class PlaceDetail {
  final int id;
  final String name;
  final String imagePath;
  final double rating;
  final String description;
  final bool isFavorite;
  final List<String> galleryImages;
  final Map<String, dynamic> additionalInfo;

  PlaceDetail({
    int? id,
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.description,
    this.isFavorite = false,
    this.galleryImages = const [],
    this.additionalInfo = const {},
  }) : id = id ?? name.hashCode.abs();
}
