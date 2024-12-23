import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/book.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import '../services/book_cache_service.dart';

class BookRepository {
  final BookCacheService _cacheService;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserStatsRepository _userStatsRepository;

  static Future<BookRepository> create({
    BookCacheService? cacheService,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
  }) async {
    final repo = BookRepository._(
      cacheService: cacheService,
      firestore: firestore,
      storage: storage,
      auth: auth,
      userStatsRepository: userStatsRepository,
    );
    await repo._initCacheService();
    return repo;
  }

  BookRepository._({
    BookCacheService? cacheService,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userStatsRepository = userStatsRepository ?? UserStatsRepository(),
        _cacheService = cacheService ?? BookCacheService();

  Future<void> _initCacheService() async {
    try {
      print('BookRepository: Initializing cache service...');
      await _cacheService.init();
      print('BookRepository: Cache service initialized successfully');
    } catch (e, stackTrace) {
      print('BookRepository: Error initializing cache service: $e');
      print('Stack trace: $stackTrace');
      // Continue without cache if initialization fails
    }
  }

  // Get all books
  Stream<List<Book>> getAllBooks() async* {
    print('BookRepository: Starting getAllBooks');
    
    try {
      // Ensure cache service is initialized
      await _initCacheService();
      
      // First, check and return cached books if available
      if (_cacheService.hasCache) {
        print('BookRepository: Returning cached books');
        yield _cacheService.getCachedBooks();
      }
    } catch (e) {
      print('BookRepository: Error accessing cache: $e');
      // Continue without cache
    }

    final user = _auth.currentUser;
    print('BookRepository: User authentication status - ${user != null ? 'Logged in' : 'Not logged in'}');

    try {
      // Listen to Firestore updates
      await for (final snapshot in _firestore.collection('books').snapshots()) {
        print('BookRepository: Received Firestore update with ${snapshot.docs.length} books');
        
        List<Book> books = [];
        Set<String> favoriteBookIds = {};

        // If user is logged in, fetch their favorites
        if (user != null) {
          try {
            final userFavoritesDoc = await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('favorites')
                .get();
            favoriteBookIds = userFavoritesDoc.docs.map((doc) => doc.id).toSet();
            print('BookRepository: Fetched ${favoriteBookIds.length} favorites for user');
          } catch (e) {
            print('BookRepository: Error fetching favorites: $e');
            // Continue with empty favorites
          }
        }

        // Process each book document
        for (var doc in snapshot.docs) {
          try {
            print('BookRepository: Processing book ${doc.id}');
            final book = Book.fromMap(doc.data(), docId: doc.id);
            final isFavorite = favoriteBookIds.contains(book.id);
            
            // Add to books list
            books.add(book.copyWith(isFavorite: isFavorite));
          } catch (e) {
            print('BookRepository: Error processing book ${doc.id}: $e');
            // Continue processing other books
            continue;
          }
        }

        // Update cache with new books
        if (books.isNotEmpty) {
          print('BookRepository: Caching ${books.length} books');
          await _cacheService.cacheBooks(books);
        }

        // Yield the updated book list
        print('BookRepository: Yielding ${books.length} books');
        yield books;
      }
    } catch (e) {
      print('BookRepository: Error in getAllBooks: $e');
      // If we have cached books, return them as fallback
      if (_cacheService.hasCache) {
        print('BookRepository: Returning cached books as fallback');
        yield _cacheService.getCachedBooks();
      } else {
        print('BookRepository: No cached books available for fallback');
        yield [];
      }
    }
  }

  // Get a single book by ID
  Future<Book?> getBookById(String id) async {
    final doc = await _firestore.collection('books').doc(id).get();
    if (!doc.exists) return null;
    return Book.fromMap(doc.data()!, docId: doc.id);
  }

  // Add a new book
  Future<String> addBook(Book book, File bookFile, File? coverImage) async {
    // Upload book file
    final bookRef = _storage.ref('books/${book.id}/${book.title}.pdf');
    await bookRef.putFile(bookFile);
    final bookUrl = await bookRef.getDownloadURL();

    // Upload cover image if provided
    String coverUrl = book.coverImage;
    if (coverImage != null) {
      final coverRef = _storage.ref('covers/${book.id}.jpg');
      await coverRef.putFile(coverImage);
      coverUrl = await coverRef.getDownloadURL();
    }

    // Create book with updated URLs
    final updatedBook = book.copyWith(
      fileUrl: bookUrl,
      coverImage: coverUrl,
    );

    // Save to Firestore
    final docRef = await _firestore.collection('books').add(updatedBook.toMap());
    return docRef.id;
  }

  // Update a book
  Future<void> updateBook(Book book) async {
    await _firestore.collection('books').doc(book.id).update(book.toMap());
  }

  // Update book favorite status
  Future<void> updateBookFavoriteStatus(Book book) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Get fresh ID token to ensure we have valid authentication
    try {
      final idToken = await user.getIdToken(true);
      print('Got fresh ID token');
      
      // Verify user is properly authenticated
      print('User auth state:');
      print('- UID: ${user.uid}');
      print('- Email: ${user.email}');
      print('- Email verified: ${user.emailVerified}');
      print('- Anonymous: ${user.isAnonymous}');
      
      final bookDoc = await _firestore.collection('books').doc(book.id).get();
      if (!bookDoc.exists) {
        throw Exception('Book ${book.id} does not exist');
      }
      print('Book exists: ${book.id}');

      final userRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      
      if (!userDoc.exists) {
        print('Creating user document for ${user.uid}');
        await userRef.set({
          'email': user.email,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      print('User document exists for ${user.uid}');

      final favoriteRef = userRef.collection('favorites').doc(book.id);

      if (book.isFavorite) {
        print('Adding book ${book.id} to favorites');
        await favoriteRef.set({
          'bookId': book.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await _userStatsRepository.incrementFavoriteBooks();
      } else {
        print('Removing book ${book.id} from favorites');
        await favoriteRef.delete();
        await _userStatsRepository.decrementFavoriteBooks();
      }
      print('Successfully updated favorite status');
    } catch (e, stackTrace) {
      print('Error updating favorite status: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to update favorite status: ${e.toString()}');
    }
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    // Delete book file and cover from Storage
    try {
      await _storage.ref('books/$id').delete();
      await _storage.ref('covers/$id.jpg').delete();
    } catch (e) {
      // Ignore if files don't exist
    }

    // Delete from Firestore
    await _firestore.collection('books').doc(id).delete();
  }
}
