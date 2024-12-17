import 'package:flutter/material.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dictionary/domain/models/saved_word.dart';
import 'package:uuid/uuid.dart';

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
    final height = MediaQuery.of(context).size.height * 0.6; // Fixed height at 60% of screen
    
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
        );
        
        if (mounted) {
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
        final definition = _definition!['definitions']?.isNotEmpty == true
            ? _definition!['definitions'][0]
            : 'No definition available';
            
        final examples = _definition!['examples'] as List?;
        final savedWord = SavedWord(
          id: const Uuid().v4(),
          word: widget.word,
          definition: definition,
          language: widget.language.code,
          examples: examples != null && examples.isNotEmpty 
              ? [examples[0].toString()] // Save only the first example in target language
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
    
    // Pastel colors for different sections
    const definitionsBgColor = Color(0xFFF5F5FF); // Light blue pastel
    const examplesBgColor = Color(0xFFFFF5F5); // Light pink pastel
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add JLPT and Common Word indicators at the top
            if (_definition?['jlpt'] != null || _definition?['isCommon'] == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                child: Row(
                  children: [
                    if (_definition?['jlpt'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _definition!['jlpt'],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (_definition?['isCommon'] == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'Common',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
                        Text(
                          widget.word,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Add parts of speech after the word
                        if (_definition?['partsOfSpeech'] != null && (_definition!['partsOfSpeech'] as List).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Text(
                              (_definition!['partsOfSpeech'] as List).join(', '),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        if (_definition?['reading'] != null && _definition!['reading'] != widget.word)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _definition!['reading'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF9C4), // Light yellow color
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
                  color: Colors.green[50], // Light pastel green background
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meanings:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_definition!['meanings'] as List)
                        .take(6) // Limit to 6 meanings
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.language.code == 'ja' && _definition?['reading'] != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF3E5F5), // Light purple color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_definition?['reading'] != null) ...[
                      Text(
                        'Reading:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _definition!['reading'],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                    if (_definition?['onyomi'] != null && (_definition!['onyomi'] as List).isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'On\'yomi:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (_definition!['onyomi'] as List).join('、 '),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    if (_definition?['kunyomi'] != null && (_definition!['kunyomi'] as List).isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Kun\'yomi:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (_definition!['kunyomi'] as List).join('、 '),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            if (_definition?['examples'] != null && _definition!['examples'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example Sentences:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_definition!['examples'] as List).map((example) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              example['japanese'],
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              example['english'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_definition?['partOfSpeech'] != null && _definition!['partOfSpeech'] != 'unknown')
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _definition!['partOfSpeech'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (_definition?['definitions'] != null && (_definition!['definitions'] as List).isNotEmpty) ...[
              Text(
                'Definitions:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: definitionsBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (_definition!['definitions'] as List).length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: theme.textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Text(
                              _definition!['definitions'][index],
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            if (_definition?['examples'] != null && (_definition!['examples'] as List).isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Examples:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: examplesBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (_definition!['examples'] as List).length ~/ 2,
                  itemBuilder: (context, index) {
                    final targetExample = _definition!['examples'][index * 2];
                    final englishExample = _definition!['examples'][index * 2 + 1];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  targetExample,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (englishExample != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                              child: Text(
                                englishExample,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            // Add detailed meanings section
            if (_definition?['detailedMeanings'] != null && (_definition!['detailedMeanings'] as List).isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Information:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_definition!['detailedMeanings'] as List).map((meaning) {
                      List<Widget> meaningWidgets = [];
                      
                      if (meaning['info'] != null && (meaning['info'] as List).isNotEmpty) {
                        meaningWidgets.add(
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              (meaning['info'] as List).join(', '),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        );
                      }

                      if (meaning['see_also'] != null && (meaning['see_also'] as List).isNotEmpty) {
                        meaningWidgets.add(
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'See also: ${(meaning['see_also'] as List).join(', ')}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: meaningWidgets,
                      );
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
