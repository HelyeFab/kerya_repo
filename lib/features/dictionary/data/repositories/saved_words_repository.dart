import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/saved_word.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';

class SavedWordsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final UserStatsRepository _userStatsRepository;

  SavedWordsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userStatsRepository = userStatsRepository ?? UserStatsRepository();

  Future<bool> isWordSaved(String word) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_words')
          .where('word', isEqualTo: word.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if word is saved: $e');
      throw Exception('Failed to check if word is saved');
    }
  }

  Future<void> saveWord(SavedWord word) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check if word is already saved
      if (await isWordSaved(word.word)) {
        throw Exception('Word is already saved');
      }

      // Start a batch write
      final batch = _firestore.batch();
      
      final userRef = _firestore.collection('users').doc(user.uid);
      final wordsRef = userRef.collection('saved_words');

      // Add the word
      batch.set(wordsRef.doc(word.id), word.toFirestore());

      // Commit the batch
      await batch.commit();
      
      // Update saved words count based on actual count
      await _updateSavedWordsCount();
      
      print('Successfully saved word and updated count');
    } catch (e) {
      print('Error saving word: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> removeWord(String wordId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Start a batch write
      final batch = _firestore.batch();
      
      final userRef = _firestore.collection('users').doc(user.uid);
      final wordRef = userRef.collection('saved_words').doc(wordId);

      // Delete the word
      batch.delete(wordRef);

      // Commit the batch
      await batch.commit();
      
      // Update saved words count based on actual count
      await _updateSavedWordsCount();
      
      print('Successfully removed word and updated count');
    } catch (e) {
      print('Error removing word: $e');
      throw Exception('Failed to remove word');
    }
  }

  Future<void> _updateSavedWordsCount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get the actual count of saved words
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_words')
          .count()
          .get();

      final actualCount = querySnapshot.count;

      // Update the user stats with the actual count
      await _firestore.collection('users').doc(user.uid).set({
        'savedWords': actualCount,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Successfully updated saved words count to: $actualCount');
    } catch (e) {
      print('Error updating saved words count: $e');
      throw Exception('Failed to update saved words count');
    }
  }

  Stream<List<SavedWord>> getSavedWords({String? language}) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_words');

    // First filter by language if specified, then order by savedAt
    if (language != null) {
      query = query.where('language', isEqualTo: language);
    }
    
    // Apply ordering after any filters
    query = query.orderBy('savedAt', descending: true);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => SavedWord.fromFirestore(doc)).toList());
  }
}
