import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/colors/app_colors.dart';

class TutorialPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<Widget>? buttons;

  const TutorialPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
        left: 0,
        right: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen del tutorial
          Expanded(
            flex: 5,
            child: Image.asset(
              imagePath,
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Error al cargar la imagen: ${imagePath.split('/').last}",
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 5),
                    Text("Ruta: $imagePath", style: TextStyle(fontSize: 12)),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 30),

          // Título
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.left,
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          if (buttons != null)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                children: buttons!.map((button) {
                  if (button is SizedBox) {
                    return button;
                  } else if (button is ElevatedButton) {
                    return SizedBox(width: double.infinity, child: button);
                  }
                  return button;
                }).toList(),
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
