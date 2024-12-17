import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_page.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/word_definition_modal.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:japanese_word_tokenizer/japanese_word_tokenizer.dart';

class BookReaderPage extends StatefulWidget {
  final Book book;
  final BookLanguage language;
  final UserStatsRepository userStatsRepository;
  final DictionaryService dictionaryService;

  const BookReaderPage({
    super.key,
    required this.book,
    required this.language,
    required this.userStatsRepository,
    required this.dictionaryService,
  });

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late PageController _pageController;
  int _currentPage = 0;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  final double _volume = 1.0;
  bool _hasMarkedAsRead = false;
  final bool _isLoading = false;
  double _textScale = 1.0;
  static const double _baseFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
    _startReadingSession();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    _endReadingSession();
    super.dispose();
  }

  Future<void> _startReadingSession() async {
    try {
      await widget.userStatsRepository.startReadingSession();
    } catch (e) {
      debugPrint('Error starting reading session: $e');
    }
  }

  Future<void> _endReadingSession() async {
    try {
      await widget.userStatsRepository.endReadingSession();
    } catch (e) {
      debugPrint('Error ending reading session: $e');
    }
  }

  Future<void> _markBookAsRead() async {
    if (!_hasMarkedAsRead) {
      try {
        await widget.userStatsRepository.markBookAsRead();
        _hasMarkedAsRead = true;
      } catch (e) {
        debugPrint('Error marking book as read: $e');
      }
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    if (page == widget.book.pages.length - 1) {
      _markBookAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _endReadingSession();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () {
              setState(() {
                _textScale = (_textScale - 0.1).clamp(0.8, 2.0);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              setState(() {
                _textScale = (_textScale + 0.1).clamp(0.8, 2.0);
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.book.pages.length,
              itemBuilder: (context, index) {
                final page = widget.book.pages[index];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildPage(context, page),
                      if (page.getAudioPath(widget.language) != null)
                        Padding(
                          padding: AppSpacing.paddingVerticalMd,
                          child: _buildAudioPlayer(),
                        ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                '${_currentPage + 1} / ${widget.book.pages.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _currentPage < widget.book.pages.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, BookPage page) {
    final screenHeight = MediaQuery.of(context).size.height;
    final text = page.getText(widget.language);
    
    return Container(
      padding: AppSpacing.paddingMd,
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (page.imagePath != null) ...[
            SizedBox(
              height: screenHeight * 0.4,
              child: Image.network(
                page.imagePath!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading image: $error');
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (text.isNotEmpty)
            Padding(
              padding: AppSpacing.paddingMd,
              child: _buildTextContent(context, text),
            ),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, String content) {
    return FutureBuilder<List<WordReading>>(
      future: widget.language.code == 'ja'
          ? _processJapaneseText(content)
          : _processNonJapaneseText(content),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final wordsWithReadings = snapshot.data!;
        final textSpans = <InlineSpan>[];
        
        for (var wordReading in wordsWithReadings) {
          if (wordReading.word.trim().isEmpty) {
            textSpans.add(TextSpan(text: ' '));
            continue;
          }
          
          textSpans.add(
            TextSpan(
              text: wordReading.word,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint('Tapped word: ${wordReading.word}');
                  WordDefinitionModal.show(
                    context,
                    wordReading.word,
                    widget.language,
                  );
                },
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: _baseFontSize * _textScale,
                height: 1.5,
              ),
            ),
          );
        }

        return SelectableText.rich(
          TextSpan(children: textSpans),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: _baseFontSize * _textScale,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        );
      },
    );
  }

  Future<List<WordReading>> _processJapaneseText(String text) async {
    try {
      final tokens = tokenize(text);
      final List<WordReading> results = [];
      
      for (var token in tokens) {
        final word = token.toString();
        
        // Skip whitespace
        if (word.trim().isEmpty) {
          results.add(WordReading(' ', null));
          continue;
        }

        // Handle punctuation and symbols directly
        if (RegExp(r'[。、！？「」『』（）・〜…]').hasMatch(word)) {
          results.add(WordReading(word, null));
          continue;
        }

        // Add the word
        results.add(WordReading(word, null));
      }
      
      return results;
    } catch (e) {
      debugPrint('Error processing Japanese text: $e');
      return [WordReading(text, null)];
    }
  }

  Future<List<WordReading>> _processNonJapaneseText(String text) async {
    final List<WordReading> results = [];
    
    // Split text into words while preserving punctuation and spaces
    final pattern = RegExp(r'(\s+|[^\s\p{L}]+|\p{L}+)', unicode: true);
    final matches = pattern.allMatches(text);
    
    for (var match in matches) {
      final word = match.group(0)!;
      
      // Add the word or punctuation
      results.add(WordReading(word, null));
    }
    
    return results;
  }

  Widget _buildAudioPlayer() {
    return Center(
      child: IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause_circle : Icons.play_circle,
          color: const Color(0xFF6750A4),
        ),
        iconSize: 48,
        onPressed: () async {
          if (_isPlaying) {
            await _audioPlayer.pause();
            setState(() {
              _isPlaying = false;
            });
          } else {
            final audioPath = widget.book.pages[_currentPage].getAudioPath(widget.language);
            if (audioPath != null) {
              await _audioPlayer.play(AssetSource(audioPath));
              setState(() {
                _isPlaying = true;
              });
            }
          }
        },
      ),
    );
  }
}
