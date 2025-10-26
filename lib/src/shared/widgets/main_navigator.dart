import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';
import 'package:spm/src/screens/favorites/new_favorites_screen.dart';
import 'package:spm/src/screens/home/new_home_screen.dart';
import 'package:spm/src/screens/reservations/reservations_screen.dart';
import 'package:spm/src/screens/profile/profile_screen.dart';
import 'package:spm/src/screens/settings/settings_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NewHomeScreen(),
    const NewFavoritesScreen(),
    const ReservationsScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _screens),
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
          selectedItemColor: Colors.red, // Solo el ícono es rojo
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(size: AppConstants.iconSizeLg),
          unselectedIconTheme: const IconThemeData(
            size: AppConstants.iconSizeMd,
          ),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            _buildNavBarItem(Icons.home_filled, 0),
            _buildNavBarItem(Icons.favorite, 1),
            _buildNavBarItem(Icons.event_note, 2),
            _buildNavBarItem(Icons.person, 3),
            _buildNavBarItem(Icons.settings, 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      label: "",
      icon: Padding(
        padding: AppConstants.paddingSm,
        child: Icon(
          icon,
          color: isSelected
              ? Colors.red
              : Colors.grey, // Solo el ícono cambia a rojo
          size: isSelected ? AppConstants.iconSizeLg : AppConstants.iconSizeMd,
        ),
      ),
    );
  }
}
