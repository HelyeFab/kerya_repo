import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

class _CacheEntry<T> {
  final T value;
  final DateTime timestamp;

  _CacheEntry(this.value) : timestamp = DateTime.now();

  bool get isExpired => 
    DateTime.now().difference(timestamp) > DictionaryService._cacheTimeout;
}

class WordReading {
  final String word;
  final String? reading;

  WordReading(this.word, this.reading);

  Map<String, dynamic> toJson() => {
    'word': word,
    'reading': reading,
  };

  factory WordReading.fromJson(Map<String, dynamic> json) => WordReading(
    json['word'] as String,
    json['reading'] as String?,
  );
}

class DictionaryException implements Exception {
  final String message;
  DictionaryException(this.message);
  @override
  String toString() => message;
}

class DictionaryService {
  static const Duration _cacheTimeout = Duration(minutes: 30);
  static const int _maxCacheSize = 1000;
  static const int _maxBatchSize = 10;

  final _dio = Dio();
  final _audioPlayer = AudioPlayer();

  final _readingCache = <String, _CacheEntry<String>>{};
  final _definitionCache = <String, _CacheEntry<Map<String, dynamic>>>{};
  final _batchQueue = <String>[];
  final _pendingReadingRequests = <String, Completer<String?>>{};

  Future<void> initialize() async {
    // Initialize any required resources
  }

