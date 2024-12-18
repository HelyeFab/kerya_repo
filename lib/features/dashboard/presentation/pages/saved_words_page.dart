import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/services/firestore_service.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../../../../features/dictionary/domain/models/saved_word.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../core/widgets/language_selector.dart';

class SavedWordsPage extends StatefulWidget {
  const SavedWordsPage({Key? key}) : super(key: key);

  @override
  _SavedWordsPageState createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {
  final SavedWordsRepository _repository = SavedWordsRepository();
  BookLanguage? _selectedLanguage;
  
  // List of pastel colors to cycle through
  final List<Color> pastelColors = [
    const Color(0xFFFFE5E5), // Pastel Pink
    const Color(0xFFE5FFE5), // Pastel Green
    const Color(0xFFE5E5FF), // Pastel Blue
    const Color(0xFFFFE5FF), // Pastel Purple
    const Color(0xFFFFFFE5), // Pastel Yellow
    const Color(0xFFE5FFFF), // Pastel Cyan
  ];

  Future<void> _deleteWord(String wordId, String word) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Word?'),
          content: Text('Are you sure you want to delete "$word" from your saved words?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
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
            SnackBar(content: Text('Error deleting word: $e')),
          );
        }
      }
    }
  }

  void _onLanguageChanged(BookLanguage? language) {
    setState(() {
      _selectedLanguage = language;
    });
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
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
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
                        'Definition:',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.definition,
                        style: const TextStyle(fontFamily: 'Noto Sans'),
                      ),
                      if (word.examples?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Examples:',
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...(word.examples?.take(2) ?? []).map((example) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• $example',
                            style: const TextStyle(fontFamily: 'Noto Sans'),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Saved Words',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LanguageSelector(
              currentLanguage: _selectedLanguage,
              onLanguageChanged: _onLanguageChanged,
              showAllOption: true,
            ),
          ),
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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedLanguage == null
                        ? 'No saved words found.'
                        : 'No saved words found for ${_selectedLanguage!.displayName}.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (_selectedLanguage != null) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedLanguage = null;
                        });
                      },
                      icon: const Icon(Icons.language),
                      label: const Text('Show all languages'),
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
                final color = pastelColors[index % pastelColors.length];

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
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Noto Sans',
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
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontFamily: 'Noto Sans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteWord(word.id, word.word),
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedDeletePutBack,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey[400],
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
