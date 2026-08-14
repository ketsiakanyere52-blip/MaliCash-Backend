import 'Database.dart';

class SortieService {
  int idSortie;
  int idCaisse;
  String libelle;
  double montant;
  DateTime dateSortie;

  SortieService({
    required this.idSortie,
    required this.idCaisse,
    required this.libelle,
    required this.montant,
    required this.dateSortie,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_sortie": idSortie,
      "id_caisse": idCaisse,
      "libelle": libelle,
      "montant": montant,
      "date_sortie": dateSortie.toString(),
    };
  }

  // CREER SORTIE
  static Future createSortie(
    int idCaisse,
    String libelle,
    double montant,
    int idutilisateur,
  ) async {
    final conn = Database().pool;

    try {
      await conn.transactional((txn) async {
        // Enregistrer la sortie
        await txn.execute(
          """
          INSERT INTO sortie(
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
            'id_utilisateur': idutilisateur,
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
            'typeMouvement': "SORTIE",
            'libelle': libelle,
            'montant': montant,
          },
        );
      });
    } catch (e) {
      print("Erreur création sortie : $e");
    }
  }

  // MODIFIER SORTIE
  static Future modifierSortie(
    int idSortie,
    String libelle,
    double montant,
  ) async {
    final conn = Database().pool;

    try {
      await conn.execute(
        """
        UPDATE sortie
        SET
          libelle = :libelle,
          montant = :montant
        WHERE id_sortie = :idSortie
        """,
        {'libelle': libelle, 'montant': montant, 'idSortie': idSortie},
      );
    } catch (e) {
      print("Erreur modification sortie : $e");
    }
  }

  // RECUPERER LES SORTIES
  static Future<List<Map<String, dynamic>>> getSortie(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
        SELECT *
        FROM sortie
        WHERE id_caisse = :idCaisse
        ORDER BY date_sortie DESC
        """,
        {'idCaisse': idCaisse},
      );

      return result.rows.map((e) => e.assoc()).toList();
    } catch (e) {
      print("Erreur récupération sortie : $e");
      return [];
    }
  }
}
