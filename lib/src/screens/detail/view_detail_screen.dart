import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/screens/reservation/reservation_confirmed_screen.dart';
import 'package:spm/src/screens/gallery/improved_gallery_screen.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/models/place_detail.dart';

class ViewDetailScreen extends StatefulWidget {
  final PlaceDetail place;

  const ViewDetailScreen({super.key, required this.place});

  @override
  State<ViewDetailScreen> createState() => _ViewDetailScreenState();
}

class _ViewDetailScreenState extends State<ViewDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.place.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
          ),
        ),
        actions: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal con degradado
            _buildHeaderImage(),

            // Contenido del detalle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y valoración
                  _buildTitleAndRating(),

                  const SizedBox(height: 16),

                  // Descripción
                  _buildDescription(),

                  const SizedBox(height: 24),

                  // Galería de imágenes adicionales (si hay)
                  if (widget.place.galleryImages.isNotEmpty) ...[
                    _buildGallery(),
                    const SizedBox(height: 24),
                  ],

                  // Botón de reserva
                  _buildReservationButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        // Imagen principal
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.asset(
            widget.place.imagePath,
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
        ),

        // Gradiente para mejorar la visibilidad del texto superpuesto
        Positioned.fill(
          child: Container(
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

        // Información sobre la imagen (opcional)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Este espacio se puede usar para información adicional si es necesario
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre del lugar
        Text(
          widget.place.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        // Estrellas de valoración
        Row(
          children: [
            ...List.generate(
              5,
              (index) => Icon(
                index < widget.place.rating.floor()
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 20,
              ),
            ),
            if (widget.place.rating - widget.place.rating.floor() >= 0.5)
              const Icon(Icons.star_half, color: Colors.amber, size: 20),

            const SizedBox(width: 8),

            // Puntuación numérica
            Text(
              widget.place.rating.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.place.description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),

        // Botón "Ver más fotos" (opcional)
        if (widget.place.galleryImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Acción para ver más fotos
            },
            child: Text(
              "Ver más fotos",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Galería",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (widget.place.galleryImages.length > 3)
              TextButton(
                onPressed: _openFullGallery,
                child: Text(
                  'Ver más fotos (${widget.place.galleryImages.length})',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Carrusel horizontal de imágenes
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.place.galleryImages.length > 6
                ? 6
                : widget.place.galleryImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => _openFullGallery(initialIndex: index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.asset(
                          widget.place.galleryImages[index],
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 180,
                                height: 120,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[500],
                                ),
                              ),
                        ),
                        // Overlay en la última imagen si hay más fotos
                        if (index == 5 && widget.place.galleryImages.length > 6)
                          Container(
                            width: 180,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '+${widget.place.galleryImages.length - 6}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openFullGallery({int initialIndex = 0}) {
    // Convertir List<String> a List<ImageData>
    final images = widget.place.galleryImages.map((path) {
      if (path.startsWith('http')) {
        return ImageData(type: 'remote', path: path);
      } else {
        return ImageData(type: 'local', path: path);
      }
    }).toList();

    context.showImageGallery(
      placeName: widget.place.name,
      images: images,
      initialIndex: initialIndex,
    );
  }

  Widget _buildReservationButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla de confirmación de reserva
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationConfirmedScreen(
                placeName: widget.place.name,
                imagePath: widget.place.imagePath,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Reservar Ahora",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
