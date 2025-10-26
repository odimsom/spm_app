import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/models/user.dart';
import 'package:spm/src/core/services/database_service.dart';

class PlacesService {
  final DatabaseService _databaseService = DatabaseService();

  // Singleton pattern
  static final PlacesService _instance = PlacesService._internal();
  factory PlacesService() => _instance;
  PlacesService._internal();

  Future<List<Place>> getAllPlaces() async {
    return await _databaseService.getAllPlaces();
  }

  Future<Place?> getPlace(int id) async {
    return await _databaseService.getPlace(id);
  }

  Future<List<Place>> getPlacesByCategory(String category) async {
    final allPlaces = await getAllPlaces();
    return allPlaces.where((place) => place.category == category).toList();
  }

  Future<List<Place>> searchPlaces(String query) async {
    final allPlaces = await getAllPlaces();
    query = query.toLowerCase();

    return allPlaces.where((place) {
      return place.name.toLowerCase().contains(query) ||
          place.description.toLowerCase().contains(query) ||
          place.category.toLowerCase().contains(query) ||
          place.address.toLowerCase().contains(query);
    }).toList();
  }

  Future<List<Place>> getFavoritePlaces(int userId) async {
    return await _databaseService.getFavoritePlaces(userId);
  }

  Future<void> toggleFavorite(int userId, int placeId) async {
    await _databaseService.toggleFavorite(userId, placeId);
  }

  Future<List<String>> getCategories() async {
    final allPlaces = await getAllPlaces();
    final categories = allPlaces
        .map((place) => place.category)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  Future<List<Place>> getFeaturedPlaces({int limit = 5}) async {
    final allPlaces = await getAllPlaces();
    allPlaces.sort((a, b) => b.rating.compareTo(a.rating));
    return allPlaces.take(limit).toList();
  }

  Future<List<Place>> getRecommendedPlaces({int limit = 6}) async {
    final allPlaces = await getAllPlaces();
    // Simple recommendation: places with rating >= 4.0, shuffled
    final goodPlaces = allPlaces.where((place) => place.rating >= 4.0).toList();
    goodPlaces.shuffle();
    return goodPlaces.take(limit).toList();
  }

  Future<void> forceReloadPlaces() async {
    await _databaseService.forceReloadPlaces();
  }
}

class UserService {
  final DatabaseService _databaseService = DatabaseService();

  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Future<User?> getCurrentUser() async {
    return await _databaseService.getCurrentUser();
  }

  Future<User?> getUser(int id) async {
    return await _databaseService.getUser(id);
  }

  Future<void> toggleFavorite(int placeId) async {
    final user = await getCurrentUser();
    if (user != null) {
      await _databaseService.toggleFavorite(user.id, placeId);
    }
  }

  Future<bool> isPlaceFavorite(int placeId) async {
    final user = await getCurrentUser();
    if (user != null) {
      return user.favoriteIds.contains(placeId);
    }
    return false;
  }

  Future<List<Place>> getFavoritePlaces() async {
    final user = await getCurrentUser();
    if (user != null) {
      return await _databaseService.getFavoritePlaces(user.id);
    }
    return [];
  }
}

class ReservationService {
  final DatabaseService _databaseService = DatabaseService();

  // Singleton pattern
  static final ReservationService _instance = ReservationService._internal();
  factory ReservationService() => _instance;
  ReservationService._internal();

  Future<int> createReservation({
    required int placeId,
    required DateTime reservationDate,
    String notes = '',
  }) async {
    final user = await UserService().getCurrentUser();
    if (user == null) throw Exception('User not found');

    final reservation = Reservation(
      id: 0, // Will be auto-generated
      userId: user.id,
      placeId: placeId,
      reservationDate: reservationDate,
      status: 'confirmed',
      notes: notes,
      createdAt: DateTime.now(),
    );

    return await _databaseService.createReservation(reservation);
  }

  Future<List<Reservation>> getUserReservations() async {
    final user = await UserService().getCurrentUser();
    if (user == null) return [];

    return await _databaseService.getUserReservations(user.id);
  }

  Future<List<Place>> getReservedPlaces() async {
    final reservations = await getUserReservations();
    final placesService = PlacesService();

    List<Place> places = [];
    for (var reservation in reservations) {
      final place = await placesService.getPlace(reservation.placeId);
      if (place != null) {
        places.add(place);
      }
    }

    return places;
  }
}
