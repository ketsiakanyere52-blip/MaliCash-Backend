import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../Database.dart';

Middleware authMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      try {
        final authorization = request.headers['authorization'];
        if (authorization == null) {
          return Response(401, body: 'Token manquant');
        }
        if (!authorization.startsWith('Bearer ')) {
          return Response(401, body: 'Format du token incorrect');
        }
        final token = authorization.substring(7);
        final jwt = JWT.verify(token, SecretKey(env['JWT_SECRET']!));
        final idUtilisateur = jwt.payload['id_utilisateur'];
        final idEntreprise = jwt.payload['id_entreprise'];
        final estAdmin = jwt.payload['est_admin'];

        print('Utilisateur : $idUtilisateur');
        print('Entreprise : $idEntreprise');
        print('Admin : $estAdmin');

        final nouvelleRequest = request.change(
          context: {
            'id_utilisateur': idUtilisateur,
            'id_entreprise': idEntreprise,
            'est_admin': estAdmin,
          },
        );

        return handler(nouvelleRequest);
      } catch (e) {
        print('JWT invalide : $e');

        return Response(401, body: 'Token invalide ou expire');
      }
    };
  };
}
