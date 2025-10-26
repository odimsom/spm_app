import 'package:flutter/material.dart';
import 'package:spm/src/screens/tutorial/components/tutorial_page.dart';

class TutorialScreen2 extends StatelessWidget {
  const TutorialScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const TutorialPage(
      imagePath: 'assets/images/screen2.png',
      title: 'Playas y Ríos',
      description:
          'Visitar nuestras hermosas playas y ríos sería una experiencia única ya que son de las más hermosas del país.',
    );
  }
}
