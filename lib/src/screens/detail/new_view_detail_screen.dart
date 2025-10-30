import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';
import 'package:spm/src/screens/reservation/reservation_confirmed_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

class NewViewDetailScreen extends StatefulWidget {
  final PlaceDetail place;

  const NewViewDetailScreen({super.key, required this.place});

  @override
  State<NewViewDetailScreen> createState() => _NewViewDetailScreenState();
}

class _NewViewDetailScreenState extends State<NewViewDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.place.isFavorite;
  }

  Future<void> _handleReservation() async {
    final sessionService = SessionService();

    if (!sessionService.isLoggedIn) {
      if (!mounted) return; // ✅ Verificar mounted
      AppSnackBar.showError(context, 'Inicia sesión para hacer reservas');
      return;
    }

    // Show date picker for reservation
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Selecciona fecha de visita',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (selectedDate == null || !mounted) return; // ✅ Verificar mounted

    AppSnackBar.showLoading(context, 'Creando reserva...');

    try {
      final success = await sessionService.createReservation(
        widget.place.id,
        selectedDate,
        'Reserva desde la app SPM',
      );

      if (!mounted) return; // ✅ Verificar mounted

      AppSnackBar.hide(context);

      if (success) {
        AppSnackBar.showSuccess(context, 'Reserva creada exitosamente');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationConfirmedScreen(
              placeName: widget.place.name,
              imagePath: widget.place.imagePath,
            ),
          ),
        );
      } else {
        AppSnackBar.showError(context, 'Error al crear la reserva');
      }
    } catch (e) {
      if (!mounted) return; // ✅ Verificar mounted
      AppSnackBar.hide(context);
      AppSnackBar.showError(context, 'Error al crear la reserva: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Main image
                  Image.asset(
                    widget.place.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),

                  // Gradient overlay
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
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.place.name,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.place.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.place.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      // Favorite button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              await SessionService().toggleFavorite(
                                widget.place.id,
                              );
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                              if (mounted) {
                                AppSnackBar.showSuccess(
                                  context,
                                  _isFavorite
                                      ? 'Agregado a favoritos'
                                      : 'Eliminado de favoritos',
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                AppSnackBar.showError(
                                  context,
                                  'Error al actualizar favoritos',
                                );
                              }
                            }
                          },
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : null,
                          ),
                          label: Text(
                            _isFavorite
                                ? 'En Favoritos'
                                : 'Agregar a Favoritos',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Reserve button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _handleReservation,
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Reservar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
