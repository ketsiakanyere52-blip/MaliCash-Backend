import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'UtilisateurService.dart';

class UtilisateurController {
  // CREER UTILISATEUR
  static Future<Response> createUtilisateur(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await UtilisateurService.createUtilisateur(
        int.parse(data["id_entreprise"].toString()),

        data["nom"],

        data["postnom"],

        data["password"],

        data["telephone"],

        data["email"],
      );

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Utilisateur créé avec succès",
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

  // MODIFIER UTILISATEUR
  static Future<Response> modifierUtilisateur(Request request) async {
    try {
      final body = await request.readAsString();

      final data = jsonDecode(body);

      await UtilisateurService.modifierUtilisateur(
        int.parse(data["id_utilisateur"].toString()),

        data["nom"],

        data["postnom"],

        data["telephone"],

        data["email"],
      );

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Utilisateur modifié avec succès",
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

  // SUPPRIMER UTILISATEUR
  static Future<Response> supprimerUtilisateur(Request request) async {
    try {
      final id = int.parse(["id"].toString());

      await UtilisateurService.supprimerUtilisateur(id);

      return Response.ok(
        jsonEncode({"success": true, "message": "Utilisateur supprimé"}),

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

  // GET UTILISATEURS
  static Future getUtilisateur(Request request, String id) async {
    try {
      final idEntreprise = int.parse(id);

      final utilisateurs = await UtilisateurService.getUtilisateur(
        idEntreprise,
      );

      return Response.ok(
        jsonEncode(utilisateurs),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e, stack) {
      print("ERREUR GET UTILISATEUR : $e");
      print(stack);

      return Response(
        500,
        body: jsonEncode({"success": false, "message": e.toString()}),
        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // LOGIN UTILISATEUR
  static Future<Response> loginUtilisateur(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final utilisateur = await UtilisateurService.loginUtilisateur(
        data["email"],
        data["password"],
      );

      if (utilisateur == null) {
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
        jsonEncode({"success": true, "data": utilisateur}),

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
