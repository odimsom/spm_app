import 'package:spm/src/core/services/database_service.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/core/models/user.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();
  final SessionService _sessionService = SessionService();

  // Validar campos de login
  Map<String, String?> validateLoginFields(String email, String password) {
    Map<String, String?> errors = {};

    if (email.isEmpty) {
      errors['email'] = 'El correo es requerido';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Ingresa un correo válido';
    }

    if (password.isEmpty) {
      errors['password'] = 'La contraseña es requerida';
    } else if (password.length < 6) {
      errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
    }

    return errors;
  }

  // Validar campos de registro
  Map<String, String?> validateRegisterFields(
    String name,
    String email,
    String password,
  ) {
    Map<String, String?> errors = {};

    if (name.isEmpty) {
      errors['name'] = 'El nombre es requerido';
    } else if (name.length < 2) {
      errors['name'] = 'El nombre debe tener al menos 2 caracteres';
    }

    if (email.isEmpty) {
      errors['email'] = 'El correo es requerido';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Ingresa un correo válido';
    }

    if (password.isEmpty) {
      errors['password'] = 'La contraseña es requerida';
    } else if (password.length < 6) {
      errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
    }

    return errors;
  }

  // Iniciar sesión
  Future<AuthResult> login(String email, String password) async {
    try {
      // Verificar credenciales
      final isValidCredentials = await _databaseService.validateUserCredentials(
        email,
        password,
      );

      if (isValidCredentials) {
        final user = await _databaseService.getUserByEmail(email);
        if (user != null) {
          await _sessionService.login(user);
          return AuthResult(success: true, user: user);
        }
      }

      return AuthResult(
        success: false,
        errorMessage: 'Credenciales incorrectas',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Error al iniciar sesión: ${e.toString()}',
      );
    }
  }

  // Registrar usuario
  Future<AuthResult> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Verificar si el usuario ya existe
      final existingUser = await _databaseService.getUserByEmail(email);

      if (existingUser != null) {
        return AuthResult(
          success: false,
          errorMessage: 'Ya existe una cuenta con este correo',
        );
      }

      // Crear nuevo usuario
      final now = DateTime.now();
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        email: email,
        profileImage: 'assets/images/profile.png',
        favoriteIds: [],
        reservationIds: [],
        createdAt: now,
        updatedAt: now,
      );

      await _databaseService.insertUser(newUser);
      await _sessionService.login(newUser);

      return AuthResult(success: true, user: newUser);
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Error al registrar usuario: ${e.toString()}',
      );
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _sessionService.logout();
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? errorMessage;

  AuthResult({required this.success, this.user, this.errorMessage});
}
