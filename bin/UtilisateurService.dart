import 'Database.dart';
import 'package:bcrypt/bcrypt.dart';

class UtilisateurService {
  int idUtilisateur;
  int idEntreprise;
  String nom;
  String postnom;
  String password;
  String telephone;
  String email;

  UtilisateurService({
    required this.idUtilisateur,
    required this.idEntreprise,
    required this.nom,
    required this.postnom,
    required this.password,
    required this.telephone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_utilisateur': idUtilisateur,
      'id_entreprise': idEntreprise,
      'nom': nom,
      'postnom': postnom,
      'password': password,
      'telephone': telephone,
      'email': email,
    };
  }

  factory UtilisateurService.fromJson(Map<String, dynamic> json) {
    return UtilisateurService(
      idUtilisateur: json['id_utilisateur'] ?? 0,
      idEntreprise: json['id_entreprise'] ?? 0,
      nom: json['nom'] ?? '',
      postnom: json['postnom'] ?? '',
      password: json['password'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
    );
  }
  // CREER UTILISATEUR
  static Future createUtilisateur(
    int idEntreprise,
    String nom,
    String postnom,
    String password,
    String telephone,
    String email,
  ) async {
    final conn = Database().pool;

    try {
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      await conn.execute(
        """
        INSERT INTO utilisateurs(
          id_entreprise,
          nom,
          postnom,
          password,
          telephone,
          email
        )
        VALUES(:idEntreprise, :nom, :postnom, :password, :telephone, :email)
        """,
        {
          'idEntreprise': idEntreprise,
          'nom': nom,
          'postnom': postnom.trim().toLowerCase(),
          'password': hashedPassword,
          'telephone': telephone,
          'email': email.trim().toLowerCase(),
        },
      );
    } catch (e) {
      print("Erreur création utilisateur : $e");
    }
  }

  // MODIFIER UTILISATEUR
  static Future modifierUtilisateur(
    int idUtilisateur,
    String nom,
    String postnom,
    String telephone,
    String email,
  ) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        """
        UPDATE utilisateurs
        SET
          nom = :nom,
          postnom = :postnom,
          telephone = :telephone,
          email = :email
        WHERE id_utilisateur = :id
        """,
        {
          'nom': nom,
          'postnom': postnom.trim().toLowerCase(),
          'telephone': telephone,
          'email': email.trim().toLowerCase(),
          'id': idUtilisateur,
        },
      );
    } catch (e) {
      print("Erreur modification utilisateur : $e");
    }
  }

  // SUPPRIMER UTILISATEUR
  static Future supprimerUtilisateur(int idUtilisateur) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        "DELETE FROM utilisateurs WHERE id_utilisateur = :id",
        {'id': idUtilisateur},
      );
    } catch (e) {
      print("Erreur suppression utilisateur : $e");
    }
  }

  // RECUPERER LES UTILISATEURS
  static Future<List<Map<String, dynamic>>> getUtilisateur(
    int idEntreprise,
  ) async {
    final conn = Database().pool;

    try {
      final results = await conn.execute(
        """
        SELECT *
        FROM utilisateurs
        WHERE id_entreprise = :idEntreprise
        ORDER BY nom ASC
        """,
        {'idEntreprise': idEntreprise},
      );

      return results.rows.map((e) {
        return e.assoc();
      }).toList();
    } catch (e) {
      print("Erreur chargement utilisateurs : $e");
      return [];
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>?> loginUtilisateur(
    String postnom,
    String password,
  ) async {
    final conn = Database().pool;

    try {
      final results = await conn.execute(
        """
        SELECT *
        FROM utilisateurs
        WHERE email = :email
        """,
        {'email': postnom.trim().toLowerCase()},
      );

      if (results.isEmpty) return null;

      final utilisateur = results.rows.first.assoc();

      final storedPassword = utilisateur["password"];

      if (storedPassword == null) return null;

      final isValid = BCrypt.checkpw(password, storedPassword);

      if (!isValid) return null;

      return utilisateur;
    } catch (e) {
      print("Erreur login utilisateur : $e");
      return null;
    }
  }
}
