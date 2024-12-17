import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_page.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/word_definition_modal.dart';
import 'package:japanese_word_tokenizer/japanese_word_tokenizer.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';

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
          onPressed: () => Navigator.pop(context),
        ),
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
              child: widget.language.code == 'ja'
                  ? _buildJapaneseText(context, text)
                  : SelectableText.rich(
                      TextSpan(
                        children: _buildTextSpans(text),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildJapaneseText(BuildContext context, String text) {
    return FutureBuilder<List<(String, String?)>>(
      future: widget.dictionaryService.tokenizeWithReadings(text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Loading Japanese text...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  snapshot.error is DictionaryException
                      ? snapshot.error.toString()
                      : 'An error occurred while loading the text.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (snapshot.data?.isEmpty ?? true) {
          return const Center(
            child: Text('No text available'),
          );
        }

        final wordsWithReadings = snapshot.data!;
        final List<InlineSpan> textSpans = [];
        
        for (var (word, reading) in wordsWithReadings) {
          if (word.trim().isEmpty) continue;
          
          // Skip punctuation
          if (RegExp(r'[。、！？「」『』（）]').hasMatch(word)) {
            textSpans.add(TextSpan(text: word));
            continue;
          }
          
          textSpans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.ideographic,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: GestureDetector(
                  onTap: () {
                    debugPrint('Tapped Japanese word: $word');
                    WordDefinitionModal.show(
                      context,
                      word,
                      widget.language,
                    );
                  },
                  child: RubyText(
                    [RubyTextData(word, ruby: reading)],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18.0 * _textScale,
                    ),
                    rubyStyle: TextStyle(
                      fontSize: 10.0 * _textScale,
                      color: Colors.grey[600],
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return SelectableText.rich(
          TextSpan(children: textSpans),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18.0 * _textScale,
            height: 3.0, // Increased line height for Japanese text
          ),
          textAlign: TextAlign.justify,
        );
      },
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    if (text.isEmpty) return [];
    
    final words = text.split(' ');
    return words.map((word) {
      final cleanWord = word.replaceAll(RegExp(r'^[^\p{L}]+|[^\p{L}]+$', unicode: true), '');
      return TextSpan(
        text: '$word ',
        recognizer: cleanWord.isNotEmpty ? (TapGestureRecognizer()
          ..onTap = () {
            debugPrint('Tapped word: "$cleanWord"');
            WordDefinitionModal.show(
              context,
              cleanWord,
              widget.language,
            );
          }) : null,
      );
    }).toList();
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
