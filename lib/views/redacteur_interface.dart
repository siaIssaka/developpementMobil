import "package:activite1/apropos.dart";
import "package:activite1/exceptions/redacteur_exception.dart";
import "package:activite1/modele/redacteur.dart";
import "package:activite1/services/database_manager.dart";
import "package:flutter/material.dart";

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  // Controleurs reliés aux champs de saisie du formulaire
  final TextEditingController _controleurNom = TextEditingController();
  final TextEditingController _controleurPrenom = TextEditingController();
  final TextEditingController _controleurEmail = TextEditingController();

  // Liste des rédacteurs affichés dans le ListView.builder
  List<Redacteur> _redacteurs = [];
  bool _enChargement = true;

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs();
  }

  @override
  void dispose() {
    // Toujours libérer les TextEditingController pour éviter les fuites mémoire
    _controleurNom.dispose();
    _controleurPrenom.dispose();
    _controleurEmail.dispose();
    super.dispose();
  }

  // Recharge la liste des rédacteurs depuis la base
  Future<void> _chargerRedacteurs() async {
    setState(() => _enChargement = true);
    try {
      final liste = await getAllRedacteurs();
      setState(() {
        _redacteurs = liste;
        _enChargement = false;
      });
    } on DatabaseRedacteurException catch (e) {
      setState(() => _enChargement = false);
      _afficherMessage(e.message, erreur: true);
    }
  }

  void _afficherMessage(String message, {bool erreur = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: erreur ? Colors.red : null,
      ),
    );
  }

  // Appelée par le bouton "Ajouter un rédacteur"
  Future<void> _ajouterRedacteur() async {
    final nom = _controleurNom.text.trim();
    final prenom = _controleurPrenom.text.trim();
    final email = _controleurEmail.text.trim();

    try {
      final nouveau = Redacteur.sansId(nom: nom, prenom: prenom, email: email);
      await insertRedacteur(nouveau);
      _afficherMessage('Rédacteur ajouté.');
      _controleurNom.clear();
      _controleurPrenom.clear();
      _controleurEmail.clear();
      await _chargerRedacteurs();
    } on RedacteurInvalideException catch (e) {
      _afficherMessage(e.message, erreur: true);
    } on DatabaseRedacteurException catch (e) {
      _afficherMessage(e.message, erreur: true);
    }
  }

  // Icône crayon : ouvre une boîte de dialogue pour modifier le rédacteur
  Future<void> _modifierRedacteur(Redacteur redacteur) async {
    final controleurNouveauNom = TextEditingController(text: redacteur.nom);
    final controleurNouveauPrenom = TextEditingController(
      text: redacteur.prenom,
    );
    final controleurNouvelEmail = TextEditingController(text: redacteur.email);

    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier Rédacteur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controleurNouveauNom,
              decoration: const InputDecoration(labelText: 'Nouveau Nom'),
            ),
            TextField(
              controller: controleurNouveauPrenom,
              decoration: const InputDecoration(labelText: 'Nouveau Prénom'),
            ),
            TextField(
              controller: controleurNouvelEmail,
              decoration: const InputDecoration(labelText: 'Nouvel Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    // Si l'utilisateur a fermé la boîte de dialogue ou cliqué "Annuler", on s'arrête là
    if (confirme != true) return;

    final redacteurModifie = Redacteur(
      id: redacteur.id,
      nom: controleurNouveauNom.text.trim(),
      prenom: controleurNouveauPrenom.text.trim(),
      email: controleurNouvelEmail.text.trim(),
    );

    try {
      await updateRedacteur(redacteurModifie);
      _afficherMessage('Rédacteur modifié.');
      await _chargerRedacteurs();
    } on RedacteurInvalideException catch (e) {
      _afficherMessage(e.message, erreur: true);
    } on RedacteurIntrouvableException catch (e) {
      _afficherMessage(e.message, erreur: true);
      await _chargerRedacteurs();
    } on DatabaseRedacteurException catch (e) {
      _afficherMessage(e.message, erreur: true);
    }
  }

  // Icône poubelle : demande confirmation puis supprime
  Future<void> _supprimerRedacteur(Redacteur redacteur) async {
    if (redacteur.id == null) return;

    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce rédacteur ?'),
        content: Text(
          '${redacteur.prenom} ${redacteur.nom} sera définitivement supprimé.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true) return;

    try {
      await deleteRedacteur(redacteur.id!);
      _afficherMessage('Rédacteur supprimé.');
      await _chargerRedacteurs();
    } on RedacteurIntrouvableException catch (e) {
      _afficherMessage(e.message, erreur: true);
      await _chargerRedacteurs();
    } on DatabaseRedacteurException catch (e) {
      _afficherMessage(e.message, erreur: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 3, 111),
        title: const Text('Gestion des rédacteurs'),
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 243, 3, 111),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context); // ferme le drawer avant de naviguer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Apropos(title: 'À propos'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bientôt disponible.')),
                );
              },
            ),
            // Ajoutez ici d'autres ListTile pour vos futures pages
          ],
        ),
      ),
      body: Column(
        children: [
          // ---------- Zone supérieure : formulaire ----------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controleurNom,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controleurPrenom,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controleurEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _ajouterRedacteur,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Ajouter un Rédacteur'),

                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    backgroundColor: const Color.fromARGB(255, 243, 3, 111),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // ---------- Zone inférieure : liste des rédacteurs ----------
          Expanded(
            child: _enChargement
                ? const Center(child: CircularProgressIndicator())
                : _redacteurs.isEmpty
                ? const Center(child: Text('Aucun rédacteur pour le moment.'))
                : ListView.builder(
                    itemCount: _redacteurs.length,
                    itemBuilder: (context, index) {
                      final redacteur = _redacteurs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text('${redacteur.prenom} ${redacteur.nom}'),
                          subtitle: Text(redacteur.email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Modifier',
                                onPressed: () => _modifierRedacteur(redacteur),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Supprimer',
                                onPressed: () => _supprimerRedacteur(redacteur),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
