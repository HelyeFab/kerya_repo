import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:japanese_word_tokenizer/japanese_word_tokenizer.dart' as tokenizer;
import 'package:jm_dict/jm_dict.dart';
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
  final bool hasKanji;

  WordReading(this.word, this.reading, {this.hasKanji = false});

  Map<String, dynamic> toJson() => {
    'word': word,
    'reading': reading,
    'hasKanji': hasKanji,
  };

  factory WordReading.fromJson(Map<String, dynamic> json) => WordReading(
    json['word'] as String,
    json['reading'] as String?,
    hasKanji: json['hasKanji'] as bool? ?? false,
  );
}

class KanjiReading {
  final String kanji;
  final String reading;
  final bool isCompound;
  final bool hasKanji;

  KanjiReading({
    required this.kanji,
    required this.reading,
    this.isCompound = false,
    this.hasKanji = false,
  });
}

class DictionaryException implements Exception {
  final String message;
  DictionaryException(this.message);

  @override
  String toString() => message;
}

class DictionaryService {
  final Dio _dio;
  final AudioPlayer _audioPlayer;
  final JMDict _jmDict = JMDict();
  bool _isInitialized = false;
  
  final Map<String, _CacheEntry<String>> _readingCache = {};
  final Map<String, _CacheEntry<Map<String, dynamic>>> _definitionCache = {};
  final Map<String, _CacheEntry<List<KanjiReading>>> _kanjiReadingCache = {};
  
  final Map<String, Completer<String?>> _pendingReadingRequests = <String, Completer<String?>>{};
  final Map<String, Completer<List<KanjiReading>>> _pendingKanjiRequests = <String, Completer<List<KanjiReading>>>{};
  
  static const int _maxCacheSize = 1000;
  static const Duration _cacheTimeout = Duration(hours: 24);
  static const int _maxBatchSize = 10;
  final List<String> _batchQueue = [];

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

  bool _isKanji(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified Ideographs
           (code >= 0x3400 && code <= 0x4DBF);   // CJK Unified Ideographs Extension A
  }

  bool _hasKanji(String text) {
    for (var i = 0; i < text.length; i++) {
      if (_isKanji(text[i])) return true;
    }
    return false;
  }

  bool _isKanjiCompound(String text) {
    if (text.length < 2) return false;
    int kanjiCount = 0;
    for (var i = 0; i < text.length; i++) {
      if (_isKanji(text[i])) kanjiCount++;
    }
    return kanjiCount > 1;
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
      // Validate input parameters
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

      debugPrint('Translation response status: ${response.statusCode}');
      
      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['data'] != null &&
          response.data['data']['translations'] != null &&
          response.data['data']['translations'].isNotEmpty) {
        
        final translation = response.data['data']['translations'][0];
        final translatedText = translation['translatedText'] as String;
        final detectedSourceLanguage = (translation['detectedSourceLanguage'] ?? sourceLanguage) as String;
        
        final result = <String, String>{
          'translatedText': translatedText,
          'detectedSourceLanguage': detectedSourceLanguage,
        };
        
        debugPrint('Translation successful: ${result['translatedText']}');
        return result;
      }

