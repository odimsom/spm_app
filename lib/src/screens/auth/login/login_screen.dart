import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spm/src/core/services/auth_service.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
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
    setState(() {
      _fieldErrors.clear();
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),

                // Logo y texto del monumento
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/monument.svg',
                      height: 150,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SvgPicture.asset(
                      'assets/images/text_logo.svg',
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        const Color(0xFF2C3E50),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Título "Iniciar Sesión"
                Text(
                  'Iniciar Sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 30),

                // Campo de email sin label, solo placeholder
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      errorText: _fieldErrors['email'],
                    ),
                    onChanged: (_) => _clearFieldError('email'),
                  ),
                ),

                const SizedBox(height: 16),

                // Campo de contraseña sin label, solo placeholder
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      errorText: _fieldErrors['password'],
                    ),
                    onChanged: (_) => _clearFieldError('password'),
                  ),
                ),

                const SizedBox(height: 8),

                // "¿Olvidaste tu contraseña?" con estilo de la imagen
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implementar recuperación de contraseña
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF757575),
                        ),
                        children: [
                          const TextSpan(text: '¿Haz olvidado tu contraseña? '),
                          TextSpan(
                            text: 'Ingresa aquí',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de Iniciar sesión (ancho ajustado)
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
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
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // "O continuar con:"
                const Text(
                  'O continuar con:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                ),

                const SizedBox(height: 20),

                // Iconos de redes sociales
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      icon: Icons.facebook,
                      color: const Color(0xFF1877F2),
                      onTap: () {
                        // TODO: Implementar login con Facebook
                      },
                    ),
                    const SizedBox(width: 20),
                    _SocialButton(
                      icon: Icons.fingerprint,
                      color: const Color(0xFF4CAF50),
                      onTap: () {
                        // TODO: Implementar login con huella
                      },
                    ),
                    const SizedBox(width: 20),
                    _SocialButton(
                      // Puedes usar un asset SVG aquí si tienes el logo de Google
                      icon: Icons.g_mobiledata,
                      color: const Color(0xFFDB4437),
                      onTap: () {
                        // TODO: Implementar login con Google
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // "¿No tienes cuenta? Crea una"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Crea una',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para los botones de redes sociales
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
