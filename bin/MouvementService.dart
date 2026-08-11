import 'Database.dart';

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
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
        SELECT *
        FROM mouvement_caisse
        WHERE id_caisse = :idCaisse
        ORDER BY date_mouvement DESC
        """,
        {'idCaisse': idCaisse},
      );

      return result.rows.map((e) => e.assoc()).toList();
    } catch (e) {
      print("Erreur chargement mouvements : $e");
      return [];
    }
  }

  // HISTORIQUE COMPLET
  static Future<List<Map<String, dynamic>>> historiqueCaisse(
    int idCaisse,
  ) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
        SELECT
            id_mouvement,
            type_mouvement,
            libelle,
            montant,
            date_mouvement
        FROM mouvement_caisse
        WHERE id_caisse = :idCaisse
        ORDER BY date_mouvement DESC
        """,
        {'idCaisse': idCaisse},
      );

      return result.rows.map((e) => e.assoc()).toList();
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
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
      SELECT
          id_mouvement,
          type_mouvement,
          libelle,
          montant,
          date_mouvement
      FROM mouvement_caisse
      WHERE id_caisse = :idCaisse
        AND DATE(date_mouvement) BETWEEN :dateDebut AND :dateFin
      ORDER BY date_mouvement DESC
      """,
        {'idCaisse': idCaisse, 'dateDebut': dateDebut, 'dateFin': dateFin},
      );

      return result.rows.map((e) => e.assoc()).toList();
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
    final conn = Database().pool;

    try {
      final result = await conn.execute(
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

      WHERE id_caisse= :idCaisse
      AND DATE(date_mouvement) BETWEEN :dateDebut AND :dateFin

      GROUP BY DATE(date_mouvement)

      ORDER BY DATE(date_mouvement)
      """,
        {'idCaisse': idCaisse, 'dateDebut': dateDebut, 'dateFin': dateFin},
      );

      return result.rows.map((e) => e.assoc()).toList();
    } catch (e) {
      print("Erreur graphique période : $e");
      return [];
    }
  }

  // SOLDE ACTUEL
  static Future<double> soldeCaisse(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
        SELECT
            c.solde_initial
            +
            (
                SELECT IFNULL(SUM(montant),0)
                FROM entree
                WHERE id_caisse = :idCaisse
            )
            -
            (
                SELECT IFNULL(SUM(montant),0)
                FROM sortie
                WHERE id_caisse = :idCaisse
            )
            AS solde
        FROM caisse c
        WHERE c.id_caisse = :idCaisse
        LIMIT 1
        """,
        {'idCaisse': idCaisse},
      );

      if (result.isEmpty) return 0;

      return double.tryParse(result.rows.first.assoc()["solde"]) ?? 0;
    } catch (e) {
      print("Erreur solde : $e");
      return 0;
    }
  }

  // RAPPORT JOURNALIER
  static Future<Map<String, dynamic>> rapportJournalier(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
      SELECT

      (SELECT IFNULL(SUM(montant),0)
      FROM entree
      WHERE id_caisse = :idCaisse
      AND DATE(date_entree)=CURDATE()) AS total_entree,

      (SELECT IFNULL(SUM(montant),0)
      FROM sortie
      WHERE id_caisse = :idCaisse
      AND DATE(date_sortie)=CURDATE()) AS total_sortie,

      (SELECT COUNT(*)
      FROM entree
      WHERE id_caisse = :idCaisse
      AND DATE(date_entree)=CURDATE()) AS nombre_entree,

      (SELECT COUNT(*)
      FROM sortie
      WHERE id_caisse = :idCaisse
      AND DATE(date_sortie)=CURDATE()) AS nombre_sortie
      """,
        {'idCaisse': idCaisse},
      );

      return result.rows.first.assoc();
    } catch (e) {
      print("Erreur rapport journalier : $e");

      return {};
    }
  }

  // RAPPORT MENSUEL
  static Future<Map<String, dynamic>> rapportMensuel(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
      SELECT

      (SELECT IFNULL(SUM(montant),0)
      FROM entree
      WHERE id_caisse= :idCaisse
      AND MONTH(date_entree)=MONTH(CURDATE())
      AND YEAR(date_entree)=YEAR(CURDATE())) AS total_entree,

      (SELECT IFNULL(SUM(montant),0)
      FROM sortie
      WHERE id_caisse= :idCaisse
      AND MONTH(date_sortie)=MONTH(CURDATE())
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS total_sortie,

      (SELECT COUNT(*)
      FROM entree
      WHERE id_caisse= :idCaisse
      AND MONTH(date_entree)=MONTH(CURDATE())
      AND YEAR(date_entree)=YEAR(CURDATE())) AS nombre_entree,

      (SELECT COUNT(*)
      FROM sortie
      WHERE id_caisse= :idCaisse
      AND MONTH(date_sortie)=MONTH(CURDATE())
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS nombre_sortie
      """,
        {'idCaisse': idCaisse},
      );

      return result.rows.first.assoc();
    } catch (e) {
      print("Erreur rapport mensuel : $e");

      return {};
    }
  }

  // RAPPORT ANNUEL
  static Future<Map<String, dynamic>> rapportAnnuel(int idCaisse) async {
    final conn = Database().pool;

    try {
      final result = await conn.execute(
        """
      SELECT

      (SELECT IFNULL(SUM(montant),0)
      FROM entree
      WHERE id_caisse= :idCaisse
      AND YEAR(date_entree)=YEAR(CURDATE())) AS total_entree,

      (SELECT IFNULL(SUM(montant),0)
      FROM sortie
      WHERE id_caisse= :idCaisse
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS total_sortie,

      (SELECT COUNT(*)
      FROM entree
      WHERE id_caisse= :idCaisse
      AND YEAR(date_entree)=YEAR(CURDATE())) AS nombre_entree,

      (SELECT COUNT(*)
      FROM sortie
      WHERE id_caisse= :idCaisse
      AND YEAR(date_sortie)=YEAR(CURDATE())) AS nombre_sortie
      """,
        {'idCaisse': idCaisse},
      );

      return result.rows.first.assoc();
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
    final conn = Database().pool;

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

    WHERE id_caisse = :idCaisse
  """;

    Map<String, dynamic> params = {};
    params['idCaisse'] = idCaisse;

    if (dateDebut != null && dateFin != null) {
      sql += """
      AND DATE(date_mouvement) 
      BETWEEN :dateDebut AND :dateFin
    """;

      params['dateDebut'] = dateDebut;
      params['dateFin'] = dateFin;
    }

    sql += """
    GROUP BY DATE(date_mouvement)
    ORDER BY DATE(date_mouvement)
  """;

    final result = await conn.execute(sql, params);

    return result.rows.map((e) {
      var row = e.assoc();

      return {
        "date": row['date'].toString(),
        "entree": double.parse(row['entree'].toString()),
        "sortie": double.parse(row['sortie'].toString()),
      };
    }).toList();
  }
}
