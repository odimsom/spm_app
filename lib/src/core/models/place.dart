class ImageData {
  final String type; // 'local' or 'remote'
  final String path;

  ImageData({required this.type, required this.path});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(type: json['type'] ?? 'local', path: json['path'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'path': path};
  }

  bool get isRemote => type == 'remote';
  bool get isLocal => type == 'local';
}

class Place {
  final int id;
  final String name;
  final String category;
  final String description;
  final String address;
  final String phone;
  final String openingHours;
  final String priceRange;
  final double rating;
  final ImageData mainImage;
  final List<ImageData> galleryImages;
  final bool isFavorite; // ✅ Se determina dinámicamente por usuario

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.phone,
    required this.openingHours,
    required this.priceRange,
    required this.rating,
    required this.mainImage,
    required this.galleryImages,
    this.isFavorite = false, // ✅ Por defecto FALSE
  });

  factory Place.fromJson(Map<String, dynamic> json, {bool isFavorite = false}) {
    return Place(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      openingHours: json['opening_hours'] as String,
      priceRange: json['price_range'] as String,
      rating: (json['rating'] as num).toDouble(),
      mainImage: ImageData.fromJson(json['main_image'] as Map<String, dynamic>),
      galleryImages: (json['gallery_images'] as List<dynamic>)
          .map((img) => ImageData.fromJson(img as Map<String, dynamic>))
          .toList(),
      isFavorite: isFavorite, // ✅ Se pasa desde el servicio
    );
  }

  // ✅ Método copyWith para actualizar isFavorite
  Place copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    String? address,
    String? phone,
    String? openingHours,
    String? priceRange,
    double? rating,
    ImageData? mainImage,
    List<ImageData>? galleryImages,
    bool? isFavorite,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      openingHours: openingHours ?? this.openingHours,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      mainImage: mainImage ?? this.mainImage,
      galleryImages: galleryImages ?? this.galleryImages,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
