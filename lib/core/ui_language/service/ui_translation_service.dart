import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../translations/ui_translations.dart';
import '../bloc/ui_language_bloc.dart';

class UiTranslationService {
  static String translate(BuildContext context, String key, [List<String>? args, bool listen = true]) {
    final langCode = context.watch<UiLanguageBloc>().state.languageCode;
    final translations = UiTranslations.translations[langCode] ?? UiTranslations.translations['en']!;
    var text = translations[key] ?? key;
    
    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        text = text.replaceAll('{$i}', args[i]);
      }
    }
    
    return text;
  }
}
