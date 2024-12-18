import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Keyra/core/config/api_keys.dart';

class LocalDictionaryService {
  static final _instance = LocalDictionaryService._internal();
  factory LocalDictionaryService() => _instance;
  LocalDictionaryService._internal();

  final String _dictionaryBaseUrl = 'https://api.dictionaryapi.dev/api/v2/entries';
  final String _translationBaseUrl = 'https://translation.googleapis.com/language/translate/v2';

  Future<void> initialize() async {
    // No initialization needed
  }

  Future<void> recreateDatabase() async {
    // No database to recreate
  }

  Future<Map<String, dynamic>> getDefinition(String text, {String language = 'en'}) async {
    try {
      if (language == 'en') {
        return await _getEnglishDefinition(text);
      } else {
        // Split into words and only translate the actual word, not punctuation
        final words = text.split(RegExp(r'\s+'));
        if (words.isEmpty) return {'word': text};
        
        // Get the first word and clean it from punctuation
        final word = words[0].replaceAll(RegExp(r'[^\p{L}\s]+', unicode: true), '');
        if (word.isEmpty) return {'word': text};
        
        return await _getTranslation(word, language);
      }
    } catch (e) {
      debugPrint('Error getting definition: $e');
      return {'word': text};
    }
  }

  Future<Map<String, dynamic>> _getEnglishDefinition(String word) async {
    final response = await http.get(Uri.parse('$_dictionaryBaseUrl/en/$word'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final entry = data[0];
        final meanings = entry['meanings'] as List<dynamic>;
        
        // Extract definitions and examples
        final List<String> definitions = [];
        final List<Map<String, String>> examples = [];
        
        for (var meaning in meanings) {
          final defs = meaning['definitions'] as List<dynamic>;
          for (var def in defs) {
            // Add definition
            definitions.add(def['definition'].toString());
            
            // Add example if available
            if (def['example'] != null) {
              examples.add({
                'sentence': def['example'].toString(),
                'translation': def['example'].toString(), // Same for English
              });
            }
          }
        }
        
        return {
          'word': entry['word'] ?? word,
          'reading': entry['phonetic'] ?? '',
          'meanings': definitions,
          'partsOfSpeech': meanings.map((m) => m['partOfSpeech'].toString()).toList(),
          'examples': examples,
        };
      }
    }
    return {'word': word};
  }

  Future<Map<String, dynamic>> _getTranslation(String text, String targetLang) async {
    final apiKey = ApiKeys.googleApiKey;
    if (apiKey == null) {
      debugPrint('Error: Google Translate API key not found');
      return {'word': text};
    }

    // First translate from target language to English
    final response = await http.post(
      Uri.parse('$_translationBaseUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': text,
        'target': 'en',  // Always translate to English first
        'source': targetLang,  // From the target language
        'format': 'text'
      })
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final translations = data['data']['translations'] as List;
      if (translations.isNotEmpty) {
        final englishTranslation = translations[0]['translatedText'];
        
        // Get example sentences for the English translation
        final examples = await _getExampleSentences(englishTranslation);
        
        // If we have examples in English, translate them back to the target language
        final translatedExamples = await Future.wait(
          examples.map((example) async {
            final exampleResponse = await http.post(
              Uri.parse('$_translationBaseUrl?key=$apiKey'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'q': example,
                'source': 'en',
                'target': targetLang,
                'format': 'text'
              })
            );
            
            if (exampleResponse.statusCode == 200) {
              final exampleData = json.decode(exampleResponse.body);
              final exampleTranslations = exampleData['data']['translations'] as List;
              if (exampleTranslations.isNotEmpty) {
                return {
                  'sentence': exampleTranslations[0]['translatedText'],
                  'translation': example,
                };
              }
            }
            return null;
          })
        );
        
        return {
          'word': text,
          'reading': '',
          'meanings': [englishTranslation],
          'partsOfSpeech': [],
          'examples': translatedExamples.where((e) => e != null).toList(),
        };
      }
    }
    return {'word': text};
  }

  Future<List<String>> _getExampleSentences(String word) async {
    try {
      // Get example sentences from the Free Dictionary API
      final response = await http.get(Uri.parse('$_dictionaryBaseUrl/en/$word'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final entry = data[0];
          final meanings = entry['meanings'] as List<dynamic>;
          
          // Extract example sentences from definitions
          final examples = meanings
              .expand((m) => (m['definitions'] as List<dynamic>))
              .where((d) => d['example'] != null)
              .map((d) => d['example'].toString())
              .take(2)  // Limit to 2 examples to avoid too many translations
              .toList();
          
          return examples;
        }
      }
    } catch (e) {
      debugPrint('Error getting example sentences: $e');
    }
    return [];
  }

  Future<List<Map<String, String>>> getExampleSentences(String word) async {
    // Currently not implemented for non-Japanese languages
    return [];
  }
}
