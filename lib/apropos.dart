import "package:flutter/material.dart";

class Apropos extends StatelessWidget {
  const Apropos({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 3, 111),
        title: const Text('Magazine infos'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: const AssetImage('assets/images/image1.jpg'),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const PartieTitre(),
            const PartieTexte(),
            const PartieIcones(),
            const PartieRubrique(),
          ],
        ),
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

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Votre magazine quotidien sur toute l\u2019actualité.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'Magazine Infos est bien plus qu\u2019un simple magazine '
        'd\u2019information. C\u2019est votre passerelle vers le monde, '
        'une source inestimable de connaissances et d\u2019actualités '
        'soigneusement sélectionnées pour vous éclairer sur les '
        'enjeux mondiaux, la culture, la science et le divertissement.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class PartieIcones extends StatelessWidget {
  const PartieIcones({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Téléphone
          Column(
            children: [
              const Icon(Icons.phone, color: Colors.pink),
              const SizedBox(height: 5),
              const Text(
                'TEL',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // E-mail
          Column(
            children: [
              const Icon(Icons.email, color: Colors.pink),
              const SizedBox(height: 5),
              const Text(
                'MAIL',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Partage
          Column(
            children: [
              const Icon(Icons.share, color: Colors.pink),
              const SizedBox(height: 5),
              const Text(
                'PARTAGE',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/image2.jpg',
              width: 150,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/image3.jpg',
              width: 150,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
