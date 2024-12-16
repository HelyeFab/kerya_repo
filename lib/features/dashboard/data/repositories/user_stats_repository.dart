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

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .withConverter(
          fromFirestore: UserStats.fromFirestore,
          toFirestore: (UserStats stats, _) => stats.toFirestore(),
        );

    final docSnap = await docRef.get();
    return docSnap.data() ?? const UserStats();
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
        .map((snapshot) => snapshot.data() ?? const UserStats());
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

  Future<void> updateFavoriteBooks(int count) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firestore.collection('users').doc(user.uid).set(
      {
        'favoriteBooks': count,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateFavoriteCount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get the count of favorite books
      final favoritesSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();
      
      final favoriteCount = favoritesSnapshot.docs.length;

      // Update the user stats with the new favorite count
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
            'favoriteBooks': favoriteCount,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating favorite count: $e');
      throw Exception('Failed to update favorite count');
    }
  }
}
