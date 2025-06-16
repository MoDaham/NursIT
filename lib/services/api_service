// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/response_item.dart';

class ApiService {
  static const String _apiKey = ""; // openAI-Key eingeben

  static Future<List<ResponseItem>> analyzeTranscript(String transcript) async {
    final prompt = '''
“Du bist eine ausgebildete Pflegekraft in einem Krankenhaus. Insbesondere bist Du darin ausgebildet Patienten während einer Anamnese zu befragen.” 
“Bitte analysiere, welche Fragen aus dem JSON ausgewertet wurden und was die Antworten sind.Für einige Fragen gibt das JSON eine Reihe von Antwortmöglichkeiten vor. In diesem Fall wähle eine der  Antworten aus. Gebe deine Antworten als ein einfaches JSON file zurück, das eine Liste enthält mit 
jeweils der linkId der Frage und deine Antwort. Gebe keine weitere Begründung für deine Antwort.” 

Analysiere den Dialog und gib ausschließlich relevante Antworten zurück - im folgenden JSON-Format:
[
  {"text": "...", "answer": "..."},
  etc ...
]
Beispeil: 
[
  {"text": "Art der Aufnahme auf die Station", "answer": "Notfall"},
  ...
]

Wichtige Regeln:

- Verwende **ausschließlich** `text`-Werte aus dem FHIR-Fragebogen.
- Für jede `text` ist exakt **eine passende Antwort (`answer`)** zurückzugeben - exakt wie in den `valueString`-Einträgen vorgegeben.
- Die `answer` muss **den vollständigen Text mit Klammer** enthalten, z.B. `"Notfall (NIT_SVAn_08_03)"`
- Wenn zu einer `text` keine Information im Transkript enthalten ist, lasse sie weg.
- Gib **keine Kommentare, keine Erklärungen, keine Einleitung**, sondern **nur ein JSON-Array** zurück.

Interview-Transkript:


''';

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "model": "gpt-4",
        "messages": [
          {"role": "user", "content": "$prompt\n$transcript"}
        ],
        "temperature": 0.2
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final raw = decoded['choices'][0]['message']['content'];

      try {
        final trimmed = raw.trim();

        // DEBUG: zeige GPT-Antwort in Konsole
        print("GPT-Rohantwort:\n$trimmed");

        // Wenn Antwort kein valides JSON beginnt, gleich Fehler
        if (!trimmed.startsWith("[")) {
          throw FormatException("Antwort beginnt nicht mit '['");
        }

        final lastClosing = trimmed.lastIndexOf("]");
        if (lastClosing == -1) {
          throw FormatException("Kein schließendes ']' gefunden");
        }

        final safeJson = trimmed.substring(0, lastClosing + 1);
        final List parsed = jsonDecode(safeJson);
        return parsed.map((e) => ResponseItem.fromJson(e)).toList();
      } catch (e) {
        return [ResponseItem(text: "Fehler", answer: "Ungültiges JSON: ${e.toString()}")];
      }
    } else {
      return [ResponseItem(text: "Fehler", answer: "HTTP ${response.statusCode}")];
    }
  }
}

