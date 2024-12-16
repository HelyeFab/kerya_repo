import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:uuid/uuid.dart';

class WordDefinitionModal extends StatefulWidget {
  final String word;

  const WordDefinitionModal({
    super.key,
    required this.word,
  });

  static Future<void> show(BuildContext context, String word) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: WordDefinitionModal(word: word),
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
    _fetchDefinition();
    _checkIfWordIsSaved();
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

  Future<void> _fetchDefinition() async {
    try {
      final definition = await _dictionaryService.getDefinition(widget.word.toLowerCase());
      setState(() {
        _definition = definition;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _definition = null;
        _isLoading = false;
        _error = 'Word not found';
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
        final meanings = _definition!['meanings'] as List<dynamic>?;
        if (meanings?.isNotEmpty ?? false) {
          final firstMeaning = meanings![0] as Map<String, dynamic>;
          final definitions = firstMeaning['definitions'] as List<dynamic>?;
          if (definitions?.isNotEmpty ?? false) {
            final firstDefinition = definitions![0] as Map<String, dynamic>;

            final savedWord = SavedWord(
              id: const Uuid().v4(),
              word: widget.word,
              definition: firstDefinition['definition'] as String? ?? 'No definition available',
              phonetic: _definition!['phonetic'] as String?,
              examples: [
                if (firstDefinition['example'] != null)
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
    final meanings = _definition!['meanings'] as List<dynamic>?;
    if (meanings == null || meanings.isEmpty) {
      return [const Text('No meanings found')];
    }

    return meanings.map<Widget>((meaning) {
      final partOfSpeech = meaning['partOfSpeech'] as String?;
      final definitions = meaning['definitions'] as List<dynamic>?;

      if (definitions == null || definitions.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (partOfSpeech != null) ...[
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
                  if (example != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Example: "$example"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
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
                  Text(
                    widget.word,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
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
              if (_definition != null && _definition!['phonetic'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Phonetic: ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      _definition!['phonetic'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Noto Sans',
                        fontFeatures: const [
                          FontFeature.enable('ss01'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
