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
  String _searchQuery = "";
  final List<String> _recentSearches = ["Playa", "Museo", "Restaurante"];

  final List<PlaceCategory> _categories = [
    PlaceCategory(
      name: "Lugares de interés",
      places: [
        PlaceInfo(
          name: "Laguna de Nisibon",
          imagePath: "assets/images/fotos/Laguna mallen/Laguna mallen.jpg",
          rating: 4.8,
          isFavorite: true,
        ),
        PlaceInfo(
          name: "Playa de Guayacanes",
          imagePath: "assets/images/fotos/Playa Guayacanes.jpg",
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
          imagePath: "assets/images/fotos/Playa Juan Dolio.webp",
          rating: 4.5,
          isFavorite: true,
        ),
      ],
    ),
    PlaceCategory(
      name: "Museos",
      places: [
        PlaceInfo(
          name: "Museo Ron Barceló",
          imagePath:
              "assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg",
          rating: 4.7,
          isFavorite: true,
        ),
      ],
    ),
    PlaceCategory(
      name: "Ecoturismo",
      places: [
        PlaceInfo(
          name: "Cueva las Maravillas",
          imagePath: "assets/images/fotos/La Cueva de las Maravillas.jpg",
          rating: 4.9,
          isFavorite: true,
        ),
        PlaceInfo(
          name: "Campo Azul",
          imagePath: "assets/images/fotos/campo azul.jpg",
          rating: 4.3,
          isFavorite: false,
        ),
      ],
    ),
    PlaceCategory(
      name: "Sitios históricos",
      places: [
        PlaceInfo(
          name: "Malecón SPM",
          imagePath: "assets/images/fotos/malecon.jpg",
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: false,
            decoration: InputDecoration(
              hintText: "Buscar lugares...",
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade600),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(color: Colors.black87, fontSize: 15),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Búsquedas recientes
            if (_searchQuery.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
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
              const SizedBox(height: 24),
            ],

            // Resultados
            ..._buildSearchResults(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    if (_filteredCategories.isEmpty && _searchQuery.isNotEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "No se encontraron resultados",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return _filteredCategories.map((category) {
      return _buildCategorySection(category);
    }).toList();
  }

  Widget _buildCategorySection(PlaceCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            itemCount: category.places.length,
            itemBuilder: (context, index) {
              final place = category.places[index];
              return _buildPlaceCard(place);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlaceCard(PlaceInfo place) {
    return GestureDetector(
      onTap: () {
        if (_searchQuery.isNotEmpty &&
            !_recentSearches.contains(_searchQuery)) {
          setState(() {
            _recentSearches.insert(0, _searchQuery);
            if (_recentSearches.length > 5) {
              _recentSearches.removeLast();
            }
          });
        }

        final placeDetail = PlaceDetail(
          id: place.id,
          name: place.name,
          imagePath: place.imagePath,
          rating: place.rating,
          description:
              "Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad.",
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
        margin: const EdgeInsets.only(right: 12),
        width: 160,
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
                place.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ],
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < place.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    place.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: place.isFavorite ? Colors.red : Colors.grey.shade600,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class PlaceCategory {
  final String name;
  final List<PlaceInfo> places;

  PlaceCategory({required this.name, required this.places});
}
