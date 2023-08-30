import 'package:flutter/material.dart';
import 'package:whisper_frontend/routes.dart';
import 'package:whisper_frontend/theme/theme.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisper AI',
      theme: AppTheme.theme,
      routes: routes,
    );
  }
}
