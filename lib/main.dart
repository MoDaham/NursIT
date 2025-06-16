import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(AnamneseApp());

class AnamneseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anamnese Analyse',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AnamneseHome(),
    );
  }
}

