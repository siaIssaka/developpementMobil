/// Exception de base pour toutes les erreurs liées à la base de données
/// des rédacteurs. Permet d'attraper toutes les erreurs "métier" d'un
/// seul coup avec : catch (DatabaseRedacteurException e) { ... }
abstract class DatabaseRedacteurException implements Exception {
  final String message;
  DatabaseRedacteurException(this.message);

  @override
  String toString() => message;
}

/// Levée lorsqu'une méthode CRUD est appelée avant initialisation() ou
/// après la fermeture de la base.
class DatabaseNonInitialiseeException extends DatabaseRedacteurException {
  DatabaseNonInitialiseeException()
    : super(
        "La base de données n'est pas initialisée. "
        "Appelez initialisation() avant toute opération.",
      );
}

/// Levée quand on tente une opération qui nécessite un id
/// (mise à jour, suppression) mais que le Redacteur fourni n'en a pas.
class RedacteurSansIdException extends DatabaseRedacteurException {
  RedacteurSansIdException(String operation)
    : super(
        "Impossible d'effectuer l'opération '$operation' : "
        "le Redacteur fourni n'a pas d'id (id == null).",
      );
}

/// Levée quand on cherche/modifie/supprime un rédacteur dont l'id
/// n'existe pas en base.
class RedacteurIntrouvableException extends DatabaseRedacteurException {
  final int id;
  RedacteurIntrouvableException(this.id)
    : super("Aucun rédacteur trouvé avec l'id $id.");
}

/// Levée quand les données du rédacteur ne respectent pas les règles
/// métier minimales (champs vides, email mal formé, etc.)
class RedacteurInvalideException extends DatabaseRedacteurException {
  RedacteurInvalideException(String detail)
    : super("Rédacteur invalide : $detail");
}

/// Enveloppe toute erreur SQLite/sqflite imprévue (contrainte violée,
/// disque plein, corruption...) pour ne pas laisser fuiter les détails
/// techniques de sqflite jusqu'à l'interface utilisateur.
class DatabaseOperationException extends DatabaseRedacteurException {
  final Object erreurOriginale;
  DatabaseOperationException(String operation, this.erreurOriginale)
    : super("Échec de l'opération '$operation' en base de données.");
}
