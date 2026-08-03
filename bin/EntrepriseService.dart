import 'Database.dart';
import 'package:bcrypt/bcrypt.dart';

class Entreprise {
  int? idEntreprise;
  String nom;
  String? adresse;
  String? telephone;
  String? email;

  Entreprise({
    this.idEntreprise,
    required this.nom,
    this.adresse,
    this.telephone,
    this.email,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) {
    return Entreprise(
      idEntreprise: json['id_entreprise'],
      nom: json['nom'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_entreprise': idEntreprise,
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
    };
  }

  // ENREGISTRER L'ENTREPRISE
  static Future createEntreprise(
    String nom,
    String adresse,
    String telephone,
    String email,
    String password,
  ) async {
    final conn = await Database.connect();

    try {
      // Vérifier si une entreprise existe déjà
      final existe = await conn.query(
        "SELECT COUNT(*) AS total FROM entreprise",
      );

      final total = existe.first["total"] as int;

      if (total > 0) {
        throw Exception("Une entreprise existe déjà.");
      }

      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      await conn.query(
        """
        INSERT INTO entreprise(
          nom,
          adresse,
          telephone,
          email,
          password
        )
        VALUES(?,?,?,?,?)
        """,
        [nom, adresse, telephone, email.trim().toLowerCase(), hashedPassword],
      );
    } catch (e) {
      print("Erreur création entreprise : $e");
    }
  }

  // RÉCUPÉRER L'ENTREPRISE
  static Future<Map<String, dynamic>?> getEntreprise() async {
    final conn = await Database.connect();

    final results = await conn.query("""
    SELECT
      id_entreprise,
      nom,
      adresse,
      telephone,
      email,
      date_creation
    FROM entreprise
    LIMIT 1
  """);

    if (results.isEmpty) return null;

    final data = Map<String, dynamic>.from(results.first.fields);

    data["date_creation"] = (data["date_creation"] as DateTime)
        .toIso8601String();

    return data;
  }

  // MODIFIER L'ENTREPRISE
  static Future modifierEntreprise(
    int idEntreprise,
    String nom,
    String adresse,
    String telephone,
    String email,
  ) async {
    final conn = await Database.connect();

    try {
      await conn.query(
        """
        UPDATE entreprise
        SET
          nom = ?,
          adresse = ?,
          telephone = ?,
          email = ?
        WHERE id_entreprise = ?
        """,
        [nom, adresse, telephone, email.trim().toLowerCase(), idEntreprise],
      );
    } catch (e) {
      print("Erreur modification entreprise : $e");
    }
  }

  static Future<Map<String, dynamic>?> loginEntreprise(
    String email,
    String password,
  ) async {
    final conn = await Database.connect();

    try {
      final results = await conn.query(
        "SELECT * FROM entreprise WHERE email = ?",
        [email.trim().toLowerCase()],
      );

      if (results.isEmpty) return null;

      final entreprise = results.first.fields;

      final storedPassword = entreprise["password"];

      if (storedPassword == null) return null;

      final isValid = BCrypt.checkpw(password, storedPassword);

      if (!isValid) return null;

      return entreprise;
    } catch (e) {
      print("Erreur login entreprise : $e");
      return null;
    }
  }
}
