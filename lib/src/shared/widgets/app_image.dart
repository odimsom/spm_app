import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spm/src/core/models/place.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';
import 'package:spm/src/core/utils/app_constants.dart';

class AppImage extends StatelessWidget {
  final ImageData imageData;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imageData,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageData.isRemote) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageData.path,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorWidget(),
      );
    } else {
      imageWidget = Image.asset(
        imageData.path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildErrorWidget(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: AppConstants.iconSizeLg,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: AppConstants.spacingSm),
          Text(
            'Imagen no disponible',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool showFavoriteButton;

  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onFavorite,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(borderRadius: AppConstants.borderRadiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(imageData: place.mainImage, fit: BoxFit.cover),

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
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),

                  // Favorite button
                  if (showFavoriteButton)
                    Positioned(
                      top: AppConstants.spacingSm,
                      right: AppConstants.spacingSm,
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
                                ? AppColors.error
                                : Colors.grey.shade600,
                            size: AppConstants.iconSizeMd,
                          ),
                          onPressed: onFavorite,
                        ),
                      ),
                    ),

                  // Place name and rating
                  Positioned(
                    bottom: AppConstants.spacingSm,
                    left: AppConstants.spacingSm,
                    right: AppConstants.spacingSm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppConstants.spacingXs),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < place.rating.floor()
                                    ? Icons.star
                                    : (index < place.rating
                                          ? Icons.star_half
                                          : Icons.star_border),
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                            SizedBox(width: AppConstants.spacingXs),
                            Text(
                              place.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info section
            Expanded(
              flex: 1,
              child: Padding(
                padding: AppConstants.paddingSm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSm,
                            vertical: AppConstants.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: AppConstants.borderRadiusSm,
                          ),
                          child: Text(
                            place.category,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          place.priceRange,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstants.spacingXs),
                    Expanded(
                      child: Text(
                        place.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
