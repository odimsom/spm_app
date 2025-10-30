import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/services/places_service.dart'; // ✅ Agregar
import 'package:spm/src/core/models/place.dart'; // ✅ Agregar
import 'package:spm/src/screens/detail/view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';
import 'package:spm/src/screens/favorites/new_favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _carouselController;
  int _currentCarouselPage = 0;
  Timer? _autoScrollTimer;

  // ✅ Cambiar a usar Place real de SQLite
  List<Place> _featuredPlaces = [];
  List<Place> _recommendedPlaces = [];
  bool _isLoading = true;
  final PlacesService _placesService = PlacesService();

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    // ✅ Cargar datos desde SQLite
    _loadPlaces();

    _carouselController.addListener(() {
      if (_carouselController.hasClients) {
        int page = _carouselController.page?.round() ?? 0;
        int actualPage =
            page % (_featuredPlaces.isEmpty ? 1 : _featuredPlaces.length);
        if (actualPage != _currentCarouselPage) {
          setState(() {
            _currentCarouselPage = actualPage;
          });
        }
      }
    });
  }

  // ✅ Nuevo método para cargar desde SQLite
  Future<void> _loadPlaces() async {
    try {
      final featured = await _placesService.getFeaturedPlaces(limit: 2);
      final recommended = await _placesService.getRecommendedPlaces(limit: 6);

      setState(() {
        _featuredPlaces = featured;
        _recommendedPlaces = recommended;
        _isLoading = false;
      });

      // Iniciar auto-scroll solo si hay lugares
      if (_featuredPlaces.isNotEmpty) {
        _startAutoScroll();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cargando lugares: $e')));
      }
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_carouselController.hasClients && _featuredPlaces.isNotEmpty) {
        int nextPage = (_carouselController.page?.toInt() ?? 0) + 1;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SPM',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.onNavigate != null) {
                widget.onNavigate!(2);
              }
            },
            icon: const Icon(Icons.search, color: Colors.black87),
            tooltip: 'Buscar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              slivers: [
                // Carrusel automático
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      if (_featuredPlaces.isNotEmpty)
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _carouselController,
                            itemCount: _featuredPlaces.length * 1000,
                            onPageChanged: (index) {
                              setState(() {
                                _currentCarouselPage =
                                    index % _featuredPlaces.length;
                              });
                            },
                            itemBuilder: (context, index) {
                              final place =
                                  _featuredPlaces[index %
                                      _featuredPlaces.length];
                              return _buildCarouselCard(place);
                            },
                          ),
                        ),

                      // Indicadores de página
                      if (_featuredPlaces.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _featuredPlaces.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentCarouselPage
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Header de recomendados
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recomendados',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.onNavigate != null) {
                              widget.onNavigate!(2);
                            }
                          },
                          child: Text(
                            'Ver más',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid de lugares recomendados
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final place = _recommendedPlaces[index];
                      return _buildPlaceCard(place);
                    }, childCount: _recommendedPlaces.length),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCarouselCard(Place place) {
    return GestureDetector(
      onTap: () => _navigateToDetail(place),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen
              Image.asset(
                place.mainImage.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey[500],
                  ),
                ),
              ),

              // Gradiente
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),

              // Contenido
              Positioned(
                bottom: 12,
                left: 12,
                right: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(place.rating, size: 18),
                  ],
                ),
              ),

              // Favorito
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewFavoritesScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      place.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: place.isFavorite
                          ? Colors.red
                          : Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceCard(Place place) {
    return GestureDetector(
      onTap: () => _navigateToDetail(place),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                place.mainImage.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey[500],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(place.rating, size: 14),
                  ],
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewFavoritesScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      place.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: place.isFavorite
                          ? Colors.red
                          : Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index < rating && rating % 1 >= 0.5) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.grey.shade400,
            size: size,
          );
        }
      }),
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
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailScreen(place: placeDetail),
      ),
    );
  }
}
