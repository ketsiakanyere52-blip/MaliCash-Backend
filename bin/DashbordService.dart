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
          (data["solde_initial"] as num).toDouble() +
          (data["total_entree"] as num).toDouble() -
          (data["total_sortie"] as num).toDouble();

      data["solde_actuel"] = solde;

      return data;
    } catch (e) {
      print("Erreur dashboard : $e");

      return {};
    }
  }
}
