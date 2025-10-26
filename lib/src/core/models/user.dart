class User {
  final int id;
  final String name;
  final String email;
  final String profileImage;
  final List<int> favoriteIds;
  final List<int> reservationIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.favoriteIds,
    required this.reservationIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ?? 'assets/images/profile.png',
      favoriteIds: List<int>.from(json['favorite_ids'] ?? []),
      reservationIds: List<int>.from(json['reservation_ids'] ?? []),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'favorite_ids': favoriteIds,
      'reservation_ids': reservationIds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImage,
    List<int>? favoriteIds,
    List<int>? reservationIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      reservationIds: reservationIds ?? this.reservationIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Reservation {
  final int id;
  final int userId;
  final int placeId;
  final DateTime reservationDate;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String notes;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.reservationDate,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      placeId: json['place_id'] ?? 0,
      reservationDate:
          DateTime.tryParse(json['reservation_date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
      notes: json['notes'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'place_id': placeId,
      'reservation_date': reservationDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
