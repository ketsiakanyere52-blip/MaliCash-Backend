import 'Database.dart';

class EntreeService {
  int idEntree;
  int idCaisse;
  String libelle;
  double montant;
  DateTime dateEntree;

  EntreeService({
    required this.idEntree,
    required this.idCaisse,
    required this.libelle,
    required this.montant,
    required this.dateEntree,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_entree": idEntree,
      "id_caisse": idCaisse,
      "libelle": libelle,
      "montant": montant,
      "date_entree": dateEntree.toString(),
    };
  }

  // CREER ENTREE
  static Future createEntree(
    int idCaisse,
    String libelle,
    double montant,
    int idUtilisateur,
  ) async {
    final conn = Database().pool;

    try {
      await conn.transactional((txn) async {
        // Enregistrer l'entrée
        await txn.execute(
          """
          INSERT INTO entree(
            id_caisse,
            libelle,
            montant,
            id_utilisateur
          )
          VALUES(:idCaisse, :libelle, :montant, :id_utilisateur)
          """,
          {
            'idCaisse': idCaisse,
            'libelle': libelle,
            'montant': montant,
            'id_utilisateur': idUtilisateur,
          },
        );

        // Enregistrer le mouvement de caisse
        await txn.execute(
          """
          INSERT INTO mouvement_caisse(
            id_caisse,
            type_mouvement,
            libelle,
            montant
          )
          VALUES(:idCaisse, :typeMouvement, :libelle, :montant)
          """,
          {
            'idCaisse': idCaisse,
            'typeMouvement': "ENTREE",
            'libelle': libelle,
            'montant': montant,
          },
        );
      });
    } catch (e) {
      print("Erreur création entrée : $e");
    }
  }

  // MODIFIER ENTREE
  static Future modifierEntree(
    int idEntree,
    String libelle,
    double montant,
  ) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        """
        UPDATE entree
        SET
          libelle = :libelle,
          montant = :montant
        WHERE id_entree = :idEntree
        """,
        {'libelle': libelle, 'montant': montant, 'idEntree': idEntree},
      );
    } catch (e) {
      print("Erreur modification entrée : $e");
    }
  }

  // RECUPERER LES ENTREES
  static Future<List<Map<String, dynamic>>> getEntree(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
        SELECT *
        FROM entree
        WHERE id_caisse = :idCaisse
        ORDER BY date_entree DESC
        """,
        {'idCaisse': idCaisse},
      );

      return result.rows.map((e) => e.assoc()).toList();
    } catch (e) {
      print("Erreur récupération entrée : $e");
      return [];
    }
  }
}
