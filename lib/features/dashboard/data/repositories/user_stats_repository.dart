import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/user_stats.dart';

class UserStatsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserStatsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<UserStats> getUserStats() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .withConverter(
            fromFirestore: UserStats.fromFirestore,
            toFirestore: (UserStats stats, _) => stats.toFirestore(),
          );

      // Get the document
      final docSnap = await docRef.get();
      
      // If document doesn't exist, initialize it
      if (!docSnap.exists) {
        print('Initializing user stats document for user: ${user.uid}');
        await _initializeUserStats(user.uid);
        // Get the newly created document
        final newDocSnap = await docRef.get();
        return newDocSnap.data() ?? const UserStats();
      }

      return docSnap.data() ?? const UserStats();
    } catch (e) {
      print('Error getting user stats: $e');
      throw Exception('Failed to get user stats: $e');
    }
  }

  Stream<UserStats> streamUserStats() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .withConverter(
          fromFirestore: UserStats.fromFirestore,
          toFirestore: (UserStats stats, _) => stats.toFirestore(),
        )
        .snapshots()
        .asyncMap((snapshot) async {
          if (!snapshot.exists) {
            // Initialize the document and wait for it to complete
            await _initializeUserStats(user.uid);
            // Get the newly created document
            final newSnapshot = await _firestore
                .collection('users')
                .doc(user.uid)
                .withConverter(
                  fromFirestore: UserStats.fromFirestore,
                  toFirestore: (UserStats stats, _) => stats.toFirestore(),
                )
                .get();
            return newSnapshot.data() ?? const UserStats();
          }
          return snapshot.data() ?? const UserStats();
        });
  }

  Future<void> _initializeUserStats(String userId) async {
    try {
      // Create a default UserStats instance
      const defaultStats = UserStats(
        booksRead: 0,
        favoriteBooks: 0,
        readingStreak: 0,
        savedWords: 0,
        readDates: [],
        isReadingActive: false,
        currentSessionMinutes: 0,
      );

      // Convert to Firestore data using the model's toFirestore method
      final data = defaultStats.toFirestore();
      
      // Add server timestamp
      data['lastUpdated'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
      
      print('Successfully initialized user stats document');
    } catch (e) {
      print('Error initializing user stats: $e');
      throw Exception('Failed to initialize user stats: $e');
    }
  }

  Future<void> incrementSavedWords() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'savedWords': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error incrementing saved words: $e');
      throw Exception('Failed to increment saved words: $e');
    }
  }

  Future<void> decrementSavedWords() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'savedWords': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error decrementing saved words: $e');
      throw Exception('Failed to decrement saved words: $e');
    }
  }

  Future<void> markBookAsRead() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final docRef = _firestore.collection('users').doc(user.uid);
    final stats = await getUserStats();
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check if we already read a book today
    final readToday = stats.readDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);

    // Update streak logic
    int newStreak = stats.readingStreak;
    if (!readToday) {
      if (stats.isStreakActive()) {
        // Continue streak
        newStreak += 1;
      } else {
        // Reset streak
        newStreak = 1;
      }
    }

    await docRef.set(
      {
        'booksRead': FieldValue.increment(1),
        'readingStreak': newStreak,
        'lastReadDate': Timestamp.fromDate(today),
        'readDates': FieldValue.arrayUnion([Timestamp.fromDate(today)]),
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> startReadingSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    await _firestore.collection('users').doc(user.uid).set(
      {
        'sessionStartTime': Timestamp.fromDate(now),
        'isReadingActive': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> endReadingSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final stats = await getUserStats();
    if (stats.sessionStartTime == null || !stats.isReadingActive) {
      return;
    }

    await _firestore.collection('users').doc(user.uid).set(
      {
        'currentSessionMinutes': 0,
        'sessionStartTime': null,
        'isReadingActive': false,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> incrementFavoriteBooks() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'favoriteBooks': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error incrementing favorite books: $e');
      throw Exception('Failed to increment favorite books: $e');
    }
  }

  Future<void> decrementFavoriteBooks() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'favoriteBooks': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error decrementing favorite books: $e');
      throw Exception('Failed to decrement favorite books: $e');
    }
  }
}
