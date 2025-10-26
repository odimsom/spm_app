import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/models/user.dart';
import 'package:spm/src/core/services/database_service.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/shared/widgets/app_image.dart';
import 'package:spm/src/screens/detail/new_view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final SessionService _sessionService = SessionService();
  final DatabaseService _databaseService = DatabaseService();

  List<Reservation> _reservations = [];
  Map<int, Place> _placesMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final reservations = await _sessionService.getUserReservations();
      final Map<int, Place> placesMap = {};

      // Load place details for each reservation
      for (var reservation in reservations) {
        final place = await _databaseService.getPlace(reservation.placeId);
        if (place != null) {
          placesMap[reservation.placeId] = place;
        }
      }

      setState(() {
        _reservations = reservations;
        _placesMap = placesMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cargando reservas: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Mis Reservas',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadReservations,
              child: ListView.builder(
                padding: AppResponsive.getResponsivePadding(context),
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  final reservation = _reservations[index];
                  final place = _placesMap[reservation.placeId];
                  if (place == null) return const SizedBox.shrink();

                  return _buildReservationCard(reservation, place);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: AppConstants.iconSizeXl * 2,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: AppConstants.spacingLg),
          Text(
            'No tienes reservas',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.spacingSm),
          Text(
            'Explora lugares y haz tu primera reserva',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation, Place place) {
    return Card(
      margin: EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: InkWell(
        onTap: () => _navigateToDetail(place),
        borderRadius: AppConstants.borderRadiusMd,
        child: Padding(
          padding: AppConstants.paddingMd,
          child: Row(
            children: [
              // Place image
              ClipRRect(
                borderRadius: AppConstants.borderRadiusSm,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: AppImage(
                    imageData: place.mainImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: AppConstants.spacingMd),

              // Reservation details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: AppConstants.spacingXs),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppConstants.spacingXs),
                        Text(
                          _formatDate(reservation.reservationDate),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),

                    SizedBox(height: AppConstants.spacingXs),

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSm,
                            vertical: AppConstants.spacingXs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              reservation.status,
                            ).withValues(alpha: 0.1),
                            borderRadius: AppConstants.borderRadiusSm,
                          ),
                          child: Text(
                            _getStatusText(reservation.status),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getStatusColor(reservation.status),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmada';
      case 'pending':
        return 'Pendiente';
      case 'cancelled':
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
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
      additionalInfo: {
        'category': place.category,
        'opening_hours': place.openingHours,
        'phone': place.phone,
        'address': place.address,
        'price_range': place.priceRange,
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewViewDetailScreen(place: placeDetail),
      ),
    );
  }
}
