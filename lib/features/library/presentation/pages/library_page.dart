import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/features/books/domain/models/book.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/books/presentation/pages/book_reader_page.dart';
import 'package:Keyra/features/home/presentation/widgets/book_card.dart';
import 'package:Keyra/features/books/data/repositories/book_repository.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  final _bookRepository = BookRepository();
  final _userStatsRepository = UserStatsRepository();
  List<Book> _filteredBooks = [];
  List<Book> _allBooks = [];
  Timer? _debounce;
  bool _isSearching = false;
  bool _isLoading = true;
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
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
        final matchesSearch = book.getTitle(BookLanguage.english).toLowerCase().contains(searchTerm);
        
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
          const SnackBar(content: Text('Failed to update favorite status')),
        );
      }
    }
  }

  void _onBookTap(Book book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookReaderPage(
          book: book,
          language: BookLanguage.english,
          userStatsRepository: _userStatsRepository,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
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
            _activeFilter = selected ? label : 'All';
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
          title: book.getTitle(BookLanguage.english),
          coverImagePath: book.coverImage,
          isFavorite: book.isFavorite,
          onFavoriteTap: () => _toggleFavorite(index),
          onTap: () => _onBookTap(book),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.paddingLg,
          child: Text(
            'Library',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
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
              hintText: 'Search your books...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
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
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              _buildFilterChip('All'),
              _buildFilterChip('Favorites'),
              _buildFilterChip('Recents'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    _loadBooks();
                  },
                  child: _buildBookGrid(_filteredBooks),
                ),
        ),
      ],
    );
  }
}
