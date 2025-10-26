import 'package:flutter/material.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/services/session_service.dart';
import 'package:spm/src/shared/widgets/app_image.dart';
import 'package:spm/src/shared/widgets/app_snackbar.dart';

class NewPlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const NewPlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with AspectRatio for square cards
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Main image
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: AppImage(
                        imageData: place.mainImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  // Rating badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toStringAsFixed(1),
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

                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          place.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: place.isFavorite
                              ? Colors.red
                              : Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () async {
                          if (onFavorite != null) {
                            onFavorite!();
                          } else {
                            // Default favorite handling
                            try {
                              await SessionService().toggleFavorite(place.id);
                              // Show feedback only if widget is still mounted
                              if (context.mounted) {
                                AppSnackBar.showSuccess(
                                  context,
                                  place.isFavorite
                                      ? 'Eliminado de favoritos'
                                      : 'Agregado a favoritos',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                AppSnackBar.showError(
                                  context,
                                  'Error al actualizar favoritos',
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Place name
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Category or description
                    Text(
                      place.category,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
