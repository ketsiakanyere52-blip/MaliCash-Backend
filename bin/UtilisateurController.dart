import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'Database.dart';
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
        data["est_admin"],
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
        data["est_admin"],
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
  static Future<Response> getUtilisateur(Request request, String id) async {
    try {
      final idEntreprise = int.parse(id);

      final utilisateurs = await UtilisateurService.getUtilisateur(
        idEntreprise,
      );

      // Convertir DateTime en String pour chaque utilisateur
      final data = utilisateurs.map((utilisateur) {
        final utilisateurMap = Map<String, dynamic>.from(utilisateur);

        if (utilisateurMap["date_creation"] is DateTime) {
          utilisateurMap["date_creation"] =
              (utilisateurMap["date_creation"] as DateTime).toIso8601String();
        }

        return utilisateurMap;
      }).toList();

      return Response.ok(
        jsonEncode(data),
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

      final dat = Map<String, dynamic>.from(utilisateur);
      dat.remove('password');
      if (dat['date_creation'] != null && dat['date_creation'] is DateTime) {
        dat['date_creation'] = (dat['date_creation'] as DateTime)
            .toIso8601String();
      }
      print("Utilisateur : $utilisateur");
      print("ID utilisateur : ${utilisateur['id_utilisateur']}");
      print("ID entreprise : ${utilisateur['id_entreprise']}");
      print("Est admin : ${utilisateur['est_Admin']}");
      print("JWT SECRET : ${env['JWT_SECRET']}");
      // creation de jwt
      final jwt = JWT({
        'id_utilisateur': utilisateur['id_utilisateur'],
        'id_entreprise': utilisateur['id_entreprise'],
        'est_admin': utilisateur['est_admin'],
      });
      print(" JWT ");
      print("Payload : ${jwt.payload}");
      print("ID UTILISATEUR : ${jwt.payload["id_utilisateur"]}");
      print("ID ENTREPRISE : ${jwt.payload["id_entreprise"]}");

      // token avec notre cle
      final secret = env["JWT_SECRET"];

      if (secret == null || secret.isEmpty) {
        throw Exception("JWT_SECRET est vide ou null");
      }

      final token = jwt.sign(SecretKey(secret));

      return Response.ok(
        jsonEncode({"success": true, "data": dat, "token": token}),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e, stack) {
      print("Erreur login");
      print("Erreur login utilisateur : $e");
      print(stack);

      return Response.internalServerError(
        body: e.toString(),
        headers: {"Content-Type": "application/json"},
      );
    }
  }
}
