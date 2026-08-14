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
  bool estAdmin;

  UtilisateurService({
    required this.idUtilisateur,
    required this.idEntreprise,
    required this.nom,
    required this.postnom,
    required this.password,
    required this.telephone,
    required this.email,
    required this.estAdmin,
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
      'est_admin': estAdmin,
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
      estAdmin: json['est_admin'],
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
    bool estAdmin,
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
          email,
          est_admin
        )
        VALUES(:idEntreprise, :nom, :postnom, :password, :telephone, :email, :est_admin)
        """,
        {
          'idEntreprise': idEntreprise,
          'nom': nom,
          'postnom': postnom.trim().toLowerCase(),
          'password': hashedPassword,
          'telephone': telephone,
          'email': email.trim().toLowerCase(),
          'est_admin': estAdmin,
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
    bool estAdmin,
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
          est_admin = :est_admin,
          email = :email,
          est_admin = : est_admin
        WHERE id_utilisateur = :id
        """,
        {
          'nom': nom,
          'postnom': postnom.trim().toLowerCase(),
          'telephone': telephone,
          'email': email.trim().toLowerCase(),
          'est_admin': estAdmin,
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
    String email,
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
        {'email': email.trim().toLowerCase()},
      );

      if (results.rows.isEmpty) {
        print("Aucun utiliateur trouvee");

        return null;
      }
      final utilisateur = results.rows.first.assoc();
      final storedPassword = utilisateur["password"];

      if (storedPassword == null) return null;

      final isValid = BCrypt.checkpw(password, storedPassword);

      if (!isValid) return null;

      return utilisateur;
    } catch (e, stack) {
      print("Erreur login");
      print("Erreur login utilisateur : $e");
      print(stack);
      return null;
    }
  }
}
