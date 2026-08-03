import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'DashbordService.dart';

class DashboardController {
  static Future dashboard(Request request, String id_caisse) async {
    try {
      final idCaisse = int.parse(id_caisse);

      final data = await DashboardService.getDashboard(idCaisse);

      return Response.ok(
        jsonEncode(data),

        headers: {"Content-Type": "application/json"},
      );
    } catch (e, stack) {
      print("Erreur dashboard controller : $e");
      print(stack);

      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),

        headers: {"Content-Type": "application/json"},
      );
    }
  }
}
