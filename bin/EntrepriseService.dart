import 'Database.dart';
import 'package:bcrypt/bcrypt.dart';

class Entreprise {
  int? idEntreprise;
  String nom;
  String? adresse;
  String? telephone;
  String? email;
  String? devise;

  Entreprise({
    this.idEntreprise,
    required this.nom,
    this.adresse,
    this.telephone,
    this.email,
    this.devise,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) {
    return Entreprise(
      idEntreprise: json['id_entreprise'],
      nom: json['nom'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      email: json['email'],
      devise: json['devise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_entreprise': idEntreprise,
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
      'devise': devise,
    };
  }

  // ENREGISTRER L'ENTREPRISE
  static Future<Map<String, dynamic>?> createEntreprise({
    required String nom,
    required String adresse,
    required String telephone,
    required String email,
    required String password,
    required String devise,
  }) async {
    final conn = Database().pool;

    try {
      // Vérifier si une entreprise existe déjà
      final existe = await conn.execute(
        """
  SELECT id_entreprise
  FROM entreprise
  WHERE email = ?
  """,
        {'email': email.trim().toLowerCase()},
      );

      if (existe.isNotEmpty) {
        throw Exception("Cet email est déjà utilisé.");
      }

      // Hasher le mot de passe
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Insérer l'entreprise
      final result = await conn.execute(
        """
      INSERT INTO entreprise(
        nom,
        adresse,
        telephone,
        email,
        password,
        devise
      )
      VALUES(:nom, :adresse, :telephone, :email, :password, :devise)
      """,
        {
          'nom': nom,
          'adresse': adresse,
          'telephone': telephone,
          'email': email.trim().toLowerCase(),
          'password': hashedPassword,
          'devise': devise,
        },
      );

      // Récupérer l'id créé
      final idEntreprise = result.lastInsertID.toInt();

      // Récupérer l'entreprise créé
      final entreprise = await conn.execute(
        """
      SELECT
        id_entreprise,
        nom,
        adresse,
        telephone,
        email,
        devise
      FROM entreprise
      WHERE id_entreprise = :id
      """,
        {'id': idEntreprise},
      );

      if (entreprise.isEmpty) {
        return null;
      }

      return Map<String, dynamic>.from(entreprise.rows.first.assoc());
    } catch (e) {
      print("Erreur création entreprise : $e");

      return null;
    }
  }

  // RÉCUPÉRER L'ENTREPRISE
  static Future<Map<String, dynamic>?> getEntreprise() async {
    final conn = Database().pool;

    final results = await conn.execute("""
    SELECT
      id_entreprise,
      nom,
      adresse,
      telephone,
      email,
      date_creation,
      devise
    FROM entreprise
    LIMIT 1
  """);

    if (results.isEmpty) return null;

    final data = Map<String, dynamic>.from(results.rows.first.assoc());

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
    String devise,
  ) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        """
        UPDATE entreprise
        SET
          nom = :nom,
          adresse = :adresse,
          telephone = :telephone,
          email = :email,
          devise = :devise
        WHERE id_entreprise = :id
        """,
        {
          'nom': nom,
          'adresse': adresse,
          'telephone': telephone,
          'email': email.trim().toLowerCase(),
          'devise': devise,
          'id': idEntreprise,
        },
      );
    } catch (e) {
      print("Erreur modification entreprise : $e");
    }
  }

  static Future<Map<String, dynamic>?> loginEntreprise(
    String email,
    String password,
  ) async {
    final conn = Database().pool;

    try {
      final results = await conn.execute(
        "SELECT * FROM entreprise WHERE email = :email",
        {'email': email.trim().toLowerCase()},
      );

      print(results.rows.map((e) => e.assoc()).toList());
      print("Nombre entreprise trouvée : ${results.rows.length}");

      if (results.isEmpty) return null;

      final entreprise = results.rows.first.assoc();

      print("Entreprise trouvée : $entreprise");

      final storedPassword = entreprise["password"]?.toString();

      print("Password hash : $storedPassword");

      if (storedPassword == null) return null;

      final isValid = BCrypt.checkpw(password, storedPassword);

      print("Mot de passe valide : $isValid");

      if (!isValid) return null;

      final data = Map<String, dynamic>.from(entreprise);

      if (data["date_creation"] != null) {
        data["date_creation"] = (data["date_creation"] as DateTime)
            .toIso8601String();
      }

      data.remove("password");

      return data;
    } catch (e, stackTrace) {
      print("Erreur login entreprise : $e");
      print(stackTrace);
      rethrow;
    }
  }
}
