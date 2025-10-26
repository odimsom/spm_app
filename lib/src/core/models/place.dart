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
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final double rating;
  final bool isFavorite;
  final ImageData mainImage;
  final List<ImageData> galleryImages;
  final String openingHours;
  final String phone;
  final String address;
  final String priceRange;
  final DateTime updatedAt;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.isFavorite,
    required this.mainImage,
    required this.galleryImages,
    required this.openingHours,
    required this.phone,
    required this.address,
    required this.priceRange,
    required this.updatedAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      isFavorite: json['is_favorite'] ?? false,
      mainImage: ImageData.fromJson(json['main_image'] ?? {}),
      galleryImages:
          (json['gallery_images'] as List?)
              ?.map((img) => ImageData.fromJson(img))
              .toList() ??
          [],
      openingHours: json['opening_hours'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      priceRange: json['price_range'] ?? '',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'is_favorite': isFavorite,
      'main_image': mainImage.toJson(),
      'gallery_images': galleryImages.map((img) => img.toJson()).toList(),
      'opening_hours': openingHours,
      'phone': phone,
      'address': address,
      'price_range': priceRange,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Place copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    double? rating,
    bool? isFavorite,
    ImageData? mainImage,
    List<ImageData>? galleryImages,
    String? openingHours,
    String? phone,
    String? address,
    String? priceRange,
    DateTime? updatedAt,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      mainImage: mainImage ?? this.mainImage,
      galleryImages: galleryImages ?? this.galleryImages,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      priceRange: priceRange ?? this.priceRange,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
