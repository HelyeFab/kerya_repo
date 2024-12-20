import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/presentation/bloc/language_bloc.dart';
import 'package:Keyra/core/widgets/language_selector.dart';
import 'package:Keyra/core/widgets/menu_button.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/core/widgets/loading_indicator.dart';
import 'package:Keyra/core/widgets/mini_stats_display.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/books/presentation/pages/book_reader_page.dart';
import 'package:Keyra/features/home/presentation/widgets/book_card.dart';
import 'package:Keyra/features/books/data/repositories/book_repository.dart';
import 'package:Keyra/features/books/data/repositories/firestore_populator.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bookRepository = BookRepository();
  final _userStatsRepository = UserStatsRepository();
  final _dictionaryService = DictionaryService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    print('HomePage: Starting to load books');
    // Start with loading state
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Try to populate books if they don't exist
      final populator = FirestorePopulator();
      print('HomePage: Checking if sample books are populated');
      final exists = await populator.areSampleBooksPopulated();
      if (!exists) {
        print('HomePage: No books found in Firestore, attempting to populate...');
        await populator.populateWithSampleBooks();
        print('HomePage: Sample books population completed');
      } else {
        print('HomePage: Sample books already exist in Firestore');
      }

      print('HomePage: Starting to listen for books from Firestore');
      // Load from Firestore
      _bookRepository.getAllBooks().listen(
        (loadedBooks) {
          print('HomePage: Received ${loadedBooks.length} books from Firestore');
          if (loadedBooks.isEmpty) {
            print('HomePage: No books loaded from Firestore, retrying population...');
            populator.populateWithSampleBooks().then((_) {
              print('HomePage: Repopulation completed, reloading books');
              // After population, try loading again
              _loadBooks();
            }).catchError((error) {
              print('HomePage: Error populating books: $error');
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to load books. Please try again later.')),
              );
            });
          } else {
            print('HomePage: Successfully loaded ${loadedBooks.length} books, updating state');
            setState(() {
              _books = loadedBooks;
              _isLoading = false;
            });
          }
        },
        onError: (error) {
          print('HomePage: Error loading books from Firestore: $error');
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load books. Please try again later.')),
          );
        },
      );
    } catch (e) {
      print('HomePage: Error in _loadBooks: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load books. Please try again later.')),
      );
    }
  }

  void _toggleFavorite(int index) async {
    final book = _books[index];
    final updatedBook = book.copyWith(isFavorite: !book.isFavorite);
    
    setState(() {
      _books[index] = updatedBook;
    });

    try {
      await _bookRepository.updateBookFavoriteStatus(updatedBook);
    } catch (e) {
      // Revert on error
      setState(() {
        _books[index] = book;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorite status')),
      );
    }
  }

  void _onBookTap(Book book) {
    final selectedLanguage = context.read<LanguageBloc>().state.selectedLanguage;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookReaderPage(
          book: book,
          language: selectedLanguage,
          userStatsRepository: _userStatsRepository,
          dictionaryService: _dictionaryService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: const [
              MenuButton(),
              SizedBox(width: 16),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppSpacing.paddingLg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MiniStatsDisplay(),
                    Row(
                      children: [
                        LanguageSelector(
                          currentLanguage: languageState.selectedLanguage,
                          onLanguageChanged: (language) {
                            if (language != null) {
                              context.read<LanguageBloc>().add(
                                LanguageChanged(language),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.lg),
                      child: Text(
                        'Recently Added Stories',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 280,
                      child: _isLoading
                          ? const Center(
                              child: LoadingIndicator(size: 100),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                              scrollDirection: Axis.horizontal,
                              itemCount: _books.length,
                              itemBuilder: (context, index) {
                                final book = _books[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: AppSpacing.md),
                                  child: SizedBox(
                                    width: 180,
                                    child: BookCard(
                                      title: book.getTitle(languageState.selectedLanguage),
                                      coverImagePath: book.coverImage,
                                      isFavorite: book.isFavorite,
                                      onFavoriteTap: () => _toggleFavorite(index),
                                      onTap: () => _onBookTap(book),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        'Continue Reading',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _isLoading
                        ? const Center(
                            child: LoadingIndicator(size: 100),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            itemCount: _books.length,
                            itemBuilder: (context, index) {
                              final book = _books[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: AppSpacing.md, left: AppSpacing.sm, right: AppSpacing.sm),
                                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      child: Image.network(
                                        book.coverImage,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error loading cover image: $error');
                                          return const Center(child: Icon(Icons.error));
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const LoadingIndicator(size: 30);
                                        },
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    book.getTitle(languageState.selectedLanguage),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    'Page ${book.currentPage + 1} of ${book.pages.length}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                  onTap: () => _onBookTap(book),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
