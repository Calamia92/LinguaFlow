import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'translation_model.dart' as model;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  TranslationScreenState createState() => TranslationScreenState();
}

class TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  final Box<model.Translation> _translationBox = Hive.box<model.Translation>('translations');

  String _sourceLanguage = 'fr';
  String _targetLanguage = 'en';
  String _translatedText = '';

  final List<Map<String, String>> _languages = [
    {'name': 'Français', 'code': 'fr'},
    {'name': 'Anglais', 'code': 'en'},
    {'name': 'Espagnol', 'code': 'es'},
    {'name': 'Allemand', 'code': 'de'},
    {'name': 'Italien', 'code': 'it'},
  ];

  Future<void> _translateText() async {
    if (_controller.text.isEmpty) return;

    try {
      var translation = await translateWithOpenAI(
        _controller.text,
        _sourceLanguage,
        _targetLanguage,
      );

      setState(() {
        _translatedText = translation;
      });

      final newTranslation = model.Translation(
        sourceText: _controller.text,
        translatedText: translation,
        date: DateTime.now(),
      );

      await _translationBox.add(newTranslation);
    } catch (e) {
      print('Erreur lors de la traduction : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la traduction. Veuillez réessayer.')),
      );
    }
  }

  Future<void> _clearHistory() async {
    await _translationBox.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('Traducteur avec Historique'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _clearHistory();
            },
            tooltip: 'Effacer l\'historique',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLanguageSelectors(),
            const SizedBox(height: 10),
            _buildTextField(),
            const SizedBox(height: 10),
            _buildTranslateButton(),
            const SizedBox(height: 20),
            _buildTranslationResult(),
            const SizedBox(height: 20),
            _buildTranslationHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelectors() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _sourceLanguage,
            onChanged: (value) {
              setState(() {
                _sourceLanguage = value!;
              });
            },
            items: _languages.map((language) {
              return DropdownMenuItem<String>(
                value: language['code'],
                child: Row(
                  children: [
                    const Icon(Icons.language, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(
                      language['name']!,
                      style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                    ),
                  ],
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Langue source',
              labelStyle: const TextStyle(fontSize: 18, color: Colors.indigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.indigo[50],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _targetLanguage,
            onChanged: (value) {
              setState(() {
                _targetLanguage = value!;
              });
            },
            items: _languages.map((language) {
              return DropdownMenuItem<String>(
                value: language['code'],
                child: Row(
                  children: [
                    const Icon(Icons.language, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(
                      language['name']!,
                      style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                    ),
                  ],
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Langue cible',
              labelStyle: const TextStyle(fontSize: 18, color: Colors.indigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.indigo[50],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Entrez le texte à traduire',
        labelStyle: const TextStyle(color: Colors.indigo, fontSize: 18),
        prefixIcon: const Icon(Icons.text_fields, color: Colors.indigo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
        filled: true,
        fillColor: Colors.indigo[50],
      ),
      style: const TextStyle(fontSize: 18),
    );
  }

  Widget _buildTranslateButton() {
    return ElevatedButton(
      onPressed: _translateText,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.indigoAccent,
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: const Text(
        'Traduire',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTranslationResult() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Résultat de la traduction :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _translatedText.isNotEmpty
                        ? _translatedText
                        : 'Aucune traduction pour l\'instant.',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.indigo),
                  onPressed: () {
                    if (_translatedText.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: _translatedText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Texte traduit copié dans le presse-papiers!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationHistory() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _translationBox.listenable(),
        builder: (context, Box<model.Translation> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Aucune traduction enregistrée'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final translation = box.getAt(index);
              if (translation == null) return const SizedBox();

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(
                    translation.sourceText,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    translation.translatedText,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.indigo),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text:
                        'Source: ${translation.sourceText}\nTraduction: ${translation.translatedText}',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Traduction copiée dans le presse-papiers!'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String> translateWithOpenAI(String correctedText, String sourceLang, String targetLang) async {
    final apiKey = dotenv.env['API_KEY'];
    final url = dotenv.env['BASE_URL'];

    if (apiKey == null || url == null) {
      throw Exception('API_KEY ou BASE_URL non définis dans le fichier .env');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant that translates text accurately without changing the meaning.'
          },
          {
            'role': 'user',
            'content': 'Translate the following text from $sourceLang to $targetLang: "$correctedText". Only provide the translated version, without any additional explanation.'
          }
        ],
        'max_tokens': 60,
        'temperature': 0.2,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print('Erreur lors de la requête : ${response.body}');
      throw Exception('Failed to translate text. Status code: ${response.statusCode}, response: ${response.body}');
    }
  }
}
