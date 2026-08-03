import 'Database.dart';
import 'package:mysql1/mysql1.dart';

class MouvementCaisseService {
  int idMouvement;
  int idCaisse;
  String typeMouvement;
  String libelle;
  double montant;
  DateTime dateMouvement;

  MouvementCaisseService({
    required this.idMouvement,
    required this.idCaisse,
    required this.typeMouvement,
    required this.libelle,
    required this.montant,
    required this.dateMouvement,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_mouvement": idMouvement,
      "id_caisse": idCaisse,
      "type_mouvement": typeMouvement,
      "libelle": libelle,
      "montant": montant,
      "date_mouvement": dateMouvement.toString(),
    };
  }

  // TOUS LES MOUVEMENTS
  static Future<List<Map<String, dynamic>>> getMouvementCaisse(
    int idCaisse,
  ) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
        SELECT *
        FROM mouvement_caisse
        WHERE id_caisse = ?
        ORDER BY date_mouvement DESC
        """,
        [idCaisse],
      );

      return result.map((e) => e.fields).toList();
    } catch (e) {
      print("Erreur chargement mouvements : $e");
      return [];
    }
  }

  // HISTORIQUE COMPLET
  static Future<List<Map<String, dynamic>>> historiqueCaisse(
    int idCaisse,
  ) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
        SELECT
            id_mouvement,
            type_mouvement,
            libelle,
            montant,
            date_mouvement
        FROM mouvement_caisse
        WHERE id_caisse = ?
        ORDER BY date_mouvement DESC
        """,
        [idCaisse],
      );

      return result.map((e) => e.fields).toList();
    } catch (e) {
      print("Erreur historique : $e");
      return [];
    }
  }

  // HISTORIQUE PAR PERIODE
  static Future<List<Map<String, dynamic>>> historiqueParPeriode(
    int idCaisse,
    String dateDebut,
    String dateFin,
  ) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
      SELECT
          id_mouvement,
          type_mouvement,
          libelle,
          montant,
          date_mouvement
      FROM mouvement_caisse
      WHERE id_caisse = ?
        AND DATE(date_mouvement) BETWEEN ? AND ?
      ORDER BY date_mouvement DESC
      """,
        [idCaisse, dateDebut, dateFin],
      );

      return result.map((e) => e.fields).toList();
    } catch (e) {
      print("Erreur historique période : $e");
      return [];
    }
  }

  // GRAPHIQUE PAR PERIODE
  static Future<List<Map<String, dynamic>>> graphiqueParPeriode(
    int idCaisse,
    String dateDebut,
    String dateFin,
  ) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
      SELECT
          DATE(date_mouvement) AS jour,

          SUM(
            CASE
              WHEN type_mouvement='ENTREE' THEN montant
              ELSE 0
            END
          ) AS total_entree,

          SUM(
            CASE
              WHEN type_mouvement='SORTIE' THEN montant
              ELSE 0
            END
          ) AS total_sortie

      FROM mouvement_caisse

      WHERE id_caisse=?
      AND DATE(date_mouvement) BETWEEN ? AND ?

      GROUP BY DATE(date_mouvement)

      ORDER BY DATE(date_mouvement)
      """,
        [idCaisse, dateDebut, dateFin],
      );

      return result.map((e) => e.fields).toList();
    } catch (e) {
      print("Erreur graphique période : $e");
      return [];
    }
  }

  // SOLDE ACTUEL
  static Future<double> soldeCaisse(int idCaisse) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
        SELECT
            c.solde_initial
            +
            (
                SELECT IFNULL(SUM(montant),0)
                FROM entree
                WHERE id_caisse = ?
            )
            -
            (
                SELECT IFNULL(SUM(montant),0)
                FROM sortie
                WHERE id_caisse = ?
            )
            AS solde
        FROM caisse c
        WHERE c.id_caisse = ?
        LIMIT 1
        """,
        [idCaisse, idCaisse, idCaisse],
      );

      if (result.isEmpty) return 0;

      return (result.first["solde"] as num).toDouble();
    } catch (e) {
      print("Erreur solde : $e");
      return 0;
    }
  }

  // RAPPORT JOURNALIER
  static Future<Map<String, dynamic>> rapportJournalier(int idCaisse) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
      SELECT

      (SELECT IFNULL(SUM(montant),0)
      FROM entree
      WHERE id_caisse = ?
      AND DATE(date_entree)=CURDATE()) AS total_entree,

      (SELECT IFNULL(SUM(montant),0)
      FROM sortie
      WHERE id_caisse = ?
      AND DATE(date_sortie)=CURDATE()) AS total_sortie,

      (SELECT COUNT(*)
      FROM entree
      WHERE id_caisse = ?
      AND DATE(date_entree)=CURDATE()) AS nombre_entree,

      (SELECT COUNT(*)
      FROM sortie
      WHERE id_caisse = ?
      AND DATE(date_sortie)=CURDATE()) AS nombre_sortie
      """,
        [idCaisse, idCaisse, idCaisse, idCaisse],
      );

      return result.first.fields;
    } catch (e) {
      print("Erreur rapport journalier : $e");

      return {};
    }
  }

  // RAPPORT MENSUEL
  static Future<Map<String, dynamic>> rapportMensuel(int idCaisse) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
      SELECT

      (SELECT IFNULL(SUM(montant),0)
      FROM entree
      WHERE id_caisse=?
      AND MONTH(date_entree)=MONTH(CURDATE())
      AND YEAR(date_entree)=YEAR(CURDATE())) AS total_entree,

      (SELECT IFNULL(SUM(montant),0)
      FROM sortie
      WHERE id_caisse=?
      AND MONTH(date_sortie)=MONTH(CURDATE())
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS total_sortie,

      (SELECT COUNT(*)
      FROM entree
      WHERE id_caisse=?
      AND MONTH(date_entree)=MONTH(CURDATE())
      AND YEAR(date_entree)=YEAR(CURDATE())) AS nombre_entree,

      (SELECT COUNT(*)
      FROM sortie
      WHERE id_caisse=?
      AND MONTH(date_sortie)=MONTH(CURDATE())
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS nombre_sortie
      """,
        [idCaisse, idCaisse, idCaisse, idCaisse],
      );

      return result.first.fields;
    } catch (e) {
      print("Erreur rapport mensuel : $e");

      return {};
    }
  }

  // RAPPORT ANNUEL
  static Future<Map<String, dynamic>> rapportAnnuel(int idCaisse) async {
    final conn = await Database.connect();

    try {
      final result = await conn.query(
        """
      SELECT

      (SELECT IFNULL(SUM(montant),0)
      FROM entree
      WHERE id_caisse=?
      AND YEAR(date_entree)=YEAR(CURDATE())) AS total_entree,

      (SELECT IFNULL(SUM(montant),0)
      FROM sortie
      WHERE id_caisse=?
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS total_sortie,

      (SELECT COUNT(*)
      FROM entree
      WHERE id_caisse=?
      AND YEAR(date_entree)=YEAR(CURDATE())) AS nombre_entree,

      (SELECT COUNT(*)
      FROM sortie
      WHERE id_caisse=?
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS nombre_sortie
      """,
        [idCaisse, idCaisse, idCaisse, idCaisse],
      );

      return result.first.fields;
    } catch (e) {
      print("Erreur rapport annuel : $e");

      return {};
    }
  }

  static Future<List<Map<String, dynamic>>> graphiqueCaisse(
    int idCaisse,
    String? dateDebut,
    String? dateFin,
  ) async {
    final conn = await Database.connect();

    String sql = """
    SELECT 
      DATE(date_mouvement) AS date,
      SUM(CASE 
        WHEN type_mouvement = 'ENTREE' 
        THEN montant 
        ELSE 0 
      END) AS entree,

      SUM(CASE 
        WHEN type_mouvement = 'SORTIE' 
        THEN montant 
        ELSE 0 
      END) AS sortie

    FROM mouvement_caisse

    WHERE id_caisse = ?
  """;

    List<dynamic> params = [idCaisse];

    if (dateDebut != null && dateFin != null) {
      sql += """
      AND DATE(date_mouvement) 
      BETWEEN ? AND ?
    """;

      params.add(dateDebut);
      params.add(dateFin);
    }

    sql += """
    GROUP BY DATE(date_mouvement)
    ORDER BY DATE(date_mouvement)
  """;

    final result = await conn.query(sql, params);

    return result.map((row) {
      return {
        "date": row['date'].toString(),
        "entree": double.parse(row['entree'].toString()),
        "sortie": double.parse(row['sortie'].toString()),
      };
    }).toList();
  }
}
