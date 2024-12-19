import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/config/api_keys.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/services/local_dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/services/japanese_dictionary_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  final _dio = Dio();
  final _audioPlayer = AudioPlayer();
  final LocalDictionaryService _localDictionary = LocalDictionaryService();
  final JapaneseDictionaryService _japaneseDictionary = JapaneseDictionaryService();

  final _definitionCache = <String, _CacheEntry<Map<String, dynamic>>>{};

  bool get isDictionaryInitialized => _japaneseDictionary.isInitialized;

  Future<void> initialize() async {
    try {
      await _localDictionary.recreateDatabase();
      await _japaneseDictionary.initialize();
    } catch (e) {
      debugPrint('Error initializing dictionaries: $e');
    }
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

  Future<Map<String, dynamic>> getDefinition(String word, BookLanguage language) async {
    try {
      // Check cache first
      final cacheKey = '${language.code}:$word';
      final cached = _definitionCache[cacheKey];
      if (cached != null && !cached.isExpired) {
        return cached.value;
      }

      Map<String, dynamic>? definition;
      
      if (language.code == 'ja') {
        definition = await _japaneseDictionary.getDefinition(word);
      } else {
        definition = await _localDictionary.getDefinition(word, language: language.code);
      }
      
      final result = definition ?? {'word': word};
      _addToCache(_definitionCache, cacheKey, result);
      return result;
    } catch (e) {
      debugPrint('Error getting definition: $e');
      return {'word': word};
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
    _definitionCache.clear();
  }
}
