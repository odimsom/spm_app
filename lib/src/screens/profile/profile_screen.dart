import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';
import 'package:spm/src/core/models/user.dart';
import 'package:spm/src/core/services/places_service.dart';
import 'package:spm/src/core/services/auth_service.dart';
import 'package:spm/src/screens/auth/login/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight =
        screenHeight -
        MediaQuery.of(context).padding.top -
        kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Perfil',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppResponsive.getResponsivePadding(context),
          child: Column(
            children: [
              // Logo section - reduced size
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/monument.svg',
                      height: availableHeight * 0.12,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: AppConstants.spacingSm),
                    SvgPicture.asset(
                      'assets/images/text_logo.svg',
                      height: AppConstants.spacingSm,
                    ),
                  ],
                ),
              ),

              // Profile picture and name section
              Expanded(
                flex: 2,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: availableHeight * 0.12,
                            height: availableHeight * 0.12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profile.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      child: Icon(
                                        Icons.person,
                                        size: availableHeight * 0.06,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppConstants.spacingMd),
                          Text(
                            _currentUser?.name ?? 'Usuario',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (_currentUser?.email != null) ...[
                            SizedBox(height: AppConstants.spacingXs),
                            Text(
                              _currentUser!.email,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
              ),

              // Options section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfileOption(
                      context: context,
                      icon: Icons.lock_outline,
                      text: 'Cambiar contraseña',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función no implementada'),
                          ),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context: context,
                      icon: Icons.edit_outlined,
                      text: 'Cambiar nombre',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función no implementada'),
                          ),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context: context,
                      icon: Icons.logout,
                      text: 'Cerrar sesión',
                      onTap: _showLogoutDialog,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesión cerrada exitosamente')),
        );

        // Esperar un poco para que se vea el mensaje
        await Future.delayed(const Duration(milliseconds: 1000));

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al cerrar sesión')));
      }
    }
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 24.0),
            child: Divider(color: Colors.grey.shade300, height: 1),
          ),
      ],
    );
  }
}
