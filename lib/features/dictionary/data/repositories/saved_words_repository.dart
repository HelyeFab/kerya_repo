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

      final userRef = _firestore.collection('users').doc(user.uid);
      final wordsRef = userRef.collection('saved_words');

      // Save the word
      await wordsRef.doc(word.id).set(word.toFirestore());

      // Update saved words count in user stats
      await updateSavedWordsCount();
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
      final userRef = _firestore.collection('users').doc(user.uid);
      final wordsRef = userRef.collection('saved_words');

      // Remove the word
      await wordsRef.doc(wordId).delete();

      // Update saved words count in user stats
      await updateSavedWordsCount();
    } catch (e) {
      print('Error removing word: $e');
      throw Exception('Failed to remove word');
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

  Future<void> updateSavedWordsCount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final savedWords = await getSavedWords().first;
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'saved_words_count': savedWords.length});
    } catch (e) {
      throw Exception('Failed to update saved words count');
    }
  }
}
