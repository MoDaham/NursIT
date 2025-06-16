// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/csv_exporter.dart';
import '../models/response_item.dart';
import '../models/question_definition.dart';
import '../services/question_loader.dart';

class AnamneseHome extends StatefulWidget {
  @override
  _AnamneseHomeState createState() => _AnamneseHomeState();
}

class _AnamneseHomeState extends State<AnamneseHome> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<ResponseItem> _results = [];
  Map<String, QuestionDefinition> _questionMap = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await QuestionLoader.loadQuestions();
    setState(() => _questionMap = questions);
  }

  Future<void> _analyzeText() async {
    setState(() => _loading = true);
    final response = await ApiService.analyzeTranscript(_controller.text);
    setState(() {
      _results = response;
      _loading = false;
    });
  }

  Future<void> _exportCSV() async {
    await CsvExporter.export(_results); // Richtiger Aufruf wie in response ithem
  }

  Widget _buildAnswerTile(ResponseItem item) {
    final question = _questionMap[item.text];
    if (question == null) {
      return ListTile(
        title: Text(item.text),
        subtitle: Text(item.answer),
      );
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...question.answerOptions.map((opt) => CheckboxListTile(
                  value: opt.contains(item.answer),
                  title: Text(opt),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: null,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPT-Analyse der Anamnese'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Interview-Transkript hier einfügen',
              ),
            ),
            const SizedBox(height: 16),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _analyzeText,
                    child: Text('✓ Analyse starten'),
                  ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return _buildAnswerTile(_results[index]);
                },
              ),
            ),
            if (_results.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton.icon(
                  onPressed: _exportCSV,
                  icon: Icon(Icons.download),
                  label: Text('Export als CSV'),
                ),
              )
          ],
        ),
      ),
    );
  }
}

