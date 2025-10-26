import 'package:flutter/material.dart';
import 'package:spm/src/screens/detail/view_detail_screen.dart';
import 'package:spm/src/core/models/place_detail.dart';

/// Este es un ejemplo de cómo usar la pantalla de detalle desde cualquier
/// parte de la aplicación.

void navigateToDetailScreen(BuildContext context) {
  // Crear un objeto PlaceDetail con los datos del lugar
  final place = PlaceDetail(
    name: 'Centro Histórico Ron Barceló',
    imagePath: 'assets/images/museo_ron_barcelo.jpg',
    rating: 4.5,
    description:
        'Podrán sumergirse en un ambiente ecléctico antiguo y moderno, con piezas y objetos que despertarán su curiosidad y les envolverán en un ambiente de descubrimiento. Además, tendrán oportunidad de adquirir nuestros productos y gama de artículos promocionales, para que puedan tener un delicioso recuerdo de la experiencia.',
    isFavorite: true,
    // Opcional: Agregar imágenes de galería
    galleryImages: [
      'assets/images/museo_ron_barcelo_1.jpg',
      'assets/images/museo_ron_barcelo_2.jpg',
      'assets/images/museo_ron_barcelo_3.jpg',
    ],
    // Opcional: Información adicional
    additionalInfo: {
      'horario': '9:00 AM - 5:00 PM',
      'ubicacion': 'San Pedro de Macorís',
      'precio': 'Entrada libre',
    },
  );

  // Navegar a la pantalla de detalle
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ViewDetailScreen(place: place)),
  );
}

/// Ejemplo de cómo usar el navegador desde un botón o tarjeta:
///
/// ElevatedButton(
///   onPressed: () => navigateToDetailScreen(context),
///   child: Text('Ver detalle'),
/// )
