import 'package:flutter/material.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:uuid/uuid.dart';
import 'package:ruby_text/ruby_text.dart';

class WordDefinitionModal extends StatefulWidget {
  final String word;
  final BookLanguage language;

  const WordDefinitionModal({
    Key? key,
    required this.word,
    required this.language,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context,
    String word,
    BookLanguage language,
  ) {
    final height = MediaQuery.of(context).size.height * 0.6;
    
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: WordDefinitionModal(
            word: word,
            language: language,
          ),
        ),
      ),
    );
  }

  @override
  State<WordDefinitionModal> createState() => _WordDefinitionModalState();
}

class _WordDefinitionModalState extends State<WordDefinitionModal> {
  final DictionaryService _dictionaryService = DictionaryService();
  final SavedWordsRepository _savedWordsRepository = SavedWordsRepository();
  Map<String, dynamic>? _definition;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSaved = false;
  String? _error;
  String? _savedWordId;

  @override
  void initState() {
    super.initState();
    _loadDefinition();
    _checkIfWordIsSaved();
  }

  Future<void> _checkIfWordIsSaved() async {
    try {
      final isSaved = await _savedWordsRepository.isWordSaved(widget.word);
      if (isSaved) {
        final savedWords = await _savedWordsRepository.getSavedWords().first;
        final savedWord = savedWords.firstWhere(
          (word) => word.word.toLowerCase() == widget.word.toLowerCase(),
          orElse: () => SavedWord(
            id: '',
            word: '',
            definition: '',
            language: '',
            examples: [],
            savedAt: DateTime.now(),
          ),
        );
        
        if (mounted && savedWord.id.isNotEmpty) {
          setState(() {
            _isSaved = true;
            _savedWordId = savedWord.id;
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking if word is saved: $e');
    }
  }

  Future<void> _toggleSaveWord() async {
    if (_definition == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isSaved && _savedWordId != null) {
        await _savedWordsRepository.removeWord(_savedWordId!);
        setState(() {
          _isSaved = false;
          _savedWordId = null;
        });
      } else {
        final definition = _definition!['meanings']?.isNotEmpty == true
            ? _definition!['meanings'][0]
            : 'No definition available';
            
        final examples = _definition!['examples'] as List?;
        final savedWord = SavedWord(
          id: const Uuid().v4(),
          word: widget.word,
          definition: definition,
          language: widget.language.code,
          examples: examples != null && examples.isNotEmpty 
              ? [examples[0].toString()]
              : [],
          savedAt: DateTime.now(),
        );

        await _savedWordsRepository.saveWord(savedWord);

        setState(() {
          _isSaved = true;
          _savedWordId = savedWord.id;
        });
      }
    } catch (e) {
      debugPrint('Error toggling word save state: $e');
      if (mounted) {
        final errorMessage = e.toString().contains('already saved')
            ? 'This word is already in your saved words'
            : 'Failed to update word';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _loadDefinition() async {
    try {
      final definition = await _dictionaryService.getDefinition(
        widget.word,
        widget.language,
      );
      if (mounted) {
        setState(() {
          _definition = definition;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _definition = null;
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final theme = Theme.of(context);
    final isJapanese = widget.language.code == 'ja';
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isJapanese && _definition?['reading'] != null)
                          RubyText(
                            [RubyTextData(
                              widget.word,
                              ruby: _definition!['reading'],
                            )],
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            rubyStyle: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          )
                        else
                          Text(
                            widget.word,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (_definition?['partsOfSpeech'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              (_definition!['partsOfSpeech'] as List).join(', '),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        if (!isJapanese && _definition?['reading'] != null && _definition!['reading'].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "/${_definition!['reading']}/",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'NotoSans',
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF9C4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: _isSaved ? theme.colorScheme.primary : null,
                          ),
                          onPressed: _toggleSaveWord,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_definition?['meanings'] != null && _definition!['meanings'].isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meanings:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_definition!['meanings'] as List)
                        .take(6)
                        .map((meaning) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(
                              child: Text(
                                meaning.toString(),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_definition?['examples'] != null && (_definition!['examples'] as List).isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Examples:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_definition!['examples'] as List).map((example) {
                      if (isJapanese) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RubyText(
                                [RubyTextData(
                                  example['sentence'] as String,
                                  ruby: example['reading'] as String,
                                )],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                rubyStyle: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                example['translation'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                example['sentence'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                example['translation'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return _buildContent();
  }
}
