import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/screens/detail/view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  final List<String> _recentSearches = ["Playa", "Museo", "Restaurante"];

  final List<PlaceCategory> _categories = [
    PlaceCategory(
      name: "Lugares de interés",
      places: [
        PlaceInfo(
          name: "Laguna de Nisibon",
          imagePath: "assets/images/laguna_nisibon.jpg",
          rating: 4.8,
          isFavorite: true,
        ),
        PlaceInfo(
          name: "Playa de Guayacanes",
          imagePath: "assets/images/playa_guayacanes.jpg",
          rating: 4.6,
          isFavorite: false,
        ),
      ],
    ),
    PlaceCategory(
      name: "Playas cercanas",
      places: [
        PlaceInfo(
          name: "Playa Juan Dolio",
          imagePath: "assets/images/playa_juan_dolio.jpg",
          rating: 4.5,
          isFavorite: true,
        ),
        PlaceInfo(
          name: "Playa Guayacanes",
          imagePath: "assets/images/playa_guayacanes.jpg",
          rating: 4.2,
          isFavorite: false,
        ),
      ],
    ),
    PlaceCategory(
      name: "Museos",
      places: [
        PlaceInfo(
          name: "Museo Ron Barceló",
          imagePath: "assets/images/museo_ron_barcelo.jpg",
          rating: 4.7,
          isFavorite: true,
        ),
        PlaceInfo(
          name: "Museo del Deporte",
          imagePath: "assets/images/museo_deporte.jpg",
          rating: 4.0,
          isFavorite: false,
        ),
      ],
    ),
    PlaceCategory(
      name: "Ecoturismo",
      places: [
        PlaceInfo(
          name: "Cueva las Maravillas",
          imagePath: "assets/images/cueva_maravillas.jpg",
          rating: 4.9,
          isFavorite: true,
        ),
        PlaceInfo(
          name: "Campo Azul",
          imagePath: "assets/images/campo_azul.jpg",
          rating: 4.3,
          isFavorite: false,
        ),
      ],
    ),
    PlaceCategory(
      name: "Sitios históricos",
      places: [
        PlaceInfo(
          name: "Ingenio Santa Fe",
          imagePath: "assets/images/ingenio_santa_fe.jpg",
          rating: 4.4,
          isFavorite: false,
        ),
        PlaceInfo(
          name: "Malecón SPM",
          imagePath: "assets/images/malecon_spm.jpg",
          rating: 4.5,
          isFavorite: true,
        ),
      ],
    ),
  ];

  List<PlaceCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;

    return _categories
        .map((category) {
          final filteredPlaces = category.places
              .where(
                (place) => place.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

          return PlaceCategory(name: category.name, places: filteredPlaces);
        })
        .where((category) => category.places.isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Buscar lugares...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text(
                "Buscar",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
                _searchQuery = "";
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.clear : Icons.search,
              color: Colors.grey.shade700,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = "";
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de búsquedas recientes
            if (_searchQuery.isEmpty && !_isSearching) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Búsquedas recientes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _recentSearches.map((search) {
                    return Chip(
                      label: Text(search),
                      backgroundColor: Colors.grey.shade200,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _recentSearches.remove(search);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Resultados de búsqueda
            ..._buildSearchResults(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    // Si no hay búsqueda activa, mostrar todas las categorías
    if (_searchQuery.isEmpty && !_isSearching) {
      return _filteredCategories.map((category) {
        return _buildCategorySection(category);
      }).toList();
    }

    // Si hay búsqueda activa pero sin resultados
    if (_filteredCategories.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              "No se encontraron resultados para tu búsqueda",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    // Mostrar resultados de búsqueda
    return _filteredCategories.map((category) {
      return _buildCategorySection(category);
    }).toList();
  }

  Widget _buildCategorySection(PlaceCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Ver más",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: category.places.length,
            itemBuilder: (context, index) {
              final place = category.places[index];
              return _buildPlaceCard(place);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(PlaceInfo place) {
    return GestureDetector(
      onTap: () {
        // Guardar la búsqueda si es relevante
        if (_isSearching && _searchQuery.isNotEmpty) {
          if (!_recentSearches.contains(_searchQuery)) {
            setState(() {
              _recentSearches.insert(0, _searchQuery);
              if (_recentSearches.length > 5) {
                _recentSearches.removeLast();
              }
            });
          }
        }

        // Navegar a la pantalla de detalle
        final placeDetail = PlaceDetail(
          id: place.id,
          name: place.name,
          imagePath: place.imagePath,
          rating: place.rating,
          description:
              "Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad y les envolverán en un ambiente de descubrimiento. Además, tendrán oportunidad de adquirir nuestros productos y gama de artículos promocionales, para que puedan tener un delicioso recuerdo de la experiencia.",
          isFavorite: place.isFavorite,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailScreen(place: placeDetail),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen del lugar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: place.imagePath.startsWith('assets/')
                  ? Image.asset(
                      place.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Imagen no disponible',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Image.network(
                      place.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Imagen no disponible',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            // Gradiente para mejor legibilidad
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
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
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < place.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 12,
                        ),
                      ),
                      if (place.rating - place.rating.floor() >= 0.5)
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
                child: Icon(
                  place.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: place.isFavorite ? Colors.red : Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Clase para manejar la información de cada lugar en la búsqueda
class PlaceInfo {
  final int id;
  final String name;
  final String imagePath;
  final double rating;
  final bool isFavorite;

  PlaceInfo({
    int? id,
    required this.name,
    required this.imagePath,
    required this.rating,
    this.isFavorite = false,
  }) : id = id ?? name.hashCode.abs();
}

// Clase para manejar categorías de lugares
class PlaceCategory {
  final String name;
  final List<PlaceInfo> places;

  PlaceCategory({required this.name, required this.places});
}
