import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card_controller.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../features/dictionary/domain/models/saved_word.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../../../../features/dictionary/domain/services/spaced_repetition_service.dart';
import '../widgets/flashcard.dart';

class StudySessionPage extends StatefulWidget {
  final List<SavedWord> words;

  const StudySessionPage({
    super.key,
    required this.words,
  });

  @override
  State<StudySessionPage> createState() => _StudySessionPageState();
}

class _StudySessionPageState extends State<StudySessionPage> {
  late final PageController _pageController;
  final _spacedRepetitionService = SpacedRepetitionService();
  int _currentIndex = 0;
  List<FlipCardController> _flipControllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize a flip controller for each word
    _flipControllers = List.generate(
      widget.words.length,
      (_) => FlipCardController(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _markWord(int difficulty) async {
    final currentWord = widget.words[_currentIndex];
    
    try {
      // Calculate next review using spaced repetition
      final updatedWord = _spacedRepetitionService.calculateNextReview(
        currentWord,
        difficulty,
      );

      // Update word in repository
      final savedWordsRepo = context.read<SavedWordsRepository>();
      await savedWordsRepo.updateWord(updatedWord);
      
      final nextReview = _spacedRepetitionService.getNextReviewDate(updatedWord);
      print('Successfully updated word: ${updatedWord.word}');
      print('Progress: ${updatedWord.progress}, Difficulty: ${updatedWord.difficulty}');
      print('Repetitions: ${updatedWord.repetitions}, Ease Factor: ${updatedWord.easeFactor.toStringAsFixed(2)}');
      print('Next review in ${updatedWord.interval} days ($nextReview)');

      // Move to next word
      final nextIndex = _currentIndex + 1;
      if (nextIndex < widget.words.length) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // End of session
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('Error updating word: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update word progress. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Session (${_currentIndex + 1}/${widget.words.length})',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('End Session'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: ((_currentIndex + 1) / widget.words.length),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),

          // Flashcards
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.words.length,
              itemBuilder: (context, index) {
                final word = widget.words[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Flashcard(
                    word: word.word,
                    definition: word.definition,
                    examples: word.examples,
                    controller: _flipControllers[index],
                    language: word.language,
                  ),
                );
              },
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _markWord(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.light
                        ? AppColors.flashcardHardLight
                        : AppColors.flashcardHardDark,
                  ),
                  child: const Text('Hard'),
                ),
                ElevatedButton(
                  onPressed: () => _markWord(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.light
                        ? AppColors.flashcardGoodLight
                        : AppColors.flashcardGoodDark,
                  ),
                  child: const Text('Good'),
                ),
                ElevatedButton(
                  onPressed: () => _markWord(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.light
                        ? AppColors.flashcardEasyLight
                        : AppColors.flashcardEasyDark,
                  ),
                  child: const Text('Easy'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
