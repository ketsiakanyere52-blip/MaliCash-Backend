import 'Database.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:mysql1/mysql1.dart';

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

  // CREER UTILISATEUR
  static Future createUtilisateur(
    int idEntreprise,
    String nom,
    String postnom,
    String password,
    String telephone,
    String email,
  ) async {
    final conn = await Database.connect();

    try {
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      await conn.query(
        """
        INSERT INTO utilisateurs(
          id_entreprise,
          nom,
          postnom,
          password,
          telephone,
          email
        )
        VALUES(?,?,?,?,?,?)
        """,
        [
          idEntreprise,
          nom,
          postnom.trim().toLowerCase(),
          hashedPassword,
          telephone,
          email.trim().toLowerCase(),
        ],
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
    final conn = await Database.connect();

    try {
      await conn.query(
        """
        UPDATE utilisateurs
        SET
          nom = ?,
          postnom = ?,
          telephone = ?,
          email = ?
        WHERE id_utilisateur = ?
        """,
        [
          nom,
          postnom.trim().toLowerCase(),
          telephone,
          email.trim().toLowerCase(),
          idUtilisateur,
        ],
      );
    } catch (e) {
      print("Erreur modification utilisateur : $e");
    }
  }

  // SUPPRIMER UTILISATEUR
  static Future supprimerUtilisateur(int idUtilisateur) async {
    final conn = await Database.connect();

    try {
      await conn.query("DELETE FROM utilisateurs WHERE id_utilisateur = ?", [
        idUtilisateur,
      ]);
    } catch (e) {
      print("Erreur suppression utilisateur : $e");
    }
  }

  // RECUPERER LES UTILISATEURS
  static Future<List<Map<String, dynamic>>> getUtilisateur(
    int idEntreprise,
  ) async {
    final conn = await Database.connect();

    try {
      final results = await conn.query(
        """
        SELECT *
        FROM utilisateurs
        WHERE id_entreprise = ?
        ORDER BY nom ASC
        """,
        [idEntreprise],
      );

      return results.map((e) => e.fields).toList();
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
    final conn = await Database.connect();

    try {
      final results = await conn.query(
        """
        SELECT *
        FROM utilisateurs
        WHERE email = ?
        """,
        [postnom.trim().toLowerCase()],
      );

      if (results.isEmpty) return null;

      final utilisateur = results.first.fields;

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
