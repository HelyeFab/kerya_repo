import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:jm_dict/jm_dict.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JapaneseDictionaryService {
  static final _instance = JapaneseDictionaryService._internal();
  factory JapaneseDictionaryService() => _instance;
  JapaneseDictionaryService._internal();

  final String _jishoApiUrl = 'https://jisho.org/api/v1/search/words';

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
          .where((g) => g.language.name == 'eng')
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

    // Get examples from Jisho API
    final examples = await getExampleSentences(word);

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
      'examples': examples,
    };
  }

  Future<List<Map<String, String>>> getExampleSentences(String word) async {
    try {
      final response = await http.get(Uri.parse('$_jishoApiUrl?keyword=$word'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['data'];
        
        if (results.isNotEmpty) {
          final List<Map<String, String>> examples = [];
          
          for (var result in results) {
            if (result['japanese']?[0]?['word'] == word || 
                result['japanese']?[0]?['reading'] == word) {
              
              final sentences = result['sentences'] as List?;
              if (sentences != null) {
                for (var sentence in sentences) {
                  examples.add({
                    'sentence': sentence['japanese'],
                    'reading': sentence['reading'],
                    'translation': sentence['english'],
                  });
                }
              }
            }
          }
          
          // If no examples found in the first result, try getting from other results
          if (examples.isEmpty) {
            for (var result in results) {
              final senses = result['senses'] as List;
              for (var sense in senses) {
                final sentences = sense['sentences'] as List?;
                if (sentences != null) {
                  for (var sentence in sentences) {
                    examples.add({
                      'sentence': sentence['japanese'],
                      'reading': sentence['reading'],
                      'translation': sentence['english'],
                    });
                  }
                }
              }
              
              // Limit to 3 examples
              if (examples.length >= 3) break;
            }
          }
          
          return examples;
        }
      }
    } catch (e) {
      debugPrint('Error getting Japanese example sentences: $e');
    }
    return [];
  }
}
