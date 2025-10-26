import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/screens/detail/view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

import 'package:spm/src/screens/favorites/new_favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page?.round() ?? 0;
      if (page != _currentPageIndex) {
        setState(() {
          _currentPageIndex = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'San Pedro de Macorís',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de búsqueda en desarrollo'),
                ),
              );
            },
            icon: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  _buildFeaturedPlace(
                    'Museo Ron Barceló',
                    'assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg',
                    4.5,
                    true,
                  ),
                  _buildFeaturedPlace(
                    'Playa Juan Dolio',
                    'assets/images/fotos/Playa Juan Dolio.webp',
                    4.0,
                    false,
                  ),
                ],
              ),
            ),

            // Indicadores de página
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2, // Exactamente 2 indicadores para 2 páginas
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPageIndex
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),

            // Sección de recomendados
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recomendados',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver más',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // Grid de lugares recomendados
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.0, // Forma cuadrada
              padding: const EdgeInsets.symmetric(horizontal: 16),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildPlaceCard(
                  'Laguna de Nisibon',
                  'assets/images/fotos/Laguna mallen/Laguna mallen.jpg',
                  5.0,
                  false,
                ),
                _buildPlaceCard(
                  'Malecón SPM',
                  'assets/images/fotos/malecon.jpg',
                  4.5,
                  false,
                ),
                _buildPlaceCard(
                  'Playa Juan Dolio',
                  'assets/images/fotos/Playa Juan Dolio.webp',
                  4.0,
                  false,
                ),
                _buildPlaceCard(
                  'Cueva las Maravillas',
                  'assets/images/fotos/La Cueva de las Maravillas.jpg',
                  4.5,
                  true,
                ),
                _buildPlaceCard(
                  'Museo Ron Barceló',
                  'assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg',
                  5.0,
                  true,
                ),
                _buildPlaceCard(
                  'Campo Azul',
                  'assets/images/fotos/campo azul.jpg',
                  4.0,
                  false,
                ),
              ],
            ),

            // Espacio adicional al final para evitar que el último elemento sea cortado por la navegación
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Método para construir un lugar destacado en el carrusel principal
  Widget _buildFeaturedPlace(
    String name,
    String imagePath,
    double rating,
    bool isFavorite,
  ) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalle
        final place = PlaceDetail(
          name: name,
          imagePath: imagePath,
          rating: rating,
          description:
              'Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad y les envolverán en un ambiente de descubrimiento. Además, tendrán oportunidad de adquirir nuestros productos y gama de artículos promocionales, para que puedan tener un delicioso recuerdo de la experiencia.',
          isFavorite: isFavorite,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailScreen(place: place),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1.0, // Forma cuadrada perfecta
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Imagen del lugar que cubre toda la tarjeta
                Image.asset(
                  imagePath,
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

                // Gradiente sutil solo en la parte inferior para legibilidad
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),

                // Nombre del lugar en la parte inferior
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 60, // Espacio para corazón
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Estrellas de rating en la parte superior izquierda
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Botón de corazón favorito en la parte superior derecha
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey.shade600,
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewFavoritesScreen(),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir una tarjeta de lugar en la cuadrícula
  Widget _buildPlaceCard(
    String name,
    String imagePath,
    double rating,
    bool isFavorite,
  ) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalle
        final place = PlaceDetail(
          name: name,
          imagePath: imagePath,
          rating: rating,
          description:
              'Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad y les envolverán en un ambiente de descubrimiento. Además, tendrán oportunidad de adquirir nuestros productos y gama de artículos promocionales, para que puedan tener un delicioso recuerdo de la experiencia.',
          isFavorite: isFavorite,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailScreen(place: place),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen del lugar
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.image_not_supported,
                  size: 30,
                  color: Colors.grey[500],
                ),
              ),
            ),

            // Degradado para mejor legibilidad del texto
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // Información del lugar
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 12,
                        ),
                      ),
                      if (rating - rating.floor() >= 0.5)
                        const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                          size: 12,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Botón de favorito
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewFavoritesScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
