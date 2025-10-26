import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/screens/detail/view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Lista de lugares favoritos (simulada)
  final List<FavoritePlace> _favoritePlaces = [
    FavoritePlace(
      name: 'Malecón SPM',
      imagePath: 'assets/images/fotos/malecon.jpg',
      rating: 4.5,
    ),
    FavoritePlace(
      name: 'Cueva las Maravillas',
      imagePath: 'assets/images/fotos/La Cueva de las Maravillas.jpg',
      rating: 5.0,
    ),
    FavoritePlace(
      name: 'Museo Ron Barceló',
      imagePath:
          'assets/images/fotos/Museo de Historia de San Pedro de Macorís.jpg',
      rating: 4.8,
    ),
    FavoritePlace(
      name: 'Catedral San Pedro',
      imagePath: 'assets/images/fotos/Catedral San Pedro Apóstol.jpg',
      rating: 4.6,
    ),
    FavoritePlace(
      name: 'Playa Boca de Soco',
      imagePath: 'assets/images/fotos/Playa Boca de Soco.jpg',
      rating: 4.3,
    ),
    FavoritePlace(
      name: 'Metro Country',
      imagePath: 'assets/images/fotos/Metro Country Club.jpg',
      rating: 4.7,
    ),
    FavoritePlace(
      name: 'La Fuente de Oro',
      imagePath: 'assets/images/fotos/La Fuente de Oro.jpg',
      rating: 4.9,
    ),
    FavoritePlace(
      name: 'Museo SPM',
      imagePath:
          'assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg',
      rating: 4.4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar en favoritos...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Cuadrícula de lugares favoritos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _favoritePlaces.length,
              itemBuilder: (context, index) {
                final place = _favoritePlaces[index];
                return _buildFavoriteCard(place, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(FavoritePlace place, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalle
        final placeDetail = PlaceDetail(
          name: place.name,
          imagePath: place.imagePath,
          rating: place.rating,
          description:
              'Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad y les envolverán en un ambiente de descubrimiento. Además, tendrán oportunidad de adquirir nuestros productos y gama de artículos promocionales, para que puedan tener un delicioso recuerdo de la experiencia.',
          isFavorite: true,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailScreen(place: placeDetail),
          ),
        );
      },
      child: Stack(
        children: [
          // Fondo de la tarjeta
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del lugar
                  Stack(
                    children: [
                      // Imagen
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: Image.asset(
                          place.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade300,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                        ),
                      ),

                      // Degradado para legibilidad del texto
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
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
                      ),

                      // Nombre del lugar
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Botón de favorito
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            iconSize: 20,
                            onPressed: () {
                              // Mostrar un diálogo de confirmación para eliminar de favoritos
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Eliminar de favoritos'),
                                  content: Text(
                                    '¿Estás seguro que deseas eliminar ${place.name} de tus favoritos?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Aquí se implementaría la lógica para eliminar de favoritos
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${place.name} eliminado de favoritos',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Estrellas de valoración
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < place.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                        if (place.rating - place.rating.floor() >= 0.5)
                          const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para representar un lugar favorito
class FavoritePlace {
  final String name;
  final String imagePath;
  final double rating;

  FavoritePlace({
    required this.name,
    required this.imagePath,
    required this.rating,
  });
}
