import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'SortieService.dart';

class SortieController {
  // CREER SORTIE
  static Future<Response> createSortie(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);
      final utilisateur = request.context["id_utilisateur"];

      if (utilisateur == null) {
        return Response(
          401,
          body: jsonEncode({
            "success": false,
            "message": "utilisateur non authentifie",
          }),
        );
      }
      await SortieService.createSortie(
        int.parse(data["id_caisse"].toString()),

        data["libelle"],

        double.parse(data["montant"].toString()),
        int.parse(utilisateur.toString()),
      );

      return Response.ok(
        jsonEncode({
          "success": true,

          "message": "Sortie enregistrée avec succès.",
        }),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response(
        500,

        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // MODIFIER SORTIE
  static Future<Response> modifierSortie(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await SortieService.modifierSortie(
        int.parse(data["id_sortie"].toString()),

        data["libelle"],

        double.parse(data["montant"].toString()),
      );

      return Response.ok(
        jsonEncode({
          "success": true,

          "message": "Sortie modifiée avec succès.",
        }),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response(
        500,

        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // RECUPERER LES SORTIES
  static Future<Response> getSortie(Request request) async {
    try {
      final idCaisse = int.parse(["id_caisse"].toString());

      final sorties = await SortieService.getSortie(idCaisse);

      return Response.ok(
        jsonEncode(sorties),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response(
        500,

        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }
}
