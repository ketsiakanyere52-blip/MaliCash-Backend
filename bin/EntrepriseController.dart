import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'EntrepriseService.dart';

class EntrepriseController {
  // Créer une entreprise
  static Future<Response> createEntreprise(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      await Entreprise.createEntreprise(
        data["nom"],
        data["adresse"],
        data["telephone"],
        data["email"],
        data["password"],
      );

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Entreprise enregistrée avec succès.",
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

  // Récupérer l'entreprise
  static Future<Response> getEntreprise(Request request) async {
    try {
      final entreprise = await Entreprise.getEntreprise();

      return Response.ok(
        jsonEncode(entreprise ?? {}),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      print("Erreur controller entreprise : $e");

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),
        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // Modifier l'entreprise
  static Future<Response> updateEntreprise(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      await Entreprise.modifierEntreprise(
        data["id_entreprise"],
        data["nom"],
        data["adresse"],
        data["telephone"],
        data["email"],
      );

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Entreprise modifiée avec succès.",
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

  static Future<Response> loginEntreprise(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final result = await Entreprise.loginEntreprise(
        data["email"],
        data["password"],
      );

      if (result == null) {
        return Response(
          401,

          body: jsonEncode({
            "success": false,
            "message": "Identifiants incorrects",
          }),

          headers: {"Content-Type": "application/json"},
        );
      }

      return Response.ok(
        jsonEncode({"success": true, "data": result}),

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
