import 'package:shared_preferences/shared_preferences.dart';

class TutorialHelper {
  static const String _seenTutorialKey = 'seen_tutorial';

  // Método para comprobar si el usuario ya vio el tutorial
  static Future<bool> hasSeenTutorial() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenTutorialKey) ?? false;
  }

  // Método para marcar el tutorial como visto
  static Future<void> markTutorialAsSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenTutorialKey, true);
  }

  // Método para resetear el estado del tutorial (para pruebas)
  static Future<void> resetTutorialState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenTutorialKey, false);
  }
}
