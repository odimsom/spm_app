import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/models/user.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'spm_app.db';
  static const int _dbVersion = 1;

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create places table
    await db.execute('''
      CREATE TABLE places (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        rating REAL NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        main_image_type TEXT NOT NULL,
        main_image_path TEXT NOT NULL,
        gallery_images TEXT NOT NULL,
        opening_hours TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        price_range TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        profile_image TEXT NOT NULL DEFAULT 'assets/images/profile.png',
        favorite_ids TEXT NOT NULL DEFAULT '[]',
        reservation_ids TEXT NOT NULL DEFAULT '[]',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // ✅ Crear tabla user_favorites (faltaba)
    await db.execute('''
      CREATE TABLE user_favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        place_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(user_id, place_id),
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (place_id) REFERENCES places (id)
      )
    ''');

    // Create reservations table
    await db.execute('''
      CREATE TABLE reservations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        place_id INTEGER NOT NULL,
        reservation_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        notes TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (place_id) REFERENCES places (id)
      )
    ''');

    // Create metadata table for tracking updates
    await db.execute('''
      CREATE TABLE metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Load initial data
    await _loadInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // For now, we'll just recreate the database
      await db.execute('DROP TABLE IF EXISTS places');
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS reservations');
      await db.execute('DROP TABLE IF EXISTS metadata');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _loadInitialData(Database db) async {
    try {
      // Load places from JSON
      String jsonString = await rootBundle.loadString(
        'assets/data/places.json',
      );
      List<dynamic> jsonData = json.decode(jsonString);

      // Check if data needs to be updated
      String? lastUpdated = await _getMetadata(db, 'places_last_updated');
      String currentDataHash = jsonString.hashCode.toString();

      if (lastUpdated != currentDataHash) {
        // Clear existing places and reload
        await db.delete('places');

        for (var placeJson in jsonData) {
          Place place = Place.fromJson(placeJson);
          await _insertPlace(db, place);
        }

        // Update metadata
        await _setMetadata(db, 'places_last_updated', currentDataHash);
      }

      // Create default user if not exists
      List<Map<String, dynamic>> users = await db.query('users', limit: 1);
      if (users.isEmpty) {
        // Insert default user
        int userId = await db.insert('users', {
          'name': 'Alberto Rojas',
          'email': 'user@spmapp.com',
          'profile_image': 'assets/images/profile.png',
          'favorite_ids':
              '[1, 2, 8]', // Museo Ron Barceló, Playa Juan Dolio, Laguna Mallén
          'reservation_ids': '[]',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Set some places as favorites
        await db.update('places', {'is_favorite': 1}, where: 'id IN (1, 2, 8)');

        // Create some default reservations
        DateTime now = DateTime.now();
        List<Map<String, dynamic>> defaultReservations = [
          {
            'user_id': userId,
            'place_id': 1, // Museo Ron Barceló
            'reservation_date': now.add(Duration(days: 3)).toIso8601String(),
            'status': 'confirmed',
            'notes': 'Visita familiar de fin de semana',
            'created_at': now.toIso8601String(),
          },
          {
            'user_id': userId,
            'place_id': 2, // Playa Juan Dolio
            'reservation_date': now.add(Duration(days: 7)).toIso8601String(),
            'status': 'pending',
            'notes': 'Día de playa y relajación',
            'created_at': now.toIso8601String(),
          },
          {
            'user_id': userId,
            'place_id': 5, // La Cueva de las Maravillas
            'reservation_date': now
                .subtract(Duration(days: 15))
                .toIso8601String(),
            'status': 'completed',
            'notes': 'Tour de aventura completado',
            'created_at': now.subtract(Duration(days: 20)).toIso8601String(),
          },
          {
            'user_id': userId,
            'place_id': 8, // Laguna Mallén
            'reservation_date': now.add(Duration(days: 14)).toIso8601String(),
            'status': 'confirmed',
            'notes': 'Observación de aves y naturaleza',
            'created_at': now.toIso8601String(),
          },
        ];

        for (var reservation in defaultReservations) {
          await db.insert('reservations', reservation);
        }
      }
    } catch (e) {
      // Use debugPrint instead of print for production code
      debugPrint('Error loading initial data: $e');
    }
  }

  Future<void> _insertPlace(Database db, Place place) async {
    await db.insert('places', {
      'id': place.id,
      'name': place.name,
      'description': place.description,
      'category': place.category,
      'latitude': 0.0, // ✅ Placeholder
      'longitude': 0.0, // ✅ Placeholder
      'rating': place.rating,
      'is_favorite': place.isFavorite ? 1 : 0,
      'main_image_type': place.mainImage.type,
      'main_image_path': place.mainImage.path,
      'gallery_images': json.encode(
        place.galleryImages.map((img) => img.toJson()).toList(),
      ),
      'opening_hours': place.openingHours,
      'phone': place.phone,
      'address': place.address,
      'price_range': place.priceRange,
      'updated_at': DateTime.now().toIso8601String(), // ✅ Usar DateTime.now()
    });
  }

  Future<String?> _getMetadata(Database db, String key) async {
    List<Map<String, dynamic>> result = await db.query(
      'metadata',
      where: 'key = ?',
      whereArgs: [key],
    );
    return result.isNotEmpty ? result.first['value'] : null;
  }

  Future<void> _setMetadata(Database db, String key, String value) async {
    await db.insert('metadata', {
      'key': key,
      'value': value,
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Places operations
  Future<List<Place>> getAllPlaces() async {
    try {
      final db = await database;
      final userId = await _getCurrentUserId();

      // Obtener lugares
      final List<Map<String, dynamic>> placesData = await db.query(
        'places',
        orderBy: 'name ASC',
      );

      // Obtener favoritos del usuario
      final List<Map<String, dynamic>> favoritesData = userId != null
          ? await db.query(
              'user_favorites',
              where: 'user_id = ?',
              whereArgs: [userId],
            )
          : [];

      final favoriteIds = favoritesData
          .map((f) => f['place_id'] as int)
          .toSet();

      // Convertir a Place con estado de favorito correcto
      return placesData.map((placeJson) {
        final placeId = placeJson['id'] as int;
        return Place.fromJson(
          placeJson,
          isFavorite: favoriteIds.contains(placeId),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting all places: $e');
      return [];
    }
  }

  Future<Place?> getPlace(int id) async {
    try {
      final db = await database;
      final userId = await _getCurrentUserId();

      final List<Map<String, dynamic>> maps = await db.query(
        'places',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;

      // Verificar si es favorito
      bool isFavorite = false;
      if (userId != null) {
        final favoriteCheck = await db.query(
          'user_favorites',
          where: 'user_id = ? AND place_id = ?',
          whereArgs: [userId, id],
        );
        isFavorite = favoriteCheck.isNotEmpty;
      }

      return Place.fromJson(maps.first, isFavorite: isFavorite);
    } catch (e) {
      debugPrint('Error getting place: $e');
      return null;
    }
  }

  // ✅ Agregar método getFavoritePlaces que faltaba
  Future<List<Place>> getFavoritePlaces(int userId) async {
    try {
      final db = await database;

      // Obtener IDs de favoritos del usuario
      final List<Map<String, dynamic>> favoritesData = await db.query(
        'user_favorites',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (favoritesData.isEmpty) return [];

      final favoriteIds = favoritesData
          .map((f) => f['place_id'] as int)
          .toList();

      // Obtener los lugares favoritos
      final placesData = await db.query(
        'places',
        where: 'id IN (${favoriteIds.join(',')})',
      );

      return placesData.map((placeJson) {
        return Place.fromJson(placeJson, isFavorite: true);
      }).toList();
    } catch (e) {
      debugPrint('Error getting favorite places: $e');
      return [];
    }
  }

  // User operations
  Future<User?> getUser(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        profileImage: maps[0]['profile_image'],
        favoriteIds: List<int>.from(json.decode(maps[0]['favorite_ids'])),
        reservationIds: List<int>.from(json.decode(maps[0]['reservation_ids'])),
        createdAt: DateTime.parse(maps[0]['created_at']),
        updatedAt: DateTime.parse(maps[0]['updated_at']),
      );
    }
    return null;
  }

  Future<User?> getCurrentUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        profileImage: maps[0]['profile_image'],
        favoriteIds: List<int>.from(json.decode(maps[0]['favorite_ids'])),
        reservationIds: List<int>.from(json.decode(maps[0]['reservation_ids'])),
        createdAt: DateTime.parse(maps[0]['created_at']),
        updatedAt: DateTime.parse(maps[0]['updated_at']),
      );
    }
    return null;
  }

  // Toggle favorito con persistencia correcta
  Future<void> toggleFavorite(int userId, int placeId) async {
    try {
      final db = await database;

      final existing = await db.query(
        'user_favorites',
        where: 'user_id = ? AND place_id = ?',
        whereArgs: [userId, placeId],
      );

      if (existing.isEmpty) {
        // Agregar a favoritos
        await db.insert('user_favorites', {
          'user_id': userId,
          'place_id': placeId,
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        // Quitar de favoritos
        await db.delete(
          'user_favorites',
          where: 'user_id = ? AND place_id = ?',
          whereArgs: [userId, placeId],
        );
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Reservation operations
  Future<int> createReservation(Reservation reservation) async {
    final db = await database;
    return await db.insert('reservations', reservation.toJson());
  }

  Future<List<Reservation>> getUserReservations(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reservations',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'reservation_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Reservation.fromJson(maps[i]);
    });
  }

  // User authentication methods
  Future<int> insertUser(User user) async {
    final db = await database;

    // Convertir el User a Map para insertarlo en la base de datos
    final userMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'profile_image': user.profileImage,
      'favorite_ids': json.encode(user.favoriteIds),
      'reservation_ids': json.encode(user.reservationIds),
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    };

    return await db.insert('users', userMap);
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        profileImage: maps[0]['profile_image'],
        favoriteIds: List<int>.from(
          json.decode(maps[0]['favorite_ids'] ?? '[]'),
        ),
        reservationIds: List<int>.from(
          json.decode(maps[0]['reservation_ids'] ?? '[]'),
        ),
        createdAt: DateTime.parse(maps[0]['created_at']),
        updatedAt: DateTime.parse(maps[0]['updated_at']),
      );
    }
    return null;
  }

  // Validar credenciales de usuario (simple validation for local development)
  Future<bool> validateUserCredentials(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user == null) return false;

    // For demo purposes, we'll use a simple validation
    // In production, you would hash the password and compare
    return email.isNotEmpty && password.length >= 6;
  }

  // Utility method to force reload data from JSON
  Future<void> forceReloadPlaces() async {
    final db = await database;
    await db.delete('places');
    await db.delete(
      'metadata',
      where: 'key = ?',
      whereArgs: ['places_last_updated'],
    );
    await _loadInitialData(db);
  }

  // ✅ Obtener ID del usuario actual
  Future<int?> _getCurrentUserId() async {
    try {
      final user = await getCurrentUser();
      return user?.id;
    } catch (e) {
      return null;
    }
  }
}
