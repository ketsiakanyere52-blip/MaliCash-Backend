import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'Routes.dart';
import 'Database.dart';

void main() async {
  try {
    await Database().init();
    print("MySQL connecté");
  } catch (e) {
    print("Erreur MySQL : $e");
  }

  final Auth = Routes();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(Auth.router.call);
  // SERVER
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8880);

  print("Server lancé sur http://${server.address.host}:${server.port}");
}
