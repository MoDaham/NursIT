import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import '../models/response_item.dart';

class CsvExporter {
  static Future<void> export(List<ResponseItem> items) async {
    // CSV-Daten mit Überschriften erstellen
    final csvData = const ListToCsvConverter().convert([
      ["Frage", "Antwort"],
      ...items.map((e) => [e.text, e.answer])
    ]);

    // CSV in Datei umwandeln und zum Download anbieten
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "anamnese_export.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
