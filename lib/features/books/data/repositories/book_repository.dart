import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/book.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';

class BookRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserStatsRepository _userStatsRepository;

  BookRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userStatsRepository = userStatsRepository ?? UserStatsRepository();

  // Get all books
  Stream<List<Book>> getAllBooks() {
    print('BookRepository: Getting all books from Firestore');
    final user = _auth.currentUser;
    if (user == null) {
      print('BookRepository: No user logged in, getting books without favorites');
      return _firestore
          .collection('books')
          .snapshots()
          .map((snapshot) {
            print('BookRepository: Retrieved ${snapshot.docs.length} books from Firestore');
            final books = snapshot.docs
                .map((doc) {
                  print('BookRepository: Converting Firestore doc ${doc.id} to Book');
                  return Book.fromMap(doc.data(), docId: doc.id);
                })
                .toList();
            print('BookRepository: Returning ${books.length} books');
            return books;
          });
    }

    print('BookRepository: User ${user.uid} logged in, getting books with favorites');
    return _firestore.collection('books').snapshots().asyncMap((booksSnapshot) async {
      print('BookRepository: Retrieved ${booksSnapshot.docs.length} books from Firestore');
      Set<String> favoriteBookIds = {};
      try {
        final userFavoritesDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .get();
        favoriteBookIds = userFavoritesDoc.docs.map((doc) => doc.id).toSet();
        print('BookRepository: User has ${favoriteBookIds.length} favorite books');
      } catch (e) {
        print('BookRepository: Error fetching favorites: $e');
        // Continue with empty favorites if there's an error
      }

      final books = booksSnapshot.docs.map((doc) {
        print('BookRepository: Converting Firestore doc ${doc.id} to Book');
        final book = Book.fromMap(doc.data(), docId: doc.id);
        final isFavorite = favoriteBookIds.contains(book.id);
        print('BookRepository: Book ${doc.id} isFavorite: $isFavorite');
        return book.copyWith(isFavorite: isFavorite);
      }).toList();
      
      print('BookRepository: Returning ${books.length} books with favorites');
      return books;
    });
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
      } else {
        print('Removing book ${book.id} from favorites');
        await favoriteRef.delete();
      }
      print('Successfully updated favorite status');
      
      // Update the user's favorite books count
      await _userStatsRepository.updateFavoriteCount();
      print('Successfully updated favorite count in user stats');
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
