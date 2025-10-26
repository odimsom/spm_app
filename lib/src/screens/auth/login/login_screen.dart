import 'package:flutter/material.dart';
import 'package:spm/src/core/services/auth_service.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';
import 'package:spm/src/screens/auth/register/register_screen.dart';
import 'package:spm/src/shared/widgets/main_navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      setState(() {
        _fieldErrors.remove(field);
      });
    }
  }

  Future<void> _handleLogin() async {
    // Limpiar errores previos
    setState(() {
      _fieldErrors.clear();
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validar campos
    final validationErrors = _authService.validateLoginFields(email, password);

    if (validationErrors.isNotEmpty) {
      setState(() {
        _fieldErrors = validationErrors;
      });
      AppSnackBar.showError(
        context,
        'Por favor completa todos los campos correctamente',
      );
      return;
    }

    // Mostrar loading
    setState(() {
      _isLoading = true;
    });

    AppSnackBar.showLoading(context, 'Iniciando sesión...');

    try {
      final result = await _authService.login(email, password);

      if (mounted) {
        AppSnackBar.hide(context);

        if (result.success) {
          AppSnackBar.showSuccess(context, 'Sesión iniciada correctamente');

          // Navegar al main navigator después de un breve delay
          await Future.delayed(const Duration(milliseconds: 1500));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigator()),
            );
          }
        } else {
          String friendlyMessage =
              result.errorMessage ?? 'Credenciales incorrectas';
          if (friendlyMessage.contains('User not found') ||
              friendlyMessage.contains('usuario no encontrado')) {
            friendlyMessage =
                'No existe una cuenta con este correo electrónico';
          } else if (friendlyMessage.contains('password') ||
              friendlyMessage.contains('contraseña')) {
            friendlyMessage = 'La contraseña es incorrecta';
          }
          AppSnackBar.showError(context, friendlyMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.hide(context);
        AppSnackBar.showError(
          context,
          'Ocurrió un problema al iniciar sesión. Inténtalo de nuevo.',
        );
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo SVG como en imagen original
              Center(
                child: Image.asset(
                  'assets/images/spm_logo.svg',
                  height: 120,
                  width: 120,
                ),
              ),

              const SizedBox(height: 40),

              // Título como en imagen original
              const Text(
                'Iniciar sesión',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

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

              const SizedBox(height: 32),

              // Botón verde como en imagen original
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // Enlaces como en imagen original
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta? '),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.green,
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
