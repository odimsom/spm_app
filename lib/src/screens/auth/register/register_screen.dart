import 'package:flutter/material.dart';
import 'package:spm/src/core/services/auth_service.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';
import 'package:spm/src/shared/widgets/main_navigator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      setState(() {
        _fieldErrors.remove(field);
      });
    }
  }

  Future<void> _handleRegister() async {
    // Limpiar errores previos
    setState(() {
      _fieldErrors.clear();
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validar campos
    final validationErrors = _authService.validateRegisterFields(
      name,
      email,
      password,
    );

    // Validar confirmación de contraseña por separado
    if (password != confirmPassword) {
      validationErrors['confirmPassword'] = 'Las contraseñas no coinciden';
    }

    if (validationErrors.isNotEmpty) {
      setState(() {
        _fieldErrors = validationErrors;
      });
      AppSnackBar.showError(context, 'Completa todos los campos correctamente');
      return;
    }

    // Mostrar loading
    setState(() {
      _isLoading = true;
    });

    AppSnackBar.showLoading(context, 'Creando cuenta...');

    try {
      final result = await _authService.register(name, email, password);

      if (mounted) {
        AppSnackBar.hide(context);

        if (result.success) {
          AppSnackBar.showSuccess(context, 'Cuenta creada correctamente');

          // Navegar al main navigator después de un breve delay
          await Future.delayed(const Duration(milliseconds: 1500));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigator()),
            );
          }
        } else {
          AppSnackBar.showError(
            context,
            result.errorMessage ?? 'Error al crear la cuenta',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.hide(context);
        AppSnackBar.showError(context, 'Error inesperado: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo simple
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53E3E),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.location_city,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Título simple
              const Text(
                'Crear Cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Regístrate para comenzar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 48),

              // Campo nombre simple
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  hintText: 'Ingresa tu nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                  errorText: _fieldErrors['name'],
                ),
                onChanged: (_) => _clearFieldError('name'),
              ),

              const SizedBox(height: 20),

              // Campo de email simple
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Ingresa tu email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  errorText: _fieldErrors['email'],
                ),
                onChanged: (_) => _clearFieldError('email'),
              ),

              const SizedBox(height: 20),

              // Campo de contraseña simple
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Ingresa tu contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  errorText: _fieldErrors['password'],
                ),
                onChanged: (_) => _clearFieldError('password'),
              ),

              const SizedBox(height: 20),

              // Campo confirmar contraseña simple
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  hintText: 'Confirma tu contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  errorText: _fieldErrors['confirmPassword'],
                ),
                onChanged: (_) => _clearFieldError('confirmPassword'),
              ),

              const SizedBox(height: 32),

              // Botón de registro simple
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53E3E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              const SizedBox(height: 32),

              // Enlace a login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Inicia Sesión',
                      style: TextStyle(
                        color: Color(0xFFE53E3E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
