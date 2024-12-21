import 'package:flutter/material.dart';
import '../../../../core/config/ui_translations.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../features/books/domain/models/book_language.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final List<String> languages;
  final Function(String?) onLanguageSelected;

  const LanguageSelectionDialog({
    Key? key,
    required this.languages,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get translations upfront
    final studyWordsText = UiTranslationService.translate(context, 'dashboard_study_words');
    final allLanguagesText = UiTranslationService.translate(context, 'common_all_languages');

    return AlertDialog(
      title: Text(studyWordsText),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            // All languages option
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(allLanguagesText),
              onTap: () {
                Navigator.pop(context);
                onLanguageSelected(null);
              },
            ),
            const Divider(),
            // Individual language options
            ...languages.map((language) {
              final bookLanguage = BookLanguage.values.firstWhere(
                (l) => l.code == language.toLowerCase(),
                orElse: () => BookLanguage.english,
              );
              return ListTile(
                leading: Image.asset(
                  bookLanguage.flagAsset,
                  width: 24,
                  height: 24,
                ),
                title: Text(bookLanguage.displayName),
                onTap: () {
                  Navigator.pop(context);
                  onLanguageSelected(language);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
