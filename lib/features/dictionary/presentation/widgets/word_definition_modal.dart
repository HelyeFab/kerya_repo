import 'package:flutter/material.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
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
    return showModalBottomSheet(
      context: context,
      builder: (_) => WordDefinitionModal(
        word: word,
        language: language,
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
  bool _isSpeaking = false;
  String? _error;
  String? _savedWordId;
  Map<String, String>? _furigana;

  @override
  void initState() {
    super.initState();
    _loadDefinition();
    _checkIfWordIsSaved();
    if (widget.language.code == 'ja') {
      _fetchFurigana();
    }
  }

  Future<void> _fetchFurigana() async {
    try {
      final furigana = await _dictionaryService.getFurigana(widget.word);
      if (mounted) {
        setState(() {
          _furigana = furigana;
        });
      }
    } catch (e) {
      debugPrint('Error getting furigana: $e');
    }
  }

  Future<void> _checkIfWordIsSaved() async {
    try {
      final isSaved = await _savedWordsRepository.isWordSaved(widget.word);
      if (isSaved) {
        // If the word is saved, get its ID
        final savedWords = await _savedWordsRepository.getSavedWords().first;
        final savedWord = savedWords.firstWhere(
          (word) => word.word.toLowerCase() == widget.word.toLowerCase(),
        );
        
        setState(() {
          _isSaved = true;
          _savedWordId = savedWord.id;
        });
      }
    } catch (e) {
      debugPrint('Error checking if word is saved: $e');
    }
  }

  Future<void> _loadDefinition() async {
    try {
      final definition = await _dictionaryService.getDefinition(
        widget.word,
        widget.language,
      );
      setState(() {
        _definition = definition;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _definition = null;
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _speakWord() async {
    if (_isSpeaking) return;

    setState(() {
      _isSpeaking = true;
    });

    try {
      await _dictionaryService.speakWord(
        widget.word,
        widget.language.code,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to speak word: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _toggleSaveWord() async {
    if (_definition == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isSaved && _savedWordId != null) {
        // Unsave the word
        await _savedWordsRepository.removeWord(_savedWordId!);
        setState(() {
          _isSaved = false;
          _savedWordId = null;
        });
      } else {
        // Save the word
        final meanings = _definition!['meanings'] as List<dynamic>;
        if (meanings.isNotEmpty) {
          final firstMeaning = meanings[0] as Map<String, dynamic>;
          final definitions = firstMeaning['definitions'] as List<dynamic>;
          if (definitions.isNotEmpty) {
            final firstDefinition = definitions[0] as Map<String, dynamic>;

            final savedWord = SavedWord(
              id: const Uuid().v4(),
              word: widget.word,
              definition: firstDefinition['definition'] as String? ?? 'No definition available',
              language: widget.language.code,
              examples: [
                if (firstDefinition['translatedExample'] != null)
                  firstDefinition['translatedExample'] as String
                else if (firstDefinition['example'] != null)
                  firstDefinition['example'] as String,
              ],
              savedAt: DateTime.now(),
            );

            debugPrint('Saving word: ${savedWord.toJson()}');
            await _savedWordsRepository.saveWord(savedWord);

            setState(() {
              _isSaved = true;
              _savedWordId = savedWord.id;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error toggling word save state: $e');
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        final errorMessage = e.toString().contains('already saved')
          ? 'This word is already in your saved words'
          : 'Failed to update word';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  List<Widget> _buildMeanings() {
    final meanings = _definition!['meanings'] as List<dynamic>;
    if (meanings.isEmpty) {
      return [const Text('No meanings found')];
    }

    return meanings.map<Widget>((meaning) {
      final partOfSpeech = meaning['partOfSpeech'] as String?;
      final definitions = meaning['definitions'] as List<dynamic>;

      if (definitions.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (partOfSpeech != null && partOfSpeech.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              partOfSpeech.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          ...definitions.map<Widget>((def) {
            final definition = def['definition'] as String?;
            final example = def['example'] as String?;
            final translatedExample = def['translatedExample'] as String?;
            final synonyms = def['synonyms'] as List<dynamic>?;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (definition != null)
                    Text(
                      '• $definition',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (example != null || translatedExample != null) ...[
                    const SizedBox(height: 4),
                    if (widget.language.code == 'en' && example != null)
                      Text(
                        'Example: "$example"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      )
                    else ...[
                      if (translatedExample != null)
                        Text(
                          'Example: "$translatedExample"',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      if (example != null)
                        Text(
                          '(English: "$example")',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ],
                  if (synonyms != null && synonyms.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: synonyms.map<Widget>((synonym) => Chip(
                        label: Text(
                          synonym.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      )).toList(),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      );
    }).toList();
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordTitle() {
    if (widget.language.code == 'ja' && _furigana != null) {
      return RubyText(
        [
          RubyTextData(
            _furigana!['text'] ?? widget.word,
            ruby: _furigana!['reading'] ?? widget.word,
          ),
        ],
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        widget.word,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWordTitle(),
                        if (_definition != null && 
                            _definition!['translatedWord'] != widget.word) ...[
                          const SizedBox(height: 4),
                          Text(
                            _definition!['translatedWord'] as String,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (!_isLoading)
                        IconButton(
                          onPressed: _speakWord,
                          icon: Icon(
                            _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                            color: _isSpeaking ? Theme.of(context).colorScheme.primary : null,
                          ),
                        ),
                      if (!_isLoading && _definition != null)
                        IconButton(
                          onPressed: _toggleSaveWord,
                          icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                            color: _isSaved ? Colors.purple : null,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_error != null)
                    _buildErrorMessage()
                  else if (_definition != null)
                    ..._buildMeanings()
                  else
                    const Text('No definition found'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
