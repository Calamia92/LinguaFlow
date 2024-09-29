import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'translation_model.dart' as model;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
    print('Fichier .env chargé avec succès.');
  } catch (e) {
    print('Erreur lors du chargement du fichier .env : $e');
  }

  await Hive.initFlutter();
  Hive.registerAdapter(model.TranslationAdapter());
  await Hive.openBox<model.Translation>('translations');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaFlow',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        hintColor: Colors.amber,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[800]),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[600]),
          displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
          titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.indigo,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.indigo[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.indigo),
        ),
      ),
      home: const SplashScreen(),    );
  }
}
