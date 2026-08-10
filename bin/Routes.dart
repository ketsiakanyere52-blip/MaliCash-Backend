import 'package:shelf_router/shelf_router.dart';

import 'EntrepriseController.dart';
import 'UtilisateurController.dart';
import 'CaisseController.dart';
import 'EntreeController.dart';
import 'SortieController.dart';
import 'MouvementController.dart';
import 'DashbordController.dart';

class Routes {
  final Router router = Router();

  Routes() {
    // ENTREPRISE

    router.post('/entreprise', EntrepriseController.createEntreprise);
    router.put('/entreprise', EntrepriseController.updateEntreprise);
    router.get('/entreprise', EntrepriseController.getEntreprise);
    router.post('/entreprise/login', EntrepriseController.loginEntreprise);
    // UTILISATEUR

    router.post('/utilisateur', UtilisateurController.createUtilisateur);
    router.put('/utilisateur', UtilisateurController.modifierUtilisateur);

    router.delete(
      '/utilisateur/<id>',
      UtilisateurController.supprimerUtilisateur,
    );

    router.get('/utilisateur/<id>', UtilisateurController.getUtilisateur);

    router.post('/utilisateur/login', UtilisateurController.loginUtilisateur);

    // CAISSE

    router.post('/caisse', CaisseController.createCaisse);
    router.put('/caisse', CaisseController.modifierCaisse);
    router.get('/caisse/<id>', CaisseController.getCaisse);
    // ENTREE

    router.post('/entree', EntreeController.createEntree);
    router.put('/entree', EntreeController.modifierEntree);
    router.get('/entree/<id_caisse>', EntreeController.getEntree);

    // SORTIE

    router.post('/sortie', SortieController.createSortie);
    router.put('/sortie', SortieController.modifierSortie);
    router.get('/sortie/<id_caisse>', SortieController.getSortie);

    // MOUVEMENT CAISSE

    // Tous les mouvements
    router.get(
      '/mouvement/<id_caisse>',
      MouvementCaisseController.getMouvementCaisse,
    );
    router.get(
      '/historique/<id_caisse>',
      MouvementCaisseController.historiqueCaisse,
    );
    // Solde actuel
    router.get('/solde/<id_caisse>', MouvementCaisseController.soldeCaisse);
    // RAPPORTS
    router.get(
      '/rapport/journalier/<id_caisse>',
      MouvementCaisseController.rapportJournalier,
    );
    router.get(
      '/rapport/mensuel/<id_caisse>',
      MouvementCaisseController.rapportMensuel,
    );
    router.get(
      '/rapport/annuel/<id_caisse>',
      MouvementCaisseController.rapportAnnuel,
    );
    router.get('/rapport/pdf/<id_caisse>', MouvementCaisseController.exportPdf);
    router.get(
      '/graphique/<id_caisse>',
      MouvementCaisseController.graphiqueCaisse,
    );
    // DASHBOARD
    router.get('/dashboard/<id_caisse>', DashboardController.dashboard);
  }
}
