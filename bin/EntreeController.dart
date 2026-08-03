import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'EntreeService.dart';

class EntreeController {
  // CREER ENTREE
  static Future<Response> createEntree(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await EntreeService.createEntree(
        int.parse(data["id_caisse"].toString()),
        data["libelle"],
        double.parse(data["montant"].toString()),
      );

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Entrée enregistrée avec succès.",
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

  // MODIFIER ENTREE
  static Future<Response> modifierEntree(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await EntreeService.modifierEntree(
        int.parse(data["id_entree"].toString()),
        data["libelle"],
        double.parse(data["montant"].toString()),
      );

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Entrée modifiée avec succès.",
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

  // RECUPERER LES ENTREES
  static Future<Response> getEntree(Request request) async {
    try {
      final idCaisse = int.parse(["id_caisse"].toString());

      final entrees = await EntreeService.getEntree(idCaisse);

      return Response.ok(
        jsonEncode(entrees),
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
