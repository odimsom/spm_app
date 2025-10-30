import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';
import 'package:spm/src/core/models/user.dart';
import 'package:spm/src/core/services/places_service.dart';
import 'package:spm/src/core/services/auth_service.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';
import 'package:spm/src/screens/auth/login/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
// ✅ Agregar dependencia para seleccionar imagen (agregar a pubspec.yaml si no existe)
// import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final SessionService _sessionService = SessionService();
  // final ImagePicker _picker = ImagePicker(); // ✅ Descomentar cuando agregues image_picker

  User? _currentUser;
  bool _isLoading = true;
  File? _selectedImage; // ✅ Imagen seleccionada localmente

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

  // ✅ Método para seleccionar imagen
  Future<void> _pickImage() async {
    try {
      // TODO: Descomentar cuando agregues image_picker a pubspec.yaml
      /*
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        if (mounted) {
          AppSnackBar.showSuccess(context, 'Imagen seleccionada correctamente');
        }

        // TODO: Aquí puedes subir la imagen a un servidor o guardarla localmente
        // await _uploadProfileImage(_selectedImage!);
      }
      */

      // Placeholder mientras tanto
      if (mounted) {
        AppSnackBar.showInfo(
          context,
          'Función de cambio de imagen próximamente',
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Error al seleccionar imagen');
      }
    }
  }

  // ✅ Método para cambiar nombre (ya existente, mejorado)
  Future<void> _showChangeNameDialog() async {
    final TextEditingController nameController = TextEditingController(
      text: _currentUser?.name ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cambiar nombre'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nuevo nombre',
            hintText: 'Ingresa tu nuevo nombre',
            prefixIcon: Icon(Icons.person_outline),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != _currentUser?.name) {
      if (mounted) {
        AppSnackBar.showLoading(context, 'Actualizando nombre...');
      }

      try {
        if (_currentUser != null) {
          final updatedUser = User(
            id: _currentUser!.id,
            name: result,
            email: _currentUser!.email,
            profileImage: _currentUser!.profileImage,
            favoriteIds: _currentUser!.favoriteIds,
            reservationIds: _currentUser!.reservationIds,
            createdAt: _currentUser!.createdAt,
            updatedAt: DateTime.now(),
          );
          await _sessionService.updateUser(updatedUser);

          setState(() {
            _currentUser = updatedUser;
          });

          if (mounted) {
            AppSnackBar.hide(context);
            AppSnackBar.showSuccess(
              context,
              'Nombre actualizado correctamente',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          AppSnackBar.hide(context);
          AppSnackBar.showError(context, 'Error al actualizar el nombre');
        }
      }
    }
  }

  // ✅ Nuevo método para cambiar contraseña
  Future<void> _showChangePasswordDialog() async {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña actual',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu contraseña actual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa una nueva contraseña';
                  }
                  if (value.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      AppSnackBar.showSuccess(context, 'Contraseña actualizada correctamente');
      // TODO: En producción, aquí se implementaría el cambio real de contraseña
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
              // Logo section
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

              // ✅ Profile picture with edit button
              Expanded(
                flex: 2,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ✅ Imagen de perfil con botón de edición
                          Stack(
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
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/profile.png',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                child: Icon(
                                                  Icons.person,
                                                  size: availableHeight * 0.06,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                        ),
                                ),
                              ),
                              // ✅ Botón de editar imagen
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppConstants.spacingMd),
                          // ✅ Nombre del usuario desde la sesión
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
                      onTap: _showChangePasswordDialog,
                    ),
                    _buildProfileOption(
                      context: context,
                      icon: Icons.edit_outlined,
                      text: 'Cambiar nombre',
                      onTap: _showChangeNameDialog,
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
