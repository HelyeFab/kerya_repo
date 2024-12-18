import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:jm_dict/jm_dict.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Keyra/core/config/api_keys.dart';

class JapaneseDictionaryService {
  static final _instance = JapaneseDictionaryService._internal();
  factory JapaneseDictionaryService() => _instance;
  JapaneseDictionaryService._internal();

  final String _jishoApiUrl = 'https://jisho.org/api/v1/search/words';
  final String _translationBaseUrl = 'https://translation.googleapis.com/language/translate/v2';
  final String _gooApiUrl = 'https://labs.goo.ne.jp/api/hiragana';

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

  Future<String?> _getReading(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_gooApiUrl),
        body: {
          'app_id': ApiKeys.gooLabsApiKey,
          'sentence': text,
          'output_type': 'hiragana',
        },
      );

      if (response.statusCode == 200 && 
          response.body.isNotEmpty) {
        final data = json.decode(response.body);
        if (data['converted'] != null) {
          return data['converted'] as String;
        }
      }
    } catch (e) {
      debugPrint('Error getting reading: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> getDefinition(String word) async {
    if (!isInitialized) await initialize();
    
    // First get Jisho data for parts of speech
    final response = await http.get(Uri.parse('$_jishoApiUrl?keyword=$word'));
    List<String> jishoPartsOfSpeech = [];
    String? firstPartOfSpeech;
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['data'];
      
      if (results.isNotEmpty) {
        final result = results[0];
        final senses = result['senses'] as List;
        
        // Get all unique parts of speech
        final Set<String> uniquePos = {};
        for (var sense in senses) {
          final pos = sense['parts_of_speech'] as List;
          uniquePos.addAll(pos.cast<String>());
          // Store the first part of speech for example generation
          if (firstPartOfSpeech == null && pos.isNotEmpty) {
            firstPartOfSpeech = pos[0];
          }
        }
        jishoPartsOfSpeech = uniquePos.toList();
      }
    }
    
    // Then get JMDict data
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

    // Get examples using translations
    final examples = await getExampleSentences(
      word,
      meanings.isNotEmpty ? meanings.first : null,
      firstPartOfSpeech,
    );

    return {
      'word': kanjiElements?.first.element ?? word,
      'reading': entry.readingElements.first.element,
      'meanings': meanings,
      'partsOfSpeech': jishoPartsOfSpeech,
      'onyomi': entry.readingElements
          .where((e) => e.information?.any((i) => i.name.contains('ok')) ?? false)
          .map((e) => e.element)
          .toList(),
      'kunyomi': entry.readingElements
          .where((e) => e.information?.any((i) => i.name.contains('kun')) ?? false)
          .map((e) => e.element)
          .toList(),
      'jlpt': null,
      'isCommon': entry.kanjiElements?.any((e) => e.information?.any((i) => i.name.contains('ichi1')) ?? false) ?? false,
      'examples': examples,
    };
  }

  List<String> _getExampleTemplates(String? partOfSpeech) {
    // Default templates if no part of speech is provided
    if (partOfSpeech == null) {
      return [
        "I saw a WORD in the garden.",
        "There is a WORD near the tree.",
      ];
    }

    // Convert to lowercase for easier matching
    final pos = partOfSpeech.toLowerCase();

    if (pos.contains('noun')) {
      return [
        "I saw a WORD in the garden.",
        "There is a WORD near the tree.",
      ];
    } else if (pos.contains('adjective') || pos.contains('i-adjective') || pos.contains('na-adjective')) {
      return [
        "The garden is very WORD.",
        "This flower looks WORD.",
      ];
    } else if (pos.contains('verb')) {
      return [
        "I like to WORD in the garden.",
        "They often WORD at the park.",
      ];
    } else if (pos.contains('adverb')) {
      return [
        "She WORD walked through the garden.",
        "The bird WORD flew away.",
      ];
    }

    // Fallback templates
    return [
      "I like this WORD.",
      "Can you see the WORD?",
    ];
  }

  Future<List<Map<String, String>>> getExampleSentences(
    String word,
    [String? meaning, String? partOfSpeech]
  ) async {
    try {
      final apiKey = ApiKeys.googleApiKey;
      if (apiKey == null) {
        debugPrint('Error: Google Translate API key not found');
        return [];
      }

      // Get appropriate templates based on part of speech
      final templates = _getExampleTemplates(partOfSpeech);
      
      // Use meaning or word to fill templates
      final englishWord = meaning?.split(',')[0].trim() ?? word;
      final englishSentences = templates.map((template) => 
        template.replaceAll('WORD', englishWord)
      ).toList();

      final examples = <Map<String, String>>[];

      for (var englishSentence in englishSentences) {
        // Translate to Japanese
        final response = await http.post(
          Uri.parse('$_translationBaseUrl?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'q': englishSentence,
            'source': 'en',
            'target': 'ja',
            'format': 'text'
          })
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final translations = data['data']['translations'] as List;
          if (translations.isNotEmpty) {
            final japaneseSentence = translations[0]['translatedText'] as String;
            
            // Get reading for the Japanese sentence
            final reading = await _getReading(japaneseSentence);

            examples.add({
              'sentence': japaneseSentence,
              'reading': reading ?? '',
              'translation': englishSentence,
            });
          }
        }
      }

      return examples;
    } catch (e) {
      debugPrint('Error creating example sentences: $e');
      return [];
    }
  }
}
