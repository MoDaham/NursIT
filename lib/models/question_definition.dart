// lib/models/question_definition.dart
class QuestionDefinition {
  final String linkId;
  final String text;
  final List<String> answerOptions;

  QuestionDefinition({
    required this.linkId,
    required this.text,
    required this.answerOptions,
  });

  factory QuestionDefinition.fromJson(Map<String, dynamic> json) {
    List<String> options = [];
    if (json["answer"] != null && json["answer"] is List) {
      for (var a in json["answer"]) {
        if (a["valueString"] != null) options.add(a["valueString"]);
      }
    }
    return QuestionDefinition(
      linkId: json["linkId"] ?? '',
      text: json["text"] ?? '',
      answerOptions: options,
    );
  }
}

