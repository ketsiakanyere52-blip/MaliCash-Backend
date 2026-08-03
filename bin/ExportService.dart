/*import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfService {
  static Future<File?> exportRapportCaisse(
    Map<String, dynamic> rapport,

    List<Map<String, dynamic>> mouvements,
  ) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              pw.Center(
                child: pw.Text(
                  "Rapport de caisse",

                  style: pw.TextStyle(fontSize: 20),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text("Date : ${DateTime.now()}"),

              pw.SizedBox(height: 10),

              pw.Text("Solde actuel : ${rapport["solde"]}"),

              pw.Text("Total entrée : ${rapport["total_entree"]}"),

              pw.Text("Total sortie : ${rapport["total_sortie"]}"),

              pw.SizedBox(height: 20),

              pw.Text(
                "Historique des mouvements",

                style: pw.TextStyle(fontSize: 16),
              ),

              pw.Table.fromTextArray(
                headers: ["Type", "Libelle", "Montant", "Date"],

                data: mouvements.map((m) {
                  return [
                    m["type_mouvement"],

                    m["libelle"],

                    m["montant"].toString(),

                    m["date_mouvement"].toString(),
                  ];
                }).toList(),
              ),
            ];
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();

      final file = File("${directory.path}/rapport_caisse.pdf");

      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      print("Erreur génération PDF : $e");

      return null;
    }
  }
}
*/
