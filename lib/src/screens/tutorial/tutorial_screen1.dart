import 'package:flutter/material.dart';
import 'package:spm/src/screens/tutorial/components/tutorial_page.dart';

class TutorialScreen1 extends StatelessWidget {
  const TutorialScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return const TutorialPage(
      imagePath: 'assets/images/screen1.png',
      title: 'Conoce a San Pedro de Macorís',
      description:
          'Una de las provincias con más valor histórico y patrimonio arquitectónico de la República Dominicana, San Pedro de Macorís, la dueña de los atardeceres más bellos de todo Quisqueya.',
    );
  }
}
