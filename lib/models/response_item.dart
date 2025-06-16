// lib/models/response_item.dart
import 'package:flutter/cupertino.dart';

class ResponseItem {
  final String text;
  final String answer;

  ResponseItem({required this.text, required this.answer});

  factory ResponseItem.fromJson(Map<String, dynamic> json) => ResponseItem(
    text: json['text'] ?? '',
    answer: json['answer'] ?? '',
  );

  get linkId => null;

  Map<String, dynamic> toJson() => {
    "text": text,
    "answer": answer,
  };
}

