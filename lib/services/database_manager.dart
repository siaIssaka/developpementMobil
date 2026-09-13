import "package:activite1/exceptions/redacteur_exception.dart";
import "package:activite1/modele/redacteur.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:activite1/services/database_manager.dart";

Database? _database;

Future<void> initialisation() async {
  // try {
  _database = await openDatabase(
    join(await getDatabasesPath(), 'utilisateurs_database.db'),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE redacteurs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom TEXT,
          prenom TEXT,
          email TEXT
        )
      ''');
    },
    version: 1,
  );
  // } catch (e) {
  //   throw DatabaseOperationException('initialisation', e);
  // }
}

// Vérifie que la base est prête avant toute opération.
// Centralise la vérification pour éviter de la répéter dans chaque méthode.
Database _dbOuException() {
  final db = _database;
  if (db == null) {
    throw DatabaseNonInitialiseeException();
  }
  return db;
}

// Vérifie que les champs obligatoires du rédacteur sont valides.
void _validerRedacteur(Redacteur redacteur) {
  if (redacteur.nom.trim().isEmpty) {
    throw RedacteurInvalideException('le nom ne peut pas être vide.');
  }
  if (redacteur.prenom.trim().isEmpty) {
    throw RedacteurInvalideException('le prénom ne peut pas être vide.');
  }
  if (!redacteur.email.contains('@')) {
    throw RedacteurInvalideException(
      "l'email '${redacteur.email}' est mal formé.",
    );
  }
}

// CREATE : insère un nouveau rédacteur et retourne l'id généré par SQLite
Future<int> insertRedacteur(Redacteur redacteur) async {
  final db = _dbOuException();
  _validerRedacteur(redacteur);

  try {
    return await db.insert(
      'redacteurs',
      redacteur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    throw DatabaseOperationException('insertRedacteur', e);
  }
}

// READ : récupère la liste de tous les rédacteurs
Future<List<Redacteur>> getAllRedacteurs() async {
  final db = _dbOuException();

  try {
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');
    return maps.map((map) => Redacteur.fromMap(map)).toList();
  } catch (e) {
    throw DatabaseOperationException('getAllRedacteurs', e);
  }
}

// READ : récupère un seul rédacteur par son id, lève une exception s'il n'existe pas
Future<Redacteur> getRedacteurParId(int id) async {
  final db = _dbOuException();

  try {
    final List<Map<String, dynamic>> maps = await db.query(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw RedacteurIntrouvableException(id);
    }
    return Redacteur.fromMap(maps.first);
  } on RedacteurIntrouvableException {
    rethrow; // on la relance telle quelle, sans l'enrober dans DatabaseOperationException
  } catch (e) {
    throw DatabaseOperationException('getRedacteurParId', e);
  }
}

// UPDATE : met à jour un rédacteur existant (doit avoir un id non nul)
Future<void> updateRedacteur(Redacteur redacteur) async {
  final db = _dbOuException();
  _validerRedacteur(redacteur);

  if (redacteur.id == null) {
    throw RedacteurSansIdException('updateRedacteur');
  }

  try {
    final int nbLignesModifiees = await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );

    if (nbLignesModifiees == 0) {
      throw RedacteurIntrouvableException(redacteur.id!);
    }
  } on RedacteurIntrouvableException {
    rethrow;
  } catch (e) {
    throw DatabaseOperationException('updateRedacteur', e);
  }
}

// DELETE : supprime un rédacteur à partir de son id
Future<void> deleteRedacteur(int id) async {
  final db = _dbOuException();

  try {
    final int nbLignesSupprimees = await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (nbLignesSupprimees == 0) {
      throw RedacteurIntrouvableException(id);
    }
  } on RedacteurIntrouvableException {
    rethrow;
  } catch (e) {
    throw DatabaseOperationException('deleteRedacteur', e);
  }
}
