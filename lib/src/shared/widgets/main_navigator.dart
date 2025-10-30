import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';
import 'package:spm/src/screens/favorites/new_favorites_screen.dart';
import 'package:spm/src/screens/home/home_screen.dart';
import 'package:spm/src/screens/reservations/reservations_screen.dart';
import 'package:spm/src/screens/profile/profile_screen.dart';
import 'package:spm/src/screens/settings/settings_screen.dart';
import 'package:spm/src/screens/search/search_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Crear las pantallas con el callback
    final List<Widget> screens = [
      HomeScreen(onNavigate: _onItemTapped), // Pasar el callback aquí
      const NewFavoritesScreen(),
      const SearchScreen(), // Tab oculto en índice 2
      const ReservationsScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: screens),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: AppConstants.elevationMd,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(size: AppConstants.iconSizeLg),
          unselectedIconTheme: const IconThemeData(
            size: AppConstants.iconSizeMd,
          ),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _getVisibleIndex(),
          onTap: (visibleIndex) => _onItemTapped(_getRealIndex(visibleIndex)),
          items: [
            _buildNavBarItem(Icons.home_filled, 0),
            _buildNavBarItem(Icons.favorite, 1),
            // SearchScreen no tiene botón visible (índice 2 oculto)
            _buildNavBarItem(Icons.event_note, 3),
            _buildNavBarItem(Icons.person, 4),
            _buildNavBarItem(Icons.settings, 5),
          ],
        ),
      ),
    );
  }

  // Mapeo de índices visibles a índices reales
  int _getVisibleIndex() {
    // Si estamos en search (índice 2), mostrar home activo en el bottom nav
    if (_selectedIndex == 2) return 0;
    // Ajustar índices después del tab oculto
    if (_selectedIndex > 2) return _selectedIndex - 1;
    return _selectedIndex;
  }

  int _getRealIndex(int visibleIndex) {
    // Mapear índices visibles a índices reales
    if (visibleIndex >= 2) return visibleIndex + 1;
    return visibleIndex;
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, int realIndex) {
    final bool isSelected = _selectedIndex == realIndex;
    return BottomNavigationBarItem(
      label: "",
      icon: Padding(
        padding: AppConstants.paddingSm,
        child: Icon(
          icon,
          color: isSelected ? Colors.red : Colors.grey,
          size: isSelected ? AppConstants.iconSizeLg : AppConstants.iconSizeMd,
        ),
      ),
    );
  }
}
