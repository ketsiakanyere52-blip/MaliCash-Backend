import 'Database.dart';
import 'package:mysql1/mysql1.dart';

class CaisseService {
  int idCaisse;
  int idEntreprise;
  String nom;
  double soldeInitial;

  CaisseService({
    required this.idCaisse,
    required this.idEntreprise,
    required this.nom,
    required this.soldeInitial,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_caisse': idCaisse,
      'id_entreprise': idEntreprise,
      'nom': nom,
      'solde_initial': soldeInitial,
    };
  }

  // CREER CAISSE
  static Future createCaisse(
    int idEntreprise,
    String nom,
    double soldeInitial,
  ) async {
    final conn = await Database.connect();

    try {
      // Vérifier si l'entreprise possède déjà une caisse

      final verif = await conn.query(
        """
        SELECT COUNT(*) AS total
        FROM caisse
        WHERE id_entreprise = ?
        """,
        [idEntreprise],
      );

      final total = verif.first["total"] as int;

      if (total > 0) {
        throw Exception("Cette entreprise possède déjà une caisse.");
      }

      await conn.query(
        """
        INSERT INTO caisse(
          id_entreprise,
          nom,
          solde_initial
        )
        VALUES(?,?,?)
        """,
        [idEntreprise, nom, soldeInitial],
      );
    } catch (e) {
      print("Erreur création caisse : $e");
    }
  }

  // MODIFIER CAISSE
  static Future modifierCaisse(
    int idCaisse,
    String nom,
    double soldeInitial,
  ) async {
    final conn = await Database.connect();

    try {
      await conn.query(
        """
        UPDATE caisse
        SET
          nom = ?,
          solde_initial = ?

        WHERE id_caisse = ?
        """,
        [nom, soldeInitial, idCaisse],
      );
    } catch (e) {
      print("Erreur modification caisse : $e");
    }
  }

  // SUPPRIMER CAISSE
  static Future supprimerCaisse(int idCaisse) async {
    final conn = await Database.connect();

    try {
      await conn.query(
        """
        DELETE FROM caisse
        WHERE id_caisse = ?
        """,
        [idCaisse],
      );
    } catch (e) {
      print("Erreur suppression caisse : $e");
    }
  }

  // RECUPERER LA CAISSE D'UNE ENTREPRISE
  static Future<Map<String, dynamic>?> getCaisse(int idEntreprise) async {
    final conn = await Database.connect();
    final results = await conn.query(
      "SELECT * FROM caisse WHERE id_entreprise=? LIMIT 1",
      [idEntreprise],
    );

    if (results.isEmpty) {
      return null;
    }

    final data = Map<String, dynamic>.from(results.first.fields);

    data.forEach((key, value) {
      if (value is DateTime) {
        data[key] = value.toIso8601String();
      }
    });

    return data;
  }
}
