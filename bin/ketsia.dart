import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'Routes.dart';
import 'Database.dart';

void main() async {
  // MYSQL
  try {
    final conn = await Database.connect();

    print("MySQL connecté");
  } catch (e) {
    print("Erreur MySQL : $e");
  }

  // ROUTER
  final Auth = Routes();

  // PIPELINE

  final handler = Pipeline()
      .addMiddleware(logRequests()) //  global (optionnel)
      .addHandler(Auth.router);
  // SERVER
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8880);

  print("Server lancé sur http://${server.address.host}:${server.port}");
}
