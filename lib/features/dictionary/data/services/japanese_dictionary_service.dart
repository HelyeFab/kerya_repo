import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:jm_dict/jm_dict.dart';

class JapaneseDictionaryService {
  static final _instance = JapaneseDictionaryService._internal();
  factory JapaneseDictionaryService() => _instance;
  JapaneseDictionaryService._internal();

  bool get isInitialized => JMDict().isNotEmpty;

  Future<void> initialize() async {
    if (isInitialized) return;

    try {
      await JMDict().initFromNetwork(forceUpdate: false);
    } catch (e) {
      debugPrint('Error initializing JMDict: $e');
      rethrow;
    }
  }

  Future<void> recreateDatabase() async {
    try {
      await JMDict().initFromNetwork(forceUpdate: true);
    } catch (e) {
      debugPrint('Error recreating JMDict: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDefinition(String word) async {
    if (!isInitialized) await initialize();
    
    final results = JMDict().search(keyword: word, limit: 1);
    if (results?.isEmpty ?? true) return {'word': word};

    final entry = results!.first;
    final kanjiElements = entry.kanjiElements;
    final senseElements = entry.senseElements;

    // Filter only English glossaries
    List<String> meanings = [];
    for (var sense in senseElements) {
      // Only include glossaries that are explicitly marked as English
      var englishGlossaries = sense.glossaries
          .where((g) => g.language?.name == 'eng')
          .map((g) => g.text)
          .toList();
      
      // If no explicit English glossaries found, try those without language tag
      if (englishGlossaries.isEmpty) {
        englishGlossaries = sense.glossaries
            .where((g) => g.language == null)
            .map((g) => g.text)
            .toList();
      }
      
      if (englishGlossaries.isNotEmpty) {
        meanings.add(englishGlossaries.join(', '));
      }
    }

    return {
      'word': kanjiElements?.first.element ?? word,
      'reading': entry.readingElements.first.element,
      'meanings': meanings,
      'partsOfSpeech': senseElements.isNotEmpty
          ? senseElements.first.glossaries
              .where((e) => e.type != null)
              .map((e) => e.type!.name)
              .toList()
          : [],
      'onyomi': entry.readingElements
          .where((e) => e.information?.any((i) => i.name.contains('ok')) ?? false)
          .map((e) => e.element)
          .toList(),
      'kunyomi': entry.readingElements
          .where((e) => e.information?.any((i) => i.name.contains('kun')) ?? false)
          .map((e) => e.element)
          .toList(),
      'jlpt': null, // JMDict package doesn't provide JLPT level
      'isCommon': entry.kanjiElements?.any((e) => e.information?.any((i) => i.name.contains('ichi1')) ?? false) ?? false,
      'examples': [], // We'll need to handle examples separately
    };
  }

  Future<List<Map<String, String>>> getExampleSentences(String word) async {
    // For now, return empty list since JMDict doesn't include examples
    return [];
  }
}