      debugPrint('Translation failed. Response: ${response.data}');
      return null;
    } on DioException catch (e) {
      debugPrint('DioException during translation:');
      debugPrint('  Error: ${e.message}');
      debugPrint('  Response: ${e.response?.data}');
      debugPrint('  Request: ${e.requestOptions.uri}');
      debugPrint('  Headers: ${e.requestOptions.headers}');
      debugPrint('  Data: ${e.requestOptions.data}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during translation: $e');
      throw DictionaryException('Failed to translate text: $e');
    }
  }

  Future<List<String?>> _processBatchReadings(List<String> texts) async {
    try {
      final response = await _dio.post(
        'https://labs.goo.ne.jp/api/hiragana',
        data: {
          'app_id': ApiKeys.gooLabsApiKey,
          'sentence': texts.join('\n'),
          'output_type': 'hiragana',
        },
      );

      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['converted'] != null) {
        final readings = (response.data['converted'] as String).split('\n');
        
        final processedReadings = List<String?>.generate(texts.length, (index) {
          if (index < readings.length) {
            final reading = readings[index];
            return (reading != texts[index]) ? reading : null;
          }
          return null;
        });
        
        return processedReadings;
      }
      
      return List.filled(texts.length, null);
    } catch (e) {
      debugPrint('Error in batch reading process: $e');
      return List.filled(texts.length, null);
    }
  }

  Future<void> _processBatchQueue() async {
    if (_batchQueue.isEmpty) return;

    final textsToProcess = List<String>.from(_batchQueue);
    _batchQueue.clear();

    try {
      final readings = await _processBatchReadings(textsToProcess);
      
      for (var i = 0; i < textsToProcess.length; i++) {
        final text = textsToProcess[i];
        final reading = readings[i];
        
        if (reading != null && reading != text) {
          _addToCache(_readingCache, text, reading);
        }
        
        final completer = _pendingReadingRequests.remove(text);
        if (completer != null) {
          completer.complete(reading);
        }
      }
    } catch (e) {
      debugPrint('Error processing batch queue: $e');
      for (var text in textsToProcess) {
        final completer = _pendingReadingRequests.remove(text);
        if (completer != null) {
          completer.complete(null);
        }
      }
    }
  }

  Future<String?> _getHiraganaReading(String text) async {
    final cachedReading = _readingCache[text];
    if (cachedReading != null && !cachedReading.isExpired) {
      return cachedReading.value;
    }

    final existingRequest = _pendingReadingRequests[text];
    if (existingRequest != null) {
      return existingRequest.future;
    }

    _batchQueue.add(text);
    
    final completer = Completer<String?>();
    _pendingReadingRequests[text] = completer;

    if (_batchQueue.length >= _maxBatchSize) {
      _processBatchQueue();
    } else {
      Future.delayed(const Duration(milliseconds: 50), _processBatchQueue);
    }

    return completer.future;
  }

  Future<List<KanjiReading>> getKanjiReadings(String text) async {
    try {
      final cachedEntry = _kanjiReadingCache[text];
      if (cachedEntry != null && !cachedEntry.isExpired) {
        return cachedEntry.value;
      }

      final existingRequest = _pendingKanjiRequests[text];
      if (existingRequest != null) {
        return existingRequest.future;
      }

      final completer = Completer<List<KanjiReading>>();
      _pendingKanjiRequests[text] = completer;

      try {
        List<KanjiReading> readings = [];
        final hasKanji = _hasKanji(text);
        
        if (hasKanji) {
          if (_isKanjiCompound(text)) {
            final compoundReading = await _getHiraganaReading(text);
            if (compoundReading != null && compoundReading != text) {
              readings = [KanjiReading(
                kanji: text,
                reading: compoundReading,
                isCompound: true,
                hasKanji: true,
              )];
            } else {
              final tempReadings = <KanjiReading>[];
              for (var i = 0; i < text.length; i++) {
                final char = text[i];
                if (_isKanji(char)) {
                  final reading = await _getHiraganaReading(char);
                  if (reading != null && reading != char) {
                    tempReadings.add(KanjiReading(
                      kanji: char,
                      reading: reading,
                      hasKanji: true,
                    ));
                  }
                } else {
                  tempReadings.add(KanjiReading(
                    kanji: char,
                    reading: char,
                    hasKanji: false,
                  ));
                }
              }
              readings = tempReadings;
            }
          } else {
            final tempReadings = <KanjiReading>[];
            for (var i = 0; i < text.length; i++) {
              final char = text[i];
              if (_isKanji(char)) {
                final reading = await _getHiraganaReading(char);
                if (reading != null && reading != char) {
                  tempReadings.add(KanjiReading(
                    kanji: char,
                    reading: reading,
                    hasKanji: true,
                  ));
                }
              } else {
                tempReadings.add(KanjiReading(
                  kanji: char,
                  reading: char,
                  hasKanji: false,
                ));
              }
            }
            readings = tempReadings;
          }
        } else {
          readings = [KanjiReading(
            kanji: text,
            reading: text,
            hasKanji: false,
          )];
        }

        if (readings.isNotEmpty) {
          _addToCache(_kanjiReadingCache, text, readings);
        }
        
        completer.complete(readings);
        _pendingKanjiRequests.remove(text);
        
        return readings;
      } catch (e) {
        completer.completeError(e);
        _pendingKanjiRequests.remove(text);
        rethrow;
      }
    } catch (e) {
      debugPrint('Error in getKanjiReadings: $e');
      rethrow;
    }
  }

  Future<List<WordReading>> tokenizeWithReadings(String text) async {
    try {
      final tokens = tokenizer.tokenize(text);
      List<WordReading> wordsWithReadings = [];
      
      final futures = tokens.map((token) async {
        final word = token.toString();
        if (word.trim().isEmpty) return null;

        if (RegExp(r'[。、！？「」『』（）]').hasMatch(word)) {
          return WordReading(word, null);
        }

        final hasKanji = _hasKanji(word);
        if (!hasKanji) {
          return WordReading(word, null, hasKanji: false);
        }

        final kanjiReadings = await getKanjiReadings(word);
        if (kanjiReadings.isNotEmpty) {
          if (kanjiReadings.length == 1 && kanjiReadings[0].isCompound) {
            return WordReading(
              word,
              kanjiReadings[0].reading,
              hasKanji: true,
            );
          } else {
            final reading = kanjiReadings.map((r) => r.reading).join('');
            return WordReading(
              word,
              reading,
              hasKanji: true,
            );
          }
        } else {
          return WordReading(word, null, hasKanji: false);
        }
      });

      final results = await Future.wait(futures);
      wordsWithReadings = results.whereType<WordReading>().toList();

      return wordsWithReadings;
    } catch (e) {
      debugPrint('Error in tokenizeWithReadings: $e');
      throw DictionaryException(
        'Error processing Japanese text. Please try again.',
      );
    }
  }

  Future<String?> getReading(String word, BookLanguage language) async {
    if (language.code != 'ja') return null;

    try {
      if (!_hasKanji(word)) return null;

      final kanjiReadings = await getKanjiReadings(word);
      if (kanjiReadings.isEmpty) return null;

      if (kanjiReadings.length == 1 && kanjiReadings[0].isCompound) {
        return kanjiReadings[0].reading;
      } else {
        return kanjiReadings.map((r) => r.reading).join('');
      }
    } catch (e) {
      debugPrint('Error getting reading for word: $word - $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDefinition(String word, BookLanguage language) async {
    try {
      final sourceLanguage = _getLanguageCode(language);
      final targetLanguage = 'en'; // We'll always get English definitions first
      
      // For English words, skip translation and get definition directly
      if (sourceLanguage == 'en') {
        debugPrint('Looking up English word: $word');
        return _fetchEnglishDefinition(word);
      }

      // For other languages, translate first
      final translation = await _translateWithSourceLanguage(word, sourceLanguage, targetLanguage);
      if (translation == null) {
        debugPrint('Failed to translate word: $word');
        throw DictionaryException('Failed to translate the word');
      }

      final englishWord = translation['translatedText'] ?? word;
      debugPrint('Translated "$word" to "$englishWord"');

      return _fetchEnglishDefinition(englishWord, targetLanguage: language.code);
    } catch (e) {
      debugPrint('Error getting dictionary entry for word: $word - $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchEnglishDefinition(String word, {String? targetLanguage}) async {
    try {
      final dictionaryResponse = await _dio.get(
        'https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(word)}',
      );

      if (dictionaryResponse.statusCode == 200 && 
          dictionaryResponse.data is List && 
          dictionaryResponse.data.isNotEmpty) {
        
        final data = dictionaryResponse.data[0];
        final List<dynamic> meanings = data['meanings'] ?? [];
        
        // Get the first part of speech and its definitions
        String? partOfSpeech;
        List<String> definitions = [];
        List<String> examples = [];
        
        if (meanings.isNotEmpty) {
          final firstMeaning = meanings[0];
          partOfSpeech = firstMeaning['partOfSpeech'] as String?;
          
          final meaningDefinitions = firstMeaning['definitions'] as List<dynamic>? ?? [];
          for (final def in meaningDefinitions) {
            final definition = def['definition'] as String?;
            if (definition != null) {
              definitions.add(definition);
            }

            final example = def['example'] as String?;
            if (example != null) {
              // Translate example if needed
              if (targetLanguage != null && targetLanguage != 'en') {
                try {
                  final translation = await _translateWithSourceLanguage(
                    example,
                    'en',
                    targetLanguage,
                  );
                  if (translation != null) {
                    examples.add(translation['translatedText']!);
                    examples.add(example); // Add original English example
                  }
                } catch (e) {
                  debugPrint('Failed to translate example: $e');
                  examples.add(example);
                  examples.add(example); // Add English example as fallback
                }
              } else {
                examples.add(example);
                examples.add(example); // For English words, show same example twice
              }
            }
          }
        }

        final definition = {
          'word': word,
          'partOfSpeech': partOfSpeech ?? 'unknown',
          'definitions': definitions,
          'examples': examples.isNotEmpty ? examples : null,
        };

        if (targetLanguage == 'ja') {
          // Add Japanese-specific fields
          definition['reading'] = await getReading(word, BookLanguage.japanese);
          definition['romaji'] = definition['reading']; // You might want to convert hiragana to romaji
        }

        _addToCache(_definitionCache, word, definition);
        return definition;
      }

      // Return a basic structure when no definition is found
      return {
        'word': word,
        'partOfSpeech': 'unknown',
        'definitions': ['No definition found'],
        'examples': null,
      };
    } on DioException catch (e) {
      debugPrint('DioError getting dictionary entry for word: $word');
      debugPrint('Error response: ${e.response?.data}');
      debugPrint('Error message: ${e.message}');
      
      if (e.response?.statusCode == 404) {
        return {
          'word': word,
          'partOfSpeech': 'unknown',
          'definitions': ['No definition found'],
          'examples': null,
        };
      }
      
      if (e.response?.statusCode == 403) {
        throw DictionaryException('Dictionary API access denied. Please check your API key configuration.');
      }
      throw DictionaryException('Failed to fetch word definition');
    } catch (e) {
      debugPrint('Error fetching English definition for: $word - $e');
      throw DictionaryException('Failed to fetch word definition');
    }
  }

  Future<void> speakWord(String word, String language) async {
    try {
      const apiKey = ApiKeys.googleApiKey;
      if (apiKey.isEmpty) {
        throw Exception('Google API key is not configured.');
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

  void clearCache() {
    _readingCache.clear();
    _definitionCache.clear();
    _kanjiReadingCache.clear();
  }
}
