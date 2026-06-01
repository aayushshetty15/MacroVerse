import 'package:flutter/material.dart';
import 'package:macroverse/screens/login.dart';
import 'package:macroverse/screens/signup.dart';
import 'package:macroverse/screens/splashscreen.dart';
import 'package:macroverse/services/storage_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
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
      home: const SignUpScreen(),
    );
  }
}
