import 'package:shelf/shelf.dart';
import 'AuthMiddware.dart';

Middleware adminMiddleware() {
  return (Handler handler) {
    return authMiddleware()((Request request) async {
      final estAdmin = request.context['est_admin'];

      final idUtilisateur = request.context['id_utilisateur'];
      final idEntreprise = request.context['id_entreprise'];

      print('===== ADMIN MIDDLEWARE =====');
      print('Utilisateur : $idUtilisateur');
      print('Entreprise : $idEntreprise');
      print('Admin : $estAdmin');
      print('============================');

      if (estAdmin != true) {
        return Response.forbidden('Accès refusé : administrateur uniquement');
      }

      return handler(request);
    });
  };
}
