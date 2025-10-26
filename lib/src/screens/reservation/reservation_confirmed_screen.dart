import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class ReservationConfirmedScreen extends StatelessWidget {
  final String placeName;
  final String imagePath;

  const ReservationConfirmedScreen({
    super.key,
    required this.placeName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo con overlay
          _buildBackgroundImage(),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Botón de retroceso
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                // Botón "Ver más fotos" en la parte superior
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para ver más fotos
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("VER MÁS FOTOS"),
                    ),
                  ),
                ),

                const Spacer(),

                // Tarjeta de confirmación
                Card(
                  margin: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Título de confirmación
                        Text(
                          "¡Reservado!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Botón para volver al inicio
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navegar de vuelta a la pantalla de inicio
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              "Volver al inicio",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Miniaturas de fotos en la parte inferior
                _buildPhotoThumbnails(),

                // Botón "Reservar Ahora" en la parte inferior (visible en la imagen)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Opacity(
                    opacity:
                        0.7, // Semi-transparente ya que está en segundo plano
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null, // Deshabilitado
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Reservar Ahora",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar la imagen de fondo con un overlay semitransparente
  Widget _buildBackgroundImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen de fondo
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade300,
            child: Icon(
              Icons.image_not_supported,
              size: 100,
              color: Colors.grey.shade500,
            ),
          ),
        ),

        // Overlay para oscurecer la imagen y mejorar la visibilidad del contenido
        Container(color: Colors.black.withValues(alpha: 0.3)),
      ],
    );
  }

  // Widget para mostrar las miniaturas de fotos en la parte inferior
  Widget _buildPhotoThumbnails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          4,
          (index) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 60,
              child: Image.asset(
                imagePath, // Usar la misma imagen como marcador de posición
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
