import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/models/place_detail.dart';
import 'package:spm/src/shared/widgets/main_navigator.dart';

class ViewDetailScreen extends StatefulWidget {
  final PlaceDetail place;

  const ViewDetailScreen({super.key, required this.place});

  @override
  State<ViewDetailScreen> createState() => _ViewDetailScreenState();
}

class _ViewDetailScreenState extends State<ViewDetailScreen> {
  bool _showGallery = false;
  bool _showReservationConfirmation = false;
  final PageController _galleryController = PageController();

  // Imágenes de galería simuladas
  final List<String> _galleryImages = [
    'assets/images/fotos/Museo Centro Histórico Ron Barceló/Museo Centro Histórico Ron Barceló.jpg',
    'assets/images/fotos/Playa Juan Dolio.webp',
    'assets/images/fotos/malecon.jpg',
    'assets/images/fotos/campo azul.jpg',
  ];

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  void _showReservation() {
    setState(() {
      _showReservationConfirmation = true;
    });
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigator()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal
          CustomScrollView(
            slivers: [
              // Imagen superior
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      widget.place.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.place.isFavorite
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: () {
                      // Toggle favorite
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.place.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ),
                        ),
                      ),
                      // Botón "Ver más fotos" arriba de la imagen
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showGallery = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                'Ver más fotos',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Contenido con esquinas redondeadas superiores (más pronunciadas)
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del lugar
                        Text(
                          widget.place.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Estrellas (sin número)
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < widget.place.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFFFB300),
                              size: 24,
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        // Descripción
                        Text(
                          widget.place.description,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Mini imágenes de galería
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _galleryImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    _galleryImages[index],
                                    width: 100,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 100,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Botón de reserva (más corto)
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ElevatedButton(
                              onPressed: _showReservation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'Reservar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Galería con blur verde
          if (_showGallery)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showGallery = false;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, // Evitar que el tap pase al fondo
                      child: SizedBox(
                        height: 400,
                        child: PageView.builder(
                          controller: _galleryController,
                          itemCount: _galleryImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  _galleryImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Confirmación de reserva con blur blanco
          if (_showReservationConfirmation)
            GestureDetector(
              onTap: () {}, // No cerrar al tocar
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.8),
                  child: Center(
                    child: Card(
                      margin: const EdgeInsets.all(32),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 80,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '¡Reservado!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tu reserva ha sido confirmada exitosamente',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: _goToHome,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Volver al inicio',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
