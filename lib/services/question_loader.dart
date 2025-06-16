import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_definition.dart';


class QuestionLoader {
  static Future<Map<String, QuestionDefinition>> loadQuestions() async {
    final jsonStr = await rootBundle.loadString('assets/anamnesis_questionnaire.json');
    final Map<String, dynamic> fullJson = jsonDecode(jsonStr);
    final List<dynamic> items = fullJson['item'] ?? [];

    Map<String, QuestionDefinition> mapping = {};
    for (var item in items) {
      final def = QuestionDefinition.fromJson(item);
      if (def.linkId.isNotEmpty) {
        mapping[def.linkId] = def;
      }
    }
    return mapping;
  }
}
