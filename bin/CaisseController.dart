import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'CaisseService.dart';

class CaisseController {
  // CREER CAISSE
  static Future<Response> createCaisse(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await CaisseService.createCaisse(
        int.parse(data["id_entreprise"].toString()),

        data["nom"],

        double.parse(data["solde_initial"].toString()),
      );

      return Response.ok(
        jsonEncode({"success": true, "message": "Caisse créée avec succès"}),

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

  // MODIFIER CAISSE
  static Future<Response> modifierCaisse(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await CaisseService.modifierCaisse(
        int.parse(data["id_caisse"].toString()),

        data["nom"],

        double.parse(data["solde_initial"].toString()),
      );

      return Response.ok(
        jsonEncode({"success": true, "message": "Caisse modifiée avec succès"}),

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

  // SUPPRIMER CAISSE
  static Future<Response> supprimerCaisse(Request request) async {
    try {
      final id = int.parse(["id"].toString());

      await CaisseService.supprimerCaisse(id);

      return Response.ok(
        jsonEncode({
          "success": true,

          "message": "Caisse supprimée avec succès",
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

  // GET CAISSE D'UNE ENTREPRISE
  static Future getCaisse(Request request, String id) async {
    try {
      final idEntreprise = int.parse(id);

      final caisse = await CaisseService.getCaisse(idEntreprise);

      return Response.ok(
        jsonEncode(caisse ?? {}),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e, stack) {
      print("Erreur récupération caisse : $e");
      print(stack);

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),
        headers: {"Content-Type": "application/json"},
      );
    }
  }
}
