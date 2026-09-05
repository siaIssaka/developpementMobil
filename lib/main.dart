import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    bool debugShowCheckedModeBanner = false;

    return MaterialApp(
      title: 'Magazine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      home: PageAccueil(title: 'Magazine'),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 3, 111),
        title: Text('Magazine infos'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              // Action à effectuer lors du clic sur l'icône de recherche
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            // Action à effectuer lors du clic sur l'icône de menu
          },
          icon: const Icon(Icons.menu),
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Image.asset('assets/images/image1.jpg', fit: BoxFit.cover),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 234, 4, 107),
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tu as cliqué dessus')));
        },
        child: const Text(
          'Click',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
