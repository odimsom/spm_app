import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/shared/widgets/new_place_card.dart';
import 'package:spm/src/screens/detail/new_view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';

class NewFavoritesScreen extends StatefulWidget {
  const NewFavoritesScreen({super.key});

  @override
  State<NewFavoritesScreen> createState() => _NewFavoritesScreenState();
}

class _NewFavoritesScreenState extends State<NewFavoritesScreen> {
  final SessionService _sessionService = SessionService();
  List<Place> _favoritePlaces = [];
  List<Place> _filteredPlaces = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _sessionService.getFavoritePlaces();
      setState(() {
        _favoritePlaces = favorites;
        _filteredPlaces = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cargando favoritos: $e')));
      }
    }
  }

  void _filterPlaces(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = _favoritePlaces;
      } else {
        _filteredPlaces = _favoritePlaces.where((place) {
          return place.name.toLowerCase().contains(query.toLowerCase()) ||
              place.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _toggleFavorite(Place place) async {
    try {
      await _sessionService.toggleFavorite(place.id);
      if (mounted) {
        AppSnackBar.showSuccess(context, 'Eliminado de favoritos');
        _loadFavorites(); // Reload to reflect changes
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Error al actualizar favoritos');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Mis Favoritos',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: AppResponsive.getResponsivePadding(context),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPlaces,
              decoration: InputDecoration(
                hintText: 'Buscar en favoritos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterPlaces('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPlaces.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadFavorites,
                    child: GridView.builder(
                      padding: AppResponsive.getResponsivePadding(context),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: AppResponsive.isMobile(context) ? 2 : 3,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: AppConstants.gridSpacing,
                        crossAxisSpacing: AppConstants.gridSpacing,
                      ),
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        return NewPlaceCard(
                          place: _filteredPlaces[index],
                          onTap: () =>
                              _navigateToDetail(_filteredPlaces[index]),
                          onFavorite: () =>
                              _toggleFavorite(_filteredPlaces[index]),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: AppConstants.iconSizeXl * 2,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: AppConstants.spacingLg),
          Text(
            _searchController.text.isNotEmpty
                ? 'No se encontraron favoritos'
                : 'No tienes lugares favoritos',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.spacingSm),
          Text(
            _searchController.text.isNotEmpty
                ? 'Intenta con otros términos de búsqueda'
                : 'Explora lugares y agrégalos a tus favoritos',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Place place) {
    final placeDetail = PlaceDetail(
      id: place.id,
      name: place.name,
      imagePath: place.mainImage.path,
      rating: place.rating,
      description: place.description,
      isFavorite: place.isFavorite,
      galleryImages: place.galleryImages.map((img) => img.path).toList(),
      additionalInfo: {
        'category': place.category,
        'opening_hours': place.openingHours,
        'phone': place.phone,
        'address': place.address,
        'price_range': place.priceRange,
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewViewDetailScreen(place: placeDetail),
      ),
    );
  }
}
