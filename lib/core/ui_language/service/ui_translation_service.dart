import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/ui_translations.dart';
import '../bloc/ui_language_bloc.dart';

class UiTranslationService {
  static String translate(BuildContext context, String key, [List<String>? params]) {
    final state = context.watch<UiLanguageBloc>().state;
    final languageCode = state.languageCode;
    
    String translation = UiTranslations.translations[languageCode]?[key] ?? 
                        UiTranslations.translations['en']?[key] ?? 
                        key;
    
    if (params != null) {
      for (var i = 0; i < params.length; i++) {
        translation = translation.replaceAll('{$i}', params[i]);
      }
    }
    
    return translation;
  }
}
