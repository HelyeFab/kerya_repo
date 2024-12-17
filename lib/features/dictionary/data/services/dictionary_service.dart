import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:japanese_word_tokenizer/japanese_word_tokenizer.dart' as tokenizer;
import 'package:jm_dict/jm_dict.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

class DictionaryService {
  final Dio _dio;
  final AudioPlayer _audioPlayer;
  final JMDict _jmDict = JMDict();
  bool _isInitialized = false;
  
  // Add cache for readings and definitions
  final Map<String, String> _readingCache = {};
  final Map<String, Map<String, dynamic>> _definitionCache = {};
  
  // Cache size limits
  static const int _maxCacheSize = 1000;

  DictionaryService({Dio? dio}) 
    : _dio = dio ?? Dio(),
      _audioPlayer = AudioPlayer();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      debugPrint('Initializing dictionary from network...');
      await _jmDict.initFromNetwork(forceUpdate: false);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to load dictionary: $e');
      throw DictionaryException(
        'Unable to initialize dictionary. Please check your internet connection and try again.',
      );
    }
  }

  Future<Map<String, String>?> getFurigana(String word) async {
    if (!_isInitialized) {
      try {
        await initialize();
      } catch (e) {
        return null;
      }
    }

    try {
      final results = _jmDict.search(keyword: word, limit: 1);
      if (results?.isNotEmpty ?? false) {
        final entry = results!.first;
        if (entry.readingElements.isNotEmpty) {
          return {
            'text': word,
            'reading': entry.readingElements.first.element,
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting furigana for word: $word - $e');
      return null;
    }
  }

  Future<List<(String, String?)>> tokenizeWithReadings(String text) async {
    if (!_isInitialized) {
      try {
        await initialize();
      } catch (e) {
        throw DictionaryException(
          'Dictionary is not initialized. Please restart the app and try again.',
        );
      }
    }
    
    try {
      final tokens = tokenizer.tokenize(text);
      List<(String, String?)> wordsWithReadings = [];

      for (var token in tokens) {
        final word = token.toString();
        if (word.trim().isEmpty) continue;

        if (RegExp(r'[。、！？「」『』（）]').hasMatch(word)) {
          wordsWithReadings.add((word, null));
          continue;
        }

        if (RegExp(r'[\u4e00-\u9faf]').hasMatch(word)) {
          final reading = await getReading(word, BookLanguage.japanese);
          wordsWithReadings.add((word, reading));
        } else {
          wordsWithReadings.add((word, null));
        }
      }

      return wordsWithReadings;
    } catch (e) {
      throw DictionaryException(
        'Error processing Japanese text. Please try again.',
      );
    }
  }

  Future<String?> getReading(String word, BookLanguage language) async {
    if (language.code != 'ja' || !_isInitialized) return null;

    // Check cache first
    if (_readingCache.containsKey(word)) {
      return _readingCache[word];
    }

    try {
      final results = _jmDict.search(keyword: word, limit: 1);
      if (results?.isNotEmpty ?? false) {
        final entry = results!.first;
        if (entry.readingElements.isNotEmpty) {
          final reading = entry.readingElements.first.element;
          _addToReadingCache(word, reading);
          return reading;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting reading for word: $word - $e');
      return null;
    }
  }

  Future<String?> _translateText(String text, String targetLanguage) async {
    try {
      final response = await _dio.post(
        'https://translation.googleapis.com/language/translate/v2',
        queryParameters: {
          'key': ApiKeys.googleApiKey,
        },
        data: {
          'q': text,
          'target': targetLanguage,
          'format': 'text',
        },
      );

      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['data'] != null &&
          response.data['data']['translations'] != null &&
          response.data['data']['translations'].isNotEmpty) {
        
        return response.data['data']['translations'][0]['translatedText'];
      }
      return null;
    } catch (e) {
      debugPrint('Error translating text: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDefinition(String word, BookLanguage language) async {
    // Check if word is in Japanese
    if (language.code == 'ja') {
      if (!_isInitialized) {
        try {
          await initialize();
        } catch (e) {
          debugPrint('Failed to initialize JMDict: $e');
          return null;
        }
      }

      try {
        final results = _jmDict.search(keyword: word, limit: 1);
        if (results?.isNotEmpty ?? false) {
          final entry = results!.first;
          
          // Create a structured definition response
          final Map<String, dynamic> definition = {
            'translatedWord': entry.kanjiElements?.firstOrNull?.element ?? word,
            'meanings': <Map<String, dynamic>>[],
          };

          if (entry.senseElements.isNotEmpty) {
            final meanings = entry.senseElements.map((sense) {
              final glossaryTexts = sense.glossaries.map((g) => g.text).toList();
              return {
                'partOfSpeech': '', // JMDict doesn't provide part of speech
                'definitions': [
                  {
                    'definition': glossaryTexts.join(', '),
                    'example': null,
                    'synonyms': <String>[],
                  }
                ],
              };
            }).toList();

            definition['meanings'] = meanings;
            return definition;
          }
        }
        return null;
      } catch (e) {
        debugPrint('Error getting JMDict definition for word: $word - $e');
        return null;
      }
    } else {
      try {
        String wordToLookup = word;
        String originalLanguage = language.code;
        
        // If not English, translate to English first
        if (language.code != 'en') {
          debugPrint('Translating word: $word from ${language.code} to English');
          
          final translationResponse = await _dio.post(
            'https://translation.googleapis.com/language/translate/v2',
            queryParameters: {
              'key': ApiKeys.googleApiKey,
            },
            data: {
              'q': word,
              'source': language.code,
              'target': 'en',
              'format': 'text',
            },
          );

          if (translationResponse.statusCode == 200 && 
              translationResponse.data != null &&
              translationResponse.data['data'] != null &&
              translationResponse.data['data']['translations'] != null &&
              translationResponse.data['data']['translations'].isNotEmpty) {
            
            wordToLookup = translationResponse.data['data']['translations'][0]['translatedText'];
            debugPrint('Translated word: $wordToLookup');
          } else {
            debugPrint('Translation failed, using original word');
          }
        }

        // Get dictionary entry
        debugPrint('Getting dictionary entry for: $wordToLookup');
        final dictionaryResponse = await _dio.get(
          'https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(wordToLookup)}',
        );

        debugPrint('Dictionary API response status: ${dictionaryResponse.statusCode}');
        debugPrint('Dictionary API response data: ${dictionaryResponse.data}');

        if (dictionaryResponse.statusCode == 200 && 
            dictionaryResponse.data is List && 
            dictionaryResponse.data.isNotEmpty) {
          
          final data = dictionaryResponse.data[0];
          final meanings = data['meanings'] ?? [];
          
          // Create a structured definition response
          final Map<String, dynamic> definition = {
            'translatedWord': word,
            'meanings': <Map<String, dynamic>>[],
          };

          // Process each meaning and translate examples if needed
          for (var meaning in meanings) {
            final definitions = meaning['definitions'] ?? [];
            final List<Map<String, dynamic>> processedDefinitions = [];

            for (var def in definitions) {
              final example = def['example'];
              String? translatedExample;

              // If we have an example and we're not in English mode, translate it
              if (example != null && originalLanguage != 'en') {
                translatedExample = await _translateText(example, originalLanguage);
              }

              processedDefinitions.add({
                'definition': def['definition'] ?? '',
                'example': example,
                'translatedExample': translatedExample,
                'synonyms': def['synonyms'] ?? <String>[],
              });
            }

            definition['meanings'].add({
              'partOfSpeech': meaning['partOfSpeech'] ?? '',
              'definitions': processedDefinitions,
            });
          }
          
          debugPrint('Returning definition: $definition');
          return definition;
        }
      } on DioException catch (e) {
        debugPrint('DioError getting dictionary entry for word: $word');
        debugPrint('Error response: ${e.response?.data}');
        debugPrint('Error message: ${e.message}');
        if (e.response?.statusCode == 403) {
          throw DictionaryException('Dictionary API access denied. Please check your API key configuration.');
        }
      } catch (e) {
        debugPrint('Error getting dictionary entry for word: $word - $e');
      }
      return null;
    }
  }

  void _addToReadingCache(String word, String reading) {
    if (_readingCache.length >= _maxCacheSize) {
      _readingCache.remove(_readingCache.keys.first);
    }
    _readingCache[word] = reading;
  }

  Future<void> speakWord(String word, String language) async {
    try {
      const apiKey = ApiKeys.googleApiKey;
      if (apiKey.isEmpty) {
        throw Exception('Google API key is not configured. Please set the GOOGLE_API_KEY environment variable.');
      }

      final response = await _dio.post(
        'https://texttospeech.googleapis.com/v1/text:synthesize',
        queryParameters: {
          'key': apiKey,
        },
        data: {
          'input': {'text': word},
          'voice': {
            'languageCode': language,
            'ssmlGender': 'FEMALE'
          },
          'audioConfig': {
            'audioEncoding': 'MP3',
            'speakingRate': 1.0,
            'pitch': 0.0,
          },
        },
      );

      if (response.statusCode == 200) {
        final audioContent = response.data['audioContent'];
        final bytes = base64.decode(audioContent);
        final uint8List = Uint8List.fromList(bytes);
        final source = BytesSource(uint8List);
        await _audioPlayer.play(source);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('Text-to-speech API access denied. Please check your API key configuration.');
      } else {
        throw Exception('Failed to generate speech: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error in text-to-speech: $e');
      throw Exception('Failed to speak word: $e');
    }
  }

  // Add method to clear cache if needed
  void clearCache() {
    _readingCache.clear();
    _definitionCache.clear();
  }
}

class DictionaryException implements Exception {
  final String message;
  DictionaryException(this.message);

  @override
  String toString() => message;
}
