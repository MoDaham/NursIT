# Anamnese Analyse App – NURSIT

Eine Flutter-Webanwendung zur Analyse von Anamnese-Transkripten und zur Ausgabe strukturierter FHIR-konformer Antworten im CSV-Format.

## Projektüberblick

Die App nimmt ein medizinisches Gesprächsprotokoll (Transkript) entgegen, analysiert es mithilfe einer GPT-basierten API und ordnet die Inhalte einem standardisierten Anamnesebogen zu. Das Ergebnis kann als CSV exportiert werden.

![Screenshot 2025-06-15 214657](https://github.com/user-attachments/assets/2c454628-fae0-4f5c-b19d-d35edd583bf1)


## Projektstruktur

- `lib/models/`: Datenmodelle wie `ResponseItem` und `QuestionDefinition`
- `lib/services/`: API-Kommunikation, CSV-Export und Frage-Ladefunktion
- `lib/screens/`: Hauptansicht mit Textfeld, Ladeanzeige und Analysebutton
- `assets/anamnesis_questionnaire.json`: JSON-Schema des Fragebogens
- `pubspec.yaml`: Projektabhängigkeiten

## Ausführen des Projekts

```bash
flutter pub get
flutter run -d chrome
