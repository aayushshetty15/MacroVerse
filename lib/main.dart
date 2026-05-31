import 'package:flutter/material.dart';
import 'package:macroverse/screens/dashboard_screen.dart';

void main() {
  runApp(const MacroVerseApp());
}

class MacroVerseApp extends StatelessWidget {
  const MacroVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MacroVerse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DashboardScreen(),
    );
  }
}
