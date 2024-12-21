import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/color_schemes.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../../../../features/dictionary/domain/models/saved_word.dart';

class StudyWordsPage extends StatefulWidget {
  const StudyWordsPage({super.key});

  @override
  State<StudyWordsPage> createState() => _StudyWordsPageState();
}

class _StudyWordsPageState extends State<StudyWordsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final SavedWordsRepository _repository = SavedWordsRepository();
  BookLanguage? _selectedLanguage;
  
  Future<void> _deleteWord(String wordId, String word) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(UiTranslationService.translate(context, 'delete_word_title', null, false)),
          content: Text(UiTranslationService.translate(context, 'delete_word_confirm', [word], false)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(UiTranslationService.translate(context, 'common_cancel', null, false)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(UiTranslationService.translate(context, 'common_delete', null, false)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await _repository.removeWord(wordId);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(UiTranslationService.translate(context, 'error_deleting_word', [e.toString()], false))),
          );
        }
      }
    }
  }

  void _onLanguageChanged(BookLanguage? language) {
    if (mounted) {
      setState(() {
        _selectedLanguage = language;
      });
    }
  }

  void _showWordDetails(SavedWord word) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        word.word,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UiTranslationService.translate(context, 'common_definition', null, false),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.definition,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (word.examples.isNotEmpty ?? false) ...[
                        const SizedBox(height: 16),
                        Text(
                          UiTranslationService.translate(context, 'common_examples', null, false),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        ...(word.examples.take(2) ?? []).map((example) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• $example',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.onSurface
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: iconColor,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<BookLanguage?>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedLanguage != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      _selectedLanguage!.flagAsset,
                      width: 24,
                      height: 24,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.language,
                      color: iconColor,
                    ),
                  ),
              ],
            ),
            onSelected: _onLanguageChanged,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<BookLanguage?>(
                value: null,
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: iconColor,
                    ),
                    const SizedBox(width: 8),
                    Text(UiTranslationService.translate(context, 'common_all_languages', null, false)),
                  ],
                ),
              ),
              ...BookLanguage.values.map(
                (language) => PopupMenuItem<BookLanguage?>(
                  value: language,
                  child: Row(
                    children: [
                      Image.asset(
                        language.flagAsset,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(UiTranslationService.translate(
                        context,
                        'language_${language.name.toLowerCase()}',
                        null,
                        false,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<SavedWord>>(
        stream: _repository.getSavedWords(
          language: _selectedLanguage?.code,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(UiTranslationService.translate(context, 'common_error', [snapshot.error.toString()], false)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedLanguage == null
                        ? UiTranslationService.translate(context, 'no_saved_words_message', null, false)
                        : UiTranslationService.translate(context, 'no_saved_words_language_message', [_selectedLanguage!.displayName], false),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (_selectedLanguage != null) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedLanguage = null;
                        });
                      },
                      icon: Icon(
                        Icons.language,
                        color: iconColor,
                      ),
                      label: Text(UiTranslationService.translate(context, 'common_show_all_languages', null, false)),
                    ),
                  ],
                ],
              ),
            );
          } else {
            final words = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                
                // Cycle through pastel colors
                final color = AppColors.wordCardColors[index % AppColors.wordCardColors.length];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _showWordDetails(word),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.word,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Image.asset(
                                        BookLanguage.fromCode(word.language).flagAsset,
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        BookLanguage.fromCode(word.language).displayName,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteWord(word.id, word.word),
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedDeletePutBack,
                                color: iconColor,
                                size: 24.0,
                              ),
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              color: iconColor,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
