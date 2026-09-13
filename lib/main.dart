import "package:flutter/material.dart";
import "package:activite1/modele/redacteur.dart";
import "package:activite1/services/database_manager.dart";
import "package:activite1/views/redacteur_interface.dart";
import "package:activite1/apropos.dart";

// 11. Point d'entrée de l'application : initialise la base puis lance MonApplication
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialisation();
  runApp(const MonApplication());
}

// 11. MonApplication : StatelessWidget, point d'entrée visuel du projet
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    // 12. Ce widget retourne un MaterialApp
    return MaterialApp(
      // 13. Titre d'application explicite
      title: 'Gestion des rédacteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 14. La page d'accueil est RedacteurInterface
      home: const RedacteurInterface(),
    );
  }
}
