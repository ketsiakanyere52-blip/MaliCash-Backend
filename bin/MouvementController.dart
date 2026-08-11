import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'MouvementService.dart';

class MouvementCaisseController {
  // HISTORIQUE COMPLET DE LA CAISSE
  static Future historiqueCaisse(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final historique = await MouvementCaisseService.historiqueCaisse(
        idCaisse,
      );

      return Response.ok(
        jsonEncode(convertirDate(historique)),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      print("Erreur historique caisse : $e");

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // TOUS LES MOUVEMENTS
  static Future getMouvementCaisse(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final mouvements = await MouvementCaisseService.getMouvementCaisse(
        idCaisse,
      );

      return Response.ok(
        jsonEncode(convertirDate(mouvements)),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      print("Erreur mouvements : $e");

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // SOLDE CAISSE
  static Future soldeCaisse(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final solde = await MouvementCaisseService.soldeCaisse(idCaisse);

      return Response.ok(
        jsonEncode({"solde": solde}),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // RAPPORT JOURNALIER
  static Future rapportJournalier(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final rapport = await MouvementCaisseService.rapportJournalier(idCaisse);

      return Response.ok(
        jsonEncode(convertirDate(rapport)),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // RAPPORT MENSUEL
  static Future rapportMensuel(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final rapport = await MouvementCaisseService.rapportMensuel(idCaisse);

      return Response.ok(
        jsonEncode(convertirDate(rapport)),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // RAPPORT ANNUEL
  static Future rapportAnnuel(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final rapport = await MouvementCaisseService.rapportAnnuel(idCaisse);

      return Response.ok(
        jsonEncode(convertirDate(rapport)),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // EXPORT PDF
  static Future exportPdf(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final rapport = await MouvementCaisseService.rapportJournalier(idCaisse);

      final mouvements = await MouvementCaisseService.getMouvementCaisse(
        idCaisse,
      );

      return Response.ok(
        jsonEncode({
          "success": true,

          "message": "PDF généré",

          "rapport": convertirDate(rapport),

          "mouvements": convertirDate(mouvements),
        }),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),
      );
    }
  }

  static dynamic convertirDate(dynamic valeur) {
    if (valeur is DateTime) {
      return valeur.toIso8601String();
    }

    if (valeur is Map) {
      return valeur.map((key, value) => MapEntry(key, convertirDate(value)));
    }

    if (valeur is List) {
      return valeur.map((e) => convertirDate(e)).toList();
    }

    return valeur;
  }

  // HISTORIQUE PAR PERIODE
  static Future<Response> historiqueParPeriode(
    Request request,
    String id_caisse,
  ) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final dateDebut = request.url.queryParameters['date_debut'];
      final dateFin = request.url.queryParameters['date_fin'];

      final historique = await MouvementCaisseService.historiqueParPeriode(
        idCaisse,
        dateDebut!,
        dateFin!,
      );

      return Response.ok(
        jsonEncode(convertirDate(historique)),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      print("Erreur historique période : $e");

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),
        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // GRAPHIQUE PAR PERIODE
  static Future<Response> graphiqueParPeriode(
    Request request,
    String id_caisse,
  ) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final dateDebut = request.url.queryParameters['date_debut'];
      final dateFin = request.url.queryParameters['date_fin'];

      final graphique = await MouvementCaisseService.graphiqueParPeriode(
        idCaisse,
        dateDebut!,
        dateFin!,
      );

      return Response.ok(
        jsonEncode(convertirDate(graphique)),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      print("Erreur graphique période : $e");

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),
        headers: {"Content-Type": "application/json"},
      );
    }
  }

  static Future<Response> graphiqueCaisse(
    Request request,
    String id_caisse,
  ) async {
    try {
      final params = request.url.queryParameters;

      final dateDebut = params['date_debut'];
      final dateFin = params['date_fin'];

      final data = await MouvementCaisseService.graphiqueCaisse(
        int.parse(id_caisse),
        dateDebut,
        dateFin,
      );

      return Response.ok(
        jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({
          "message": "Erreur graphique caisse",
          "error": e.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
