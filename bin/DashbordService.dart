import 'Database.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getDashboard(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
        SELECT

        c.nom,

        c.solde_initial,

        (
          SELECT IFNULL(SUM(montant),0)
          FROM entree
          WHERE id_caisse = c.id_caisse
        ) AS total_entree,

        (
          SELECT IFNULL(SUM(montant),0)
          FROM sortie
          WHERE id_caisse = c.id_caisse
        ) AS total_sortie,

        (
          SELECT COUNT(*)
          FROM entree
          WHERE id_caisse = c.id_caisse
        ) AS nombre_entree,

        (
          SELECT COUNT(*)
          FROM sortie
          WHERE id_caisse = c.id_caisse
        ) AS nombre_sortie

        FROM caisse c

        WHERE c.id_caisse = :idCaisse

        LIMIT 1
        """,
        {'idCaisse': idCaisse},
      );

      if (result.isEmpty) {
        return {};
      }

      final data = result.rows.first.assoc();

      final solde =
          (double.tryParse(data["solde_initial"].toString()) ?? 0) +
          (double.tryParse(data["total_entree"].toString()) ?? 0) -
          (double.tryParse(data["total_sortie"].toString()) ?? 0);

      data["solde_actuel"] = solde;

      return data;
    } catch (e) {
      print("Erreur dashboard : $e");

      return {};
    }
  }
}
