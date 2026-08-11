import 'Database.dart';

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
    final conn = Database().pool;
    try {
      final verif = await conn.execute(
        """
        SELECT COUNT(*) AS total
        FROM caisse
        WHERE id_entreprise = :id
        """,
        {'id': idEntreprise},
      );

      final total = verif.rows.first.assoc()["total"] as int;

      if (total > 0) {
        throw Exception("Cette entreprise possède déjà une caisse.");
      }

      await conn.execute(
        """
        INSERT INTO caisse(
          id_entreprise,
          nom,
          solde_initial
        )
        VALUES(:idEntreprise, :nom, :soldeInitial)
        """,
        {
          'idEntreprise': idEntreprise,
          'nom': nom,
          'soldeInitial': soldeInitial,
        },
      );
    } catch (e) {
      print("Erreur création caisse : $e");
    }
  }

  // MODIFIER une CAISSE
  static Future modifierCaisse(
    int idCaisse,
    String nom,
    double soldeInitial,
  ) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        """
        UPDATE caisse
        SET
          nom = :nom,
          solde_initial = :soldeInitial

        WHERE id_caisse = :idCaisse
        """,
        {'nom': nom, 'soldeInitial': soldeInitial, 'idCaisse': idCaisse},
      );
    } catch (e) {
      print("Erreur modification caisse : $e");
    }
  }

  // SUPPRIMER CAISSE
  static Future supprimerCaisse(int idCaisse) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        """
        DELETE FROM caisse
        WHERE id_caisse = :idCaisse
        """,
        {'idCaisse': idCaisse},
      );
    } catch (e) {
      print("Erreur suppression caisse : $e");
    }
  }

  // RECUPERER LA CAISSE D'UNE ENTREPRISE
  static Future<Map<String, dynamic>?> getCaisse(int idEntreprise) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
SELECT *
FROM caisse
WHERE id_entreprise = :idEntreprise
LIMIT 1
""",
        {'idEntreprise': idEntreprise},
      );

      if (result.isEmpty) {
        return null;
      }

      final caisse = Map<String, dynamic>.from(result.rows.first.assoc());

      caisse["date_creation"] = caisse["date_creation"]?.toString();

      return caisse;
    } catch (e) {
      print("Erreur get caisse : $e");
      return null;
    }
  }

  static Map<String, dynamic> convertirDate(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is DateTime) {
        data[key] = value.toIso8601String();
      }
    });

    return data;
  }
}
