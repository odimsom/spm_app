import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Configuración',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppResponsive.getResponsivePadding(context),
          child: Column(
            children: [
              // Logo
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppConstants.spacingLg),
                child: SvgPicture.asset(
                  'assets/images/monument.svg',
                  height: AppConstants.logoSizeSmall,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/text_logo.svg',
                height: AppConstants.spacingSm,
              ),

              SizedBox(height: AppConstants.spacingXl),

              // Settings Options
              _buildSettingsSection(
                context: context,
                title: 'Cuenta',
                options: [
                  _SettingsOption(
                    icon: Icons.person_outline,
                    title: 'Perfil de usuario',
                    subtitle: 'Editar información personal',
                    onTap: () => _showNotImplemented(context),
                  ),
                  _SettingsOption(
                    icon: Icons.lock_outline,
                    title: 'Privacidad y seguridad',
                    subtitle: 'Cambiar contraseña y configuración',
                    onTap: () => _showNotImplemented(context),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingLg),

              _buildSettingsSection(
                context: context,
                title: 'Aplicación',
                options: [
                  _SettingsOption(
                    icon: Icons.notifications_none,
                    title: 'Notificaciones',
                    subtitle: 'Configurar alertas y recordatorios',
                    onTap: () => _showNotImplemented(context),
                  ),
                  _SettingsOption(
                    icon: Icons.language,
                    title: 'Idioma',
                    subtitle: 'Español (República Dominicana)',
                    onTap: () => _showNotImplemented(context),
                  ),
                  _SettingsOption(
                    icon: Icons.palette_outlined,
                    title: 'Tema',
                    subtitle: 'Personalizar apariencia',
                    onTap: () => _showNotImplemented(context),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingLg),

              _buildSettingsSection(
                context: context,
                title: 'Información',
                options: [
                  _SettingsOption(
                    icon: Icons.help_outline,
                    title: 'Ayuda y soporte',
                    subtitle: 'Preguntas frecuentes y contacto',
                    onTap: () => _showNotImplemented(context),
                  ),
                  _SettingsOption(
                    icon: Icons.info_outline,
                    title: 'Acerca de',
                    subtitle: 'Versión 0.1.0',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _SettingsOption(
                    icon: Icons.description_outlined,
                    title: 'Términos y condiciones',
                    subtitle: 'Políticas de uso',
                    onTap: () => _showNotImplemented(context),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingXl),

              // Logout Button
              Padding(
                padding: AppConstants.paddingHorizontalLg,
                child: SizedBox(
                  width: double.infinity,
                  height: AppConstants.buttonHeightMd,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                  ),
                ),
              ),

              SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required List<_SettingsOption> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppConstants.paddingHorizontalMd,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppConstants.spacingSm),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: options
                .map((option) => _buildSettingsOption(context, option))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOption(BuildContext context, _SettingsOption option) {
    return ListTile(
      leading: Container(
        width: AppConstants.iconSizeXl,
        height: AppConstants.iconSizeXl,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          option.icon,
          color: AppColors.primary,
          size: AppConstants.iconSizeMd,
        ),
      ),
      title: Text(
        option.title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: option.subtitle != null
          ? Text(
              option.subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: AppConstants.iconSizeSm,
      ),
      onTap: option.onTap,
    );
  }

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función no implementada'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de SPM App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rutas SPM'),
            SizedBox(height: AppConstants.spacingSm),
            const Text('Versión: 0.1.0'),
            SizedBox(height: AppConstants.spacingSm),
            const Text('App de turismo para San Pedro de Macorís.'),
            SizedBox(height: AppConstants.spacingMd),
            const Text(
              'Desarrollada para promover el turismo local y facilitar el descubrimiento de lugares emblemáticos.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

class _SettingsOption {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
