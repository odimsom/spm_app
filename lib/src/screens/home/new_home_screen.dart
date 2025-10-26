import 'package:flutter/material.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/services/places_service.dart';
import 'package:spm/src/shared/widgets/new_place_card.dart';
import 'package:spm/src/screens/detail/new_view_detail_screen.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';
import 'package:spm/src/core/models/place_detail.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final PlacesService _placesService = PlacesService();
  List<Place> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Cargar lugares recomendados - funciona con el servicio existente
      final places = await _placesService.getRecommendedPlaces();

      if (mounted) {
        setState(() {
          _places = places;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(Place place) async {
    try {
      await _placesService.toggleFavorite(1, place.id); // Usando userId temporal
      if (mounted) {
        AppSnackBar.showSuccess(
          context,
          place.isFavorite ? 'Eliminado de favoritos' : 'Agregado a favoritos',
        );
        _loadPlaces();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'San Pedro de Macorís',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPlaces,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _places.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.explore_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay lugares disponibles',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _places.length,
                        itemBuilder: (context, index) {
                          final place = _places[index];
                          return NewPlaceCard(
                            place: place,
                            onFavorite: () => _toggleFavorite(place),
                            onTap: () => _navigateToDetail(place),
                          );
                        },
                      ),
              ),
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
        'address': place.address,
        'phone': place.phone,
        'openingHours': place.openingHours,
        'priceRange': place.priceRange,
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
