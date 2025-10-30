import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spm/src/core/models/user.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/services/database_service.dart';
import 'dart:convert';

class SessionService extends ChangeNotifier {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  User? _currentUser;
  bool _isLoggedIn = false;
  final DatabaseService _databaseService = DatabaseService();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // Inicializar sesión desde SharedPreferences
  Future<void> initializeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('current_user');

      if (userData != null) {
        final userMap = json.decode(userData);
        _currentUser = User.fromJson(userMap);
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error initializing session: $e');
    }
  }

  // Iniciar sesión y guardar en SharedPreferences
  Future<void> login(User user) async {
    try {
      _currentUser = user;
      _isLoggedIn = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(user.toJson()));

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user session: $e');
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      _currentUser = null;
      _isLoggedIn = false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing user session: $e');
    }
  }

  // Actualizar información del usuario
  Future<void> updateUser(User updatedUser) async {
    try {
      _currentUser = updatedUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(updatedUser.toJson()));

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user session: $e');
    }
  }

  // ✅ Toggle favorito con notificación de cambios
  Future<void> toggleFavorite(int placeId) async {
    if (_currentUser == null) return;

    try {
      await _databaseService.toggleFavorite(_currentUser!.id, placeId);

      // Actualizar el usuario con los favoritos actualizados
      final updatedUser = await _databaseService.getUser(_currentUser!.id);
      if (updatedUser != null) {
        await updateUser(updatedUser);
      }

      // Notificar a los listeners que los favoritos cambiaron
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Crear reserva y actualizar sesión
  Future<bool> createReservation(
    int placeId,
    DateTime reservationDate,
    String notes,
  ) async {
    if (_currentUser == null) return false;

    try {
      final reservation = Reservation(
        id: 0, // Se auto-incrementa en la DB
        userId: _currentUser!.id,
        placeId: placeId,
        reservationDate: reservationDate,
        status: 'confirmed',
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _databaseService.createReservation(reservation);

      // Actualizar el usuario actual con las nuevas reservas
      final updatedUser = await _databaseService.getUser(_currentUser!.id);
      if (updatedUser != null) {
        await updateUser(updatedUser);
      }

      return true;
    } catch (e) {
      debugPrint('Error creating reservation: $e');
      return false;
    }
  }

  // Obtener reservas del usuario actual
  Future<List<Reservation>> getUserReservations() async {
    if (_currentUser == null) return [];

    try {
      return await _databaseService.getUserReservations(_currentUser!.id);
    } catch (e) {
      debugPrint('Error getting user reservations: $e');
      return [];
    }
  }

  // Obtener lugares favoritos del usuario actual
  Future<List<Place>> getFavoritePlaces() async {
    if (_currentUser == null) return [];

    try {
      return await _databaseService.getFavoritePlaces(_currentUser!.id);
    } catch (e) {
      debugPrint('Error getting favorite places: $e');
      return [];
    }
  }
}
