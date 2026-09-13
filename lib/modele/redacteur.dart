import 'package:flutter/material.dart';
import 'package:activite1/modele/redacteur.dart';

class Redacteur {
  final int? id; // nullable : généré automatiquement par SQLite (AUTOINCREMENT)
  final String nom;
  final String prenom;
  final String email;

  // Constructeur complet (utilisé notamment par fromMap, quand l'id existe déjà)
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur nommé sans id (utilisé lors de la création d'un nouveau rédacteur,
  // avant insertion en base : l'id sera généré par SQLite)
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  }) : id = null;

  // Transforme l'objet en Map (pour insert / update dans SQLite)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'nom': nom, 'prenom': prenom, 'email': email};
    // On n'inclut l'id que s'il existe, pour laisser SQLite l'auto-générer sinon
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Reconstruit un objet Redacteur à partir d'une ligne (Map) issue de la base
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }

  @override
  String toString() {
    return 'Redacteur{id: $id, nom: $nom, prenom: $prenom, email: $email}';
  }
}
