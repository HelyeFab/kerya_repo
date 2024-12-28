import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/presentation/bloc/language_bloc.dart';
import '../../../../core/widgets/reading_language_selector.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/mini_stats_display.dart';
import '../../../../core/widgets/menu_button.dart';
import '../../../../features/books/domain/models/book.dart';
import '../../../../features/books/presentation/widgets/book_card.dart';
import '../../../../features/books/presentation/pages/book_reader_page.dart';
import '../../../../features/books/data/repositories/book_repository.dart';
import '../../../../features/books/data/repositories/firestore_populator.dart';
import '../../../../features/dashboard/data/repositories/user_stats_repository.dart';
import '../../../../features/dictionary/data/services/dictionary_service.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../features/badges/presentation/widgets/badge_display.dart';
import '../../../../features/badges/presentation/bloc/badge_bloc.dart';
import '../../../../features/badges/presentation/bloc/badge_state.dart';
import '../../../../features/badges/presentation/bloc/badge_event.dart';
import '../../../../features/navigation/presentation/widgets/app_drawer.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/keyra_gradient_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BookRepository? _bookRepository;
  final _userStatsRepository = UserStatsRepository();
  final _dictionaryService = DictionaryService();
  List<Book> _allBooks = [];
  List<Book> _inProgressBooks = [];
  bool _isLoadingAll = true;
  bool _isLoadingInProgress = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _initializeRepository() async {
    _bookRepository = await BookRepository.create();
    if (mounted) {
      _loadBooks();
      _loadInProgressBooks();
    }
  }

  void _loadInProgressBooks() {
    print('HomePage: Starting to load in-progress books');
    setState(() {
      _isLoadingInProgress = true;
    });

    _bookRepository?.getInProgressBooks().listen(
      (books) {
        print('HomePage: Received ${books.length} in-progress books');
        if (mounted) {
          setState(() {
            _inProgressBooks = books;
            _isLoadingInProgress = false;
          });
        }
      },
      onError: (error) {
        print('HomePage: Error loading in-progress books: $error');
        if (mounted) {
          setState(() {
            _isLoadingInProgress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(UiTranslations.of(context).translate('home_error_load_books'))),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    // Initialize badge bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BadgeBloc>().add(const BadgeEvent.started());
      }
    });
  }

  void _loadBooks() async {
    print('HomePage: Starting to load books');
    // Start with loading state
      setState(() {
        _isLoadingAll = true;
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
      _bookRepository?.getAllBooks().listen(
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
                _isLoadingAll = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(UiTranslations.of(context).translate('home_error_load_books'))),
              );
            });
          } else {
            print('HomePage: Successfully loaded ${loadedBooks.length} books, updating state');
            setState(() {
              _allBooks = loadedBooks;
              _isLoadingAll = false;
            });
          }
        },
        onError: (error) {
          print('HomePage: Error loading books from Firestore: $error');
          setState(() {
            _isLoadingAll = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(UiTranslations.of(context).translate('home_error_load_books'))),
          );
        },
      );
    } catch (e) {
      print('HomePage: Error in _loadBooks: $e');
      setState(() {
        _isLoadingAll = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(UiTranslations.of(context).translate('home_error_load_books'))),
      );
    }
  }

  void _toggleFavorite(int index) async {
    final book = _allBooks[index];
    final updatedBook = book.copyWith(isFavorite: !book.isFavorite);
    
    setState(() {
      _allBooks[index] = updatedBook;
      // Update in progress books if necessary
      final inProgressIndex = _inProgressBooks.indexWhere((b) => b.id == book.id);
      if (inProgressIndex != -1) {
        _inProgressBooks[inProgressIndex] = updatedBook;
      }
    });

    try {
      await _bookRepository?.updateBookFavoriteStatus(updatedBook);
    } catch (e) {
      // Revert on error
      setState(() {
        _allBooks[index] = book;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(UiTranslations.of(context).translate('home_error_favorite'))),
      );
    }
  }

  void _onBookTap(Book book) {
    if (_bookRepository == null) {
      print('HomePage: BookRepository not initialized');
      return;
    }
    
    final selectedLanguage = context.read<LanguageBloc>().state.selectedLanguage;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookReaderPage(
          book: book,
          language: selectedLanguage,
          userStatsRepository: _userStatsRepository,
          dictionaryService: _dictionaryService,
          bookRepository: _bookRepository!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BlocBuilder<BadgeBloc, BadgeState>(
                  builder: (context, state) {
                    return state.map(
                      initial: (_) => const SizedBox.shrink(),
                      loaded: (loaded) => BadgeDisplay(
                        level: loaded.progress.currentLevel,
                      ),
                      levelingUp: (levelingUp) => BadgeDisplay(
                        level: levelingUp.progress.currentLevel,
                      ),
                    );
                  },
                ),
              ),
              actions: const [
                MenuButton(),
                SizedBox(width: 16),
              ],
            ),
            body: KeyraGradientBackground(
              gradientColor: AppColors.controlPurple,
              child: Column(
                children: [
                    const PageHeader(
                      title: '',
                      actions: [],
                      showBadge: false,
                    ),
                    Padding(
                  padding: AppSpacing.paddingLg,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MiniStatsDisplay(),
                      Row(
                        children: [
                          ReadingLanguageSelector(
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
                          UiTranslations.of(context).translate('home_recently_added_stories'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.sectionTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 280,
                        child: _isLoadingAll
                            ? const Center(
                                child: LoadingIndicator(size: 100),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                scrollDirection: Axis.horizontal,
                                itemCount: _allBooks.length,
                                itemBuilder: (context, index) {
                                  final book = _allBooks[index];
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
                          UiTranslations.of(context).translate('home_continue_reading'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.sectionTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _isLoadingInProgress
                          ? const Center(
                              child: LoadingIndicator(size: 100),
                            )
                          : _inProgressBooks.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSpacing.lg),
                                    child: Text(
                                      UiTranslations.of(context).translate('home_no_in_progress_books'),
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                  itemCount: _inProgressBooks.length,
                                  itemBuilder: (context, index) {
                                    final book = _inProgressBooks[index];
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
                                              cacheWidth: 100,
                                              cacheHeight: 100,
                                              errorBuilder: (context, error, stackTrace) {
                                                print('Error loading cover image: $error');
                                                return Container(
                                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                  child: const Center(
                                                    child: Icon(Icons.broken_image_outlined, size: 24),
                                                  ),
                                                );
                                              },
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return const Center(
                                                  child: LoadingIndicator(size: 24),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          book.getTitle(languageState.selectedLanguage),
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        subtitle: Text(
                                          UiTranslations.of(context).translate('home_page_progress')
                                              .replaceAll('{0}', (book.currentPage + 1).toString())
                                              .replaceAll('{1}', book.pages.length.toString()),
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
                  ),
                ],
            ),
            endDrawer: const AppDrawer(),
          ),
        );
      },
    );
  }
}