  void _addToCache<T>(Map<String, _CacheEntry<T>> cache, String key, T value) {
    if (cache.length >= _maxCacheSize) {
      final oldestKey = cache.entries
          .reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      cache.remove(oldestKey);
    }
    cache[key] = _CacheEntry(value);
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'fr': return 'fr';
      case 'es': return 'es';
      case 'de': return 'de';
      case 'it': return 'it';
      case 'ja': return 'ja';
      default: return 'en';
    }
  }

  Future<Map<String, String>?> _translateWithSourceLanguage(String text, String sourceLanguage, String targetLanguage) async {
    try {
      if (text.isEmpty || sourceLanguage.isEmpty || targetLanguage.isEmpty) {
        debugPrint('Invalid translation parameters: text=$text, source=$sourceLanguage, target=$targetLanguage');
        throw DictionaryException('Invalid translation parameters');
      }

      debugPrint('Translating: "$text" from $sourceLanguage to $targetLanguage');
      
      final response = await _dio.post(
        'https://translation.googleapis.com/language/translate/v2',
        queryParameters: {
          'key': ApiKeys.googleApiKey,
        },
        data: {
          'q': text,
          'source': sourceLanguage,
          'target': targetLanguage,
          'format': 'text',
        },
      );

      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['data'] != null &&
          response.data['data']['translations'] != null &&
          response.data['data']['translations'].isNotEmpty) {
        
        final translation = response.data['data']['translations'][0];
        final translatedText = translation['translatedText'] as String;
        final detectedSourceLanguage = (translation['detectedSourceLanguage'] ?? sourceLanguage) as String;
        
        return {
          'translatedText': translatedText,
          'detectedSourceLanguage': detectedSourceLanguage,
        };
      }

      return null;
    } catch (e) {
      debugPrint('Error during translation: $e');
      throw DictionaryException('Failed to translate text: $e');
    }
  }

  Future<String?> getReading(String word, BookLanguage language) async {
    if (language.code != 'ja') return null;

    try {
      final response = await _dio.post(
        'https://labs.goo.ne.jp/api/hiragana',
        data: {
          'app_id': ApiKeys.gooLabsApiKey,
          'sentence': word,
          'output_type': 'hiragana',
        },
      );

      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['converted'] != null) {
        final reading = response.data['converted'] as String;
        if (reading != word) {
          _addToCache(_readingCache, word, reading);
          return reading;
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting reading: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getDefinition(String word, BookLanguage language) async {
    try {
      final cachedDefinition = _definitionCache[word];
      if (cachedDefinition != null && !cachedDefinition.isExpired) {
        return cachedDefinition.value;
      }

      final sourceLanguage = _getLanguageCode(language);
      Map<String, dynamic> definition = {'word': word};

      // Get reading for Japanese words
      if (language.code == 'ja') {
        final reading = await getReading(word, language);
        if (reading != null) {
          definition['reading'] = reading;
        }

        // Get example sentences and meanings for Japanese words
        try {
          final encodedWord = Uri.encodeComponent(word);
          final response = await _dio.get(
            'https://jisho.org/api/v1/search/words?keyword=$encodedWord',
          );

          if (response.statusCode == 200 && 
              response.data != null &&
              response.data['data'] != null &&
              response.data['data'].isNotEmpty) {
            
            final data = response.data['data'][0];
            final examples = <Map<String, String>>[];
            final meanings = <String>[];
            
            if (data['japanese'] != null && data['japanese'].isNotEmpty) {
              final japanese = data['japanese'][0];
              if (japanese['reading'] != null && definition['reading'] == null) {
                definition['reading'] = japanese['reading'];
              }
            }

            if (data['senses'] != null && data['senses'].isNotEmpty) {
              for (var sense in data['senses']) {
                if (sense['english_definitions'] != null) {
                  meanings.addAll(sense['english_definitions'].cast<String>());
                }
              }
              definition['meanings'] = meanings;

              // Extract JLPT level
              if (data['jlpt'] != null && data['jlpt'].isNotEmpty) {
                definition['jlpt'] = data['jlpt'][0].toUpperCase().replaceAll('JLPT-', '');
              }

              // Extract common word indicator
              definition['isCommon'] = data['is_common'] ?? false;

              // Extract parts of speech
              if (data['senses'][0]['parts_of_speech'] != null) {
                definition['partsOfSpeech'] = List<String>.from(data['senses'][0]['parts_of_speech']);
              }

              // Extract readings
              if (data['japanese'] != null) {
                List<String> onReadings = [];
                List<String> kunReadings = [];
                
                // First check if we have explicit reading_meaning data
                if (data['reading_meaning'] != null) {
                  var readings = data['reading_meaning']['readings'];
                  if (readings != null) {
                    for (var reading in readings) {
                      if (reading['type'] == 'on') {
                        onReadings.add(reading['reading']);
                      } else if (reading['type'] == 'kun') {
                        kunReadings.add(reading['reading']);
                      }
                    }
                  }
                }
                
                // If no explicit readings found, try to infer from japanese array
                if (onReadings.isEmpty && kunReadings.isEmpty) {
                  for (var entry in data['japanese']) {
                    if (entry['reading'] != null) {
                      // For verbs and adjectives, typically use kun readings
                      if (data['senses'] != null && 
                          data['senses'].isNotEmpty && 
                          data['senses'][0]['parts_of_speech'] != null) {
                        var pos = data['senses'][0]['parts_of_speech'][0].toLowerCase();
                        if (pos.contains('verb') || pos.contains('adjective')) {
                          kunReadings.add(entry['reading']);
                          continue;
                        }
                      }
                      
                      // Otherwise use katakana check as fallback
                      if (_isKatakana(entry['reading'])) {
                        onReadings.add(entry['reading']);
                      } else {
                        kunReadings.add(entry['reading']);
                      }
                    }
                  }
                }
                
                // Remove duplicates
                onReadings = onReadings.toSet().toList();
                kunReadings = kunReadings.toSet().toList();
                
                if (onReadings.isNotEmpty) {
                  definition['onyomi'] = onReadings;
                }
                if (kunReadings.isNotEmpty) {
                  definition['kunyomi'] = kunReadings;
                }
                
                debugPrint('Extracted readings - On: $onReadings, Kun: $kunReadings');
              }
            }

            debugPrint('Jisho definition result: ${json.encode(definition)}');
          }
        } catch (e) {
          debugPrint('Error fetching Jisho data: $e');
        }
        
        return definition;
      }

      // For non-Japanese words, get English definition
      try {
        final englishDefinition = await _fetchEnglishDefinition(word, targetLanguage: language.code);
        if (englishDefinition != null) {
          definition.addAll(englishDefinition);
        }
      } catch (e) {
        debugPrint('Error fetching English definition: $e');
      }

      _addToCache(_definitionCache, word, definition);
      return definition;
    } catch (e) {
      debugPrint('Error in getDefinition: $e');
      return {'word': word};
    }
  }

  Future<Map<String, dynamic>> _getJishoDefinition(String word) async {
    try {
      debugPrint('Fetching Jisho definition for: $word');
      final response = await _dio.get(
        'https://jisho.org/api/v1/search/words?keyword=$word',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('Jisho API Response: ${json.encode(data)}');
        
        if (data['data'] != null && data['data'].isNotEmpty) {
          final firstEntry = data['data'][0];
          debugPrint('First entry: ${json.encode(firstEntry)}');
          
          final japanese = firstEntry['japanese'][0];
          final senses = firstEntry['senses'];
          
          debugPrint('Japanese data: ${json.encode(japanese)}');
          debugPrint('Senses data: ${json.encode(senses)}');

          // Extract readings
          Map<String, List<String>> readings = {'on': [], 'kun': []};
          if (firstEntry['japanese'] != null) {
            for (var entry in firstEntry['japanese']) {
              if (entry['reading'] != null) {
                if (_isKatakana(entry['reading'])) {
                  readings['on']!.add(entry['reading']);
                } else {
                  readings['kun']!.add(entry['reading']);
                }
              }
            }
          }
          debugPrint('Extracted readings: ${json.encode(readings)}');

          // Extract JLPT level
          String? jlptLevel;
          if (firstEntry['jlpt'] != null && firstEntry['jlpt'].isNotEmpty) {
            jlptLevel = firstEntry['jlpt'][0].toUpperCase().replaceAll('JLPT-', '');
          }
          debugPrint('JLPT Level: $jlptLevel');

          // Extract part of speech
          List<String> partsOfSpeech = [];
          if (senses.isNotEmpty && senses[0]['parts_of_speech'] != null) {
            partsOfSpeech = List<String>.from(senses[0]['parts_of_speech']);
          }
          debugPrint('Parts of speech: $partsOfSpeech');

          // Extract common word usage indicator
          bool isCommon = firstEntry['is_common'] ?? false;
          debugPrint('Is common: $isCommon');

          final result = {
            'reading': japanese['reading'] ?? '',
            'meanings': senses.map((sense) => sense['english_definitions'][0]).toList(),
            'onyomi': readings['on'],
            'kunyomi': readings['kun'],
            'jlpt': jlptLevel,
            'isCommon': isCommon,
            'partsOfSpeech': partsOfSpeech,
          };
          
          debugPrint('Final processed result: ${json.encode(result)}');
          return result;
        }
      }
      return {};
    } catch (e) {
      debugPrint('Error fetching Jisho definition: $e');
      debugPrint('Error stack trace: ${e is Error ? e.stackTrace : ''}');
      return {};
    }
  }

  bool _isKatakana(String text) {
    // Katakana Unicode range
    final katakanaRange = RegExp(r'[\u30A0-\u30FF]');
    return katakanaRange.hasMatch(text);
  }

  Future<Map<String, dynamic>?> _fetchEnglishDefinition(String word, {String? targetLanguage}) async {
    try {
      final response = await _dio.get(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );

      if (response.statusCode == 200 && response.data is List && response.data.isNotEmpty) {
        final entry = response.data[0];
        final meanings = entry['meanings'] as List;
        
        if (meanings.isNotEmpty) {
          final firstMeaning = meanings[0];
          final definitions = firstMeaning['definitions'] as List;
          final examples = <String>[];
          
          for (var def in definitions) {
            if (def['example'] != null) {
              examples.add(def['example'].toString());
            }
          }

          return {
            'partOfSpeech': firstMeaning['partOfSpeech'] ?? 'unknown',
            'definitions': definitions.map((d) => d['definition'].toString()).toList(),
            'examples': examples,
          };
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error fetching English definition: $e');
      return null;
    }
  }

  Future<void> speakWord(String word, String language) async {
    try {
      final url = Uri.parse(
        'https://translate.google.com/translate_tts'
        '?ie=UTF-8'
        '&q=${Uri.encodeComponent(word)}'
        '&tl=$language'
        '&client=tw-ob'
      ).toString();

      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void clearCache() {
    _readingCache.clear();
    _definitionCache.clear();
  }
}
