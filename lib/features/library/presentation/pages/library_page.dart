import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/presentation/bloc/language_bloc.dart';
import 'package:Keyra/core/widgets/reading_language_selector.dart';
import 'package:Keyra/core/widgets/loading_indicator.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';
import 'package:Keyra/core/widgets/mini_stats_display.dart';
import 'package:Keyra/core/widgets/menu_button.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/books/presentation/pages/book_reader_page.dart';
import 'package:Keyra/features/books/data/repositories/book_repository.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/features/home/presentation/widgets/book_card.dart';
import 'package:Keyra/core/ui_language/service/ui_translation_service.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late TextEditingController _searchController;
  late BookRepository _bookRepository;
  late UserStatsRepository _userStatsRepository;
  late DictionaryService _dictionaryService;
  late List<Book> _filteredBooks;
  late List<Book> _allBooks;
  Timer? _debounce;
  late bool _isSearching;
  late bool _isLoading;
  late String _activeFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _bookRepository = BookRepository();
    _userStatsRepository = UserStatsRepository();
    _dictionaryService = DictionaryService();
    _filteredBooks = [];
    _allBooks = [];
    _debounce = null;
    _isSearching = false;
    _isLoading = true;
    _activeFilter = 'All';
    _loadBooks();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadBooks() {
    _bookRepository.getAllBooks().listen(
      (loadedBooks) {
        setState(() {
          _allBooks = loadedBooks;
          _filteredBooks = loadedBooks;
          _isLoading = false;
        });
      },
      onError: (error) {
        print('Error loading books: $error');
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() => _isSearching = true);

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterBooks();
    });
  }

  void _filterBooks() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      var filtered = _allBooks.where((book) {
        final matchesSearch = book
            .getTitle(context.read<LanguageBloc>().state.selectedLanguage)
            .toLowerCase()
            .contains(searchTerm);

        switch (_activeFilter) {
          case 'All':
            return matchesSearch;
          case 'Favorites':
            return matchesSearch && book.isFavorite;
          case 'Recents':
            return matchesSearch && book.categories.contains('Recents');
          default:
            return matchesSearch && book.categories.contains(_activeFilter);
        }
      }).toList();

      _filteredBooks = filtered;
      _isSearching = false;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _activeFilter = filter;
    });
    _filterBooks();
  }

  void _toggleFavorite(int index) async {
    final book = _filteredBooks[index];
    final bookIndex = _allBooks.indexWhere((b) => b.id == book.id);
    if (bookIndex != -1) {
      final updatedBook = _allBooks[bookIndex].copyWith(
        isFavorite: !_allBooks[bookIndex].isFavorite,
      );

      setState(() {
        _allBooks[bookIndex] = updatedBook;
        _filteredBooks[index] = updatedBook;
      });

      try {
        await _bookRepository.updateBookFavoriteStatus(updatedBook);
      } catch (e) {
        // Revert on error
        setState(() {
          _allBooks[bookIndex] = book;
          _filteredBooks[index] = book;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorite status')),
        );
      }
    }
  }

  void _navigateToBookReader(BuildContext context, Book book) {
    final selectedLanguage =
        context.read<LanguageBloc>().state.selectedLanguage;
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

  void _onBookTap(Book book) {
    _navigateToBookReader(context, book);
  }

  Widget _buildFilterChip(String label) {
    bool isSelected;
    if (label == UiTranslationService.translate(context, 'all')) {
      isSelected = _activeFilter == 'All';
    } else if (label == UiTranslationService.translate(context, 'favorites')) {
      isSelected = _activeFilter == 'Favorites';
    } else if (label == UiTranslationService.translate(context, 'recents')) {
      isSelected = _activeFilter == 'Recents';
    } else {
      isSelected = false;
    }
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        selectedColor: Theme.of(context).colorScheme.primary,
        onSelected: (selected) {
          setState(() {
            String filterValue;
            if (label == UiTranslationService.translate(context, 'all')) {
              filterValue = 'All';
            } else if (label == UiTranslationService.translate(context, 'favorites')) {
              filterValue = 'Favorites';
            } else if (label == UiTranslationService.translate(context, 'recents')) {
              filterValue = 'Recents';
            } else {
              filterValue = 'All';
            }
            _activeFilter = selected ? filterValue : 'All';
            _filterBooks();
          });
        },
      ),
    );
  }

  Widget _buildBookGrid(List<Book> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          title: book
              .getTitle(context.read<LanguageBloc>().state.selectedLanguage),
          coverImagePath: book.coverImage,
          isFavorite: book.isFavorite,
          onFavoriteTap: () => _toggleFavorite(index),
          onTap: () => _onBookTap(book),
        );
      },
    );
  }

  Widget _buildLanguageSelector() {
    return ReadingLanguageSelector(
      currentLanguage: context.read<LanguageBloc>().state.selectedLanguage,
      onLanguageChanged: (language) {
        if (language != null) {
          context.read<LanguageBloc>().add(
                LanguageChanged(language),
              );
        }
      },
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
            children: [
              Padding(
                padding: AppSpacing.paddingLg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MiniStatsDisplay(),
                    Row(
                      children: [
                        _buildLanguageSelector(),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        UiTranslationService.translate(context, 'search books'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isSearching
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: LoadingIndicator(size: 24),
                            ),
                          )
                        : _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.3),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    _buildFilterChip(
                        UiTranslationService.translate(context, 'all')),
                    _buildFilterChip(
                        UiTranslationService.translate(context, 'favorites')),
                    _buildFilterChip(
                        UiTranslationService.translate(context, 'recents')),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: LoadingIndicator(size: 100),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _loadBooks();
                        },
                        child: _buildBookGrid(_filteredBooks),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
