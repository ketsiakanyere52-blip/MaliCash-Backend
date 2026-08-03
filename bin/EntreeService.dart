import 'Database.dart';
import 'package:mysql1/mysql1.dart';

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
  ) async {
    final conn = await Database.connect();

    try {
      await conn.transaction((txn) async {
        // Enregistrer l'entrée
        await txn.query(
          """
          INSERT INTO entree(
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
          [idCaisse, "ENTREE", libelle, montant],
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
    final conn = await Database.connect();

    try {
      await conn.query(
        """
        UPDATE entree
        SET
          libelle = ?,
          montant = ?
        WHERE id_entree = ?
        """,
        [libelle, montant, idEntree],
      );
    } catch (e) {
      print("Erreur modification entrée : $e");
    }
  }

  // RECUPERER LES ENTREES
  static Future<List<Map<String, dynamic>>> getEntree(int idCaisse) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
        SELECT *
        FROM entree
        WHERE id_caisse = ?
        ORDER BY date_entree DESC
        """,
        [idCaisse],
      );

      return result.map((e) => e.fields).toList();
    } catch (e) {
      print("Erreur récupération entrée : $e");
      return [];
    }
  }
}
