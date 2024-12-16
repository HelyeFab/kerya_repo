import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DictionaryService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';
  final Dio _dio;

  DictionaryService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> getDefinition(String word) async {
    try {
      final response = await _dio.get('$_baseUrl/$word');
      
      if (response.statusCode == 200) {
        final List<dynamic>? data = response.data as List<dynamic>?;
        if (data?.isNotEmpty ?? false) {
          final firstEntry = data![0] as Map<String, dynamic>;
          
          // Get phonetic information
          String? phonetic = firstEntry['phonetic'] as String?;
          if (phonetic == null) {
            final phonetics = firstEntry['phonetics'] as List<dynamic>?;
            if (phonetics?.isNotEmpty ?? false) {
              phonetic = phonetics!.firstWhere(
                (p) => p['text'] != null,
                orElse: () => {'text': null},
              )['text'] as String?;
            }
          }

          // Get meanings
          final meanings = firstEntry['meanings'] as List<dynamic>?;
          if (meanings?.isNotEmpty ?? false) {
            return {
              'phonetic': phonetic,
              'meanings': meanings,
            };
          }
        }
        throw Exception('No definition found');
      } else {
        throw Exception('Failed to load definition');
      }
    } catch (e) {
      debugPrint('Error fetching definition: $e');
      throw Exception('Failed to load definition');
    }
  }
}
