import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_page.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/word_definition_modal.dart';

class BookReaderPage extends StatefulWidget {
  final Book book;
  final BookLanguage language;
  final UserStatsRepository userStatsRepository;

  const BookReaderPage({
    super.key,
    required this.book,
    required this.language,
    required this.userStatsRepository,
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
    // Mark book as read when reaching the last page
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
    print('Building page with text: $text');
    print('Image path: ${page.imagePath}');
    
    return Container(
      padding: AppSpacing.paddingMd,
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (page.imagePath != null) ...[
            Builder(builder: (_) {
              print('Attempting to load image: ${page.imagePath}');
              return const SizedBox();
            }),
            SizedBox(
              height: screenHeight * 0.4,
              child: Image.network(
                page.imagePath!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (text.isNotEmpty) ...[
            Builder(builder: (_) {
              print('Rendering text with length: ${text.length}');
              return const SizedBox();
            }),
            Padding(
              padding: AppSpacing.paddingMd,
              child: SelectableText.rich(
                TextSpan(
                  children: _buildTextSpans(text),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ] else
            Builder(builder: (_) {
              print('No text to display');
              return const SizedBox();
            }),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    if (text.isEmpty) return [];
    
    final words = text.split(' ');
    return words.map((word) {
      return TextSpan(
        text: '$word ',
        recognizer: TapGestureRecognizer()
          ..onTap = () => WordDefinitionModal.show(context, word.replaceAll(RegExp(r'[^\w\s]'), '')),
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
