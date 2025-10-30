import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
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

  // Lugares para el carrusel (los mismos que tenías)
  final List<Map<String, dynamic>> _featuredPlaces = [
    {
      'name': 'Museo Ron Barceló',
      'imagePath':
          'assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg',
      'rating': 4.5,
      'isFavorite': true,
    },
    {
      'name': 'Playa Juan Dolio',
      'imagePath': 'assets/images/fotos/Playa Juan Dolio.webp',
      'rating': 4.0,
      'isFavorite': false,
    },
  ];

  // Lugares recomendados (los mismos que tenías)
  final List<Map<String, dynamic>> _recommendedPlaces = [
    {
      'name': 'Laguna de Mallen',
      'imagePath': 'assets/images/fotos/Laguna mallen/Laguna mallen.jpg',
      'rating': 5.0,
      'isFavorite': false,
    },
    {
      'name': 'Malecón SPM',
      'imagePath': 'assets/images/fotos/malecon.jpg',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Playa Juan Dolio',
      'imagePath': 'assets/images/fotos/Playa Juan Dolio.webp',
      'rating': 4.0,
      'isFavorite': false,
    },
    {
      'name': 'Cueva las Maravillas',
      'imagePath': 'assets/images/fotos/La Cueva de las Maravillas.jpg',
      'rating': 4.5,
      'isFavorite': true,
    },
    {
      'name': 'Museo Ron Barceló',
      'imagePath':
          'assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg',
      'rating': 5.0,
      'isFavorite': true,
    },
    {
      'name': 'Campo Azul',
      'imagePath': 'assets/images/fotos/campo azul.jpg',
      'rating': 4.0,
      'isFavorite': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(
      viewportFraction: 0.85, // Muestra 1 card + medio del siguiente
      initialPage: 0,
    );
    _startAutoScroll();

    _carouselController.addListener(() {
      if (_carouselController.hasClients) {
        int page = _carouselController.page?.round() ?? 0;
        int actualPage = page % _featuredPlaces.length;
        if (actualPage != _currentCarouselPage) {
          setState(() {
            _currentCarouselPage = actualPage;
          });
        }
      }
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_carouselController.hasClients) {
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
                widget.onNavigate!(2); // Navegar a SearchScreen
              }
            },
            icon: const Icon(Icons.search, color: Colors.black87),
            tooltip: 'Buscar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Carrusel automático con scroll infinito
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _carouselController,
                    itemCount: _featuredPlaces.length * 1000, // Scroll infinito
                    onPageChanged: (index) {
                      setState(() {
                        _currentCarouselPage = index % _featuredPlaces.length;
                      });
                    },
                    itemBuilder: (context, index) {
                      final place =
                          _featuredPlaces[index % _featuredPlaces.length];
                      return _buildCarouselCard(place);
                    },
                  ),
                ),

                // Indicadores de página
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
                        margin: const EdgeInsets.symmetric(horizontal: 4),
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
                        widget.onNavigate!(2); // Navegar a SearchScreen
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

          // Grid de lugares recomendados (lazy loading)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

  Widget _buildCarouselCard(Map<String, dynamic> place) {
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
                place['imagePath'],
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

              // Gradiente oscuro en la parte inferior
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

              // Contenido inferior izquierdo (nombre y estrellas)
              Positioned(
                bottom: 12,
                left: 12,
                right: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(place['rating'], size: 18),
                  ],
                ),
              ),

              // Corazón de favorito (superior derecho)
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
                      place['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: place['isFavorite']
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

  Widget _buildPlaceCard(Map<String, dynamic> place) {
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
              // Imagen
              Image.asset(
                place['imagePath'],
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

              // Gradiente oscuro
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

              // Contenido inferior izquierdo
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(place['rating'], size: 14),
                  ],
                ),
              ),

              // Corazón de favorito
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
                      place['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: place['isFavorite']
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

  // Widget para construir las estrellas visuales
  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // Estrella llena
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index < rating && rating % 1 >= 0.5) {
          // Media estrella
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          // Estrella vacía
          return Icon(
            Icons.star_border,
            color: Colors.grey.shade400,
            size: size,
          );
        }
      }),
    );
  }

  void _navigateToDetail(Map<String, dynamic> place) {
    final placeDetail = PlaceDetail(
      name: place['name'],
      imagePath: place['imagePath'],
      rating: place['rating'],
      description:
          'Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad y les envolverán en un ambiente de descubrimiento.',
      isFavorite: place['isFavorite'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailScreen(place: placeDetail),
      ),
    );
  }
}
