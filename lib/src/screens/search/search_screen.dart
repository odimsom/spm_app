import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/services/places_service.dart'; // ✅ Agregar
import 'package:spm/src/core/models/place.dart'; // ✅ Agregar
import 'package:spm/src/screens/detail/view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PlacesService _placesService = PlacesService();

  String _searchQuery = "";
  final List<String> _recentSearches = [
    "Playa",
    "Museo",
    "Restaurante",
  ]; // ✅ Ahora final

  // ✅ Cambiar a usar datos reales
  List<Place> _allPlaces = [];
  Map<String, List<Place>> _categorizedPlaces = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces(); // ✅ Cargar desde SQLite
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  // ✅ Nuevo método para cargar desde SQLite
  Future<void> _loadPlaces() async {
    try {
      final places = await _placesService.getAllPlaces();

      // Categorizar lugares
      Map<String, List<Place>> categorized = {};
      for (var place in places) {
        if (!categorized.containsKey(place.category)) {
          categorized[place.category] = [];
        }
        categorized[place.category]!.add(place);
      }

      setState(() {
        _allPlaces = places;
        _categorizedPlaces = categorized;
        _isLoading = false;
      });
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

  // ✅ Nuevo método para búsqueda
  List<Place> get _filteredPlaces {
    if (_searchQuery.isEmpty) return [];

    return _allPlaces.where((place) {
      return place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // ✅ Categorías filtradas
  Map<String, List<Place>> get _displayedCategories {
    if (_searchQuery.isNotEmpty) {
      // Mostrar solo resultados de búsqueda
      Map<String, List<Place>> filtered = {};
      for (var place in _filteredPlaces) {
        if (!filtered.containsKey(place.category)) {
          filtered[place.category] = [];
        }
        filtered[place.category]!.add(place);
      }
      return filtered;
    }
    // Mostrar todas las categorías
    return _categorizedPlaces;
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
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
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
                  if (_displayedCategories.isEmpty && _searchQuery.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No se encontraron resultados",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._displayedCategories.entries.map((entry) {
                      return _buildCategorySection(entry.key, entry.value);
                    }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildCategorySection(String categoryName, List<Place> places) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (places.length > 2)
                TextButton(
                  onPressed: () {
                    // TODO: Navegar a vista de categoría completa
                  },
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
            itemCount: places.length > 5 ? 5 : places.length,
            itemBuilder: (context, index) {
              return _buildPlaceCard(places[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlaceCard(Place place) {
    return GestureDetector(
      onTap: () {
        // Guardar búsqueda reciente
        if (_searchQuery.isNotEmpty &&
            !_recentSearches.contains(_searchQuery)) {
          setState(() {
            _recentSearches.insert(0, _searchQuery);
            if (_recentSearches.length > 5) {
              _recentSearches.removeLast();
            }
          });
        }

        // Navegar a detalle
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
                place.mainImage.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey[600],
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
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
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
