import 'Database.dart';
import 'package:mysql1/mysql1.dart';

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
  ) async {
    final conn = await Database.connect();

    try {
      await conn.transaction((txn) async {
        // Enregistrer la sortie
        await txn.query(
          """
          INSERT INTO sortie(
            id_caisse,
            libelle,
            montant
          )
          VALUES(?,?,?)
          """,
          [idCaisse, libelle, montant],
        );

        // Enregistrer le mouvement de caisse
        await txn.query(
          """
          INSERT INTO mouvement_caisse(
            id_caisse,
            type_mouvement,
            libelle,
            montant
          )
          VALUES(?,?,?,?)
          """,
          [idCaisse, "SORTIE", libelle, montant],
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
    final conn = await Database.connect();

    try {
      await conn.query(
        """
        UPDATE sortie
        SET
          libelle = ?,
          montant = ?
        WHERE id_sortie = ?
        """,
        [libelle, montant, idSortie],
      );
    } catch (e) {
      print("Erreur modification sortie : $e");
    }
  }

  // RECUPERER LES SORTIES
  static Future<List<Map<String, dynamic>>> getSortie(int idCaisse) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
        SELECT *
        FROM sortie
        WHERE id_caisse = ?
        ORDER BY date_sortie DESC
        """,
        [idCaisse],
      );

      return result.map((e) => e.fields).toList();
    } catch (e) {
      print("Erreur récupération sortie : $e");
      return [];
    }
  }
}
