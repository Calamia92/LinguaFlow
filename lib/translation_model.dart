import 'package:hive/hive.dart';

part 'translation_model.g.dart';

@HiveType(typeId: 0)
class Translation extends HiveObject {
  @HiveField(0)
  final String sourceText;

  @HiveField(1)
  final String translatedText;

  @HiveField(2)
  final DateTime date;

  Translation({
    required this.sourceText,
    required this.translatedText,
    required this.date,
  });
}
