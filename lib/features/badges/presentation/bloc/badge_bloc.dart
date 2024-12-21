import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/badge_level.dart';
import '../../domain/models/badge_progress.dart';
import '../../domain/repositories/badge_repository.dart';
import '../../../dictionary/data/repositories/saved_words_repository.dart';
import 'badge_event.dart';
import 'badge_state.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final BadgeRepository _badgeRepository;
  final SavedWordsRepository _savedWordsRepository;
  StreamSubscription<BadgeProgress>? _progressSubscription;

  BadgeBloc({
    required BadgeRepository badgeRepository,
    required SavedWordsRepository savedWordsRepository,
  })  : _badgeRepository = badgeRepository,
        _savedWordsRepository = savedWordsRepository,
        super(const BadgeState.initial()) {
    on<BadgeEvent>((event, emit) async {
      await event.map(
        started: (_) async => await _onStarted(emit),
        wordsUpdated: (e) async => await _onWordsUpdated(e.wordCount, emit),
        levelUp: (e) async => await _onLevelUp(e.newLevel, emit),
      );
    });

    // Subscribe to badge progress changes
    _progressSubscription =
        _badgeRepository.getBadgeProgress().listen((progress) {
      add(BadgeEvent.wordsUpdated(
          progress.booksRead * 100)); // Rough estimate back to words
    });
  }

  Future<void> _onStarted(Emitter<BadgeState> emit) async {
    final progress = await _badgeRepository.getBadgeProgress().first;
    emit(BadgeState.loaded(progress));
  }

  Future<void> _onWordsUpdated(
    int wordCount,
    Emitter<BadgeState> emit,
  ) async {
    final currentState = state;
    if (!currentState.map(
      initial: (_) => false,
      loaded: (_) => true,
      levelingUp: (_) => true,
    )) {
      return;
    }

    final currentProgress = currentState.map(
      initial: (_) => BadgeProgress(
        currentLevel: BadgeLevel.beginner,
        booksRead: 0,
        favoriteBooks: 0,
        readingStreak: 0,
        lastUpdated: DateTime.now(),
      ),
      loaded: (s) => s.progress,
      levelingUp: (s) => s.progress,
    );

    final newLevel = _calculateBadgeLevel(wordCount);

    if (newLevel != currentProgress.currentLevel) {
      add(BadgeEvent.levelUp(newLevel));
    }

    final newProgress = currentProgress.copyWith(
      currentLevel: newLevel,
      booksRead: wordCount ~/ 100, // Rough estimate
      lastUpdated: DateTime.now(),
    );

    await _badgeRepository.updateBadgeProgress(newProgress);
    emit(BadgeState.loaded(newProgress));
  }

  Future<void> _onLevelUp(
    BadgeLevel newLevel,
    Emitter<BadgeState> emit,
  ) async {
    final currentState = state;
    if (!currentState.map(
      initial: (_) => false,
      loaded: (_) => true,
      levelingUp: (_) => true,
    )) {
      return;
    }

    final currentProgress = currentState.map(
      initial: (_) => BadgeProgress(
        currentLevel: BadgeLevel.beginner,
        booksRead: 0,
        favoriteBooks: 0,
        readingStreak: 0,
        lastUpdated: DateTime.now(),
      ),
      loaded: (s) => s.progress,
      levelingUp: (s) => s.progress,
    );

    emit(BadgeState.levelingUp(currentProgress, newLevel));

    // Reset to loaded state after showing level up
    await Future.delayed(const Duration(seconds: 2));
    final updatedProgress = currentProgress.copyWith(currentLevel: newLevel);
    emit(BadgeState.loaded(updatedProgress));
  }

  BadgeLevel _calculateBadgeLevel(int wordCount) {
    if (wordCount >= 1000) return BadgeLevel.master;
    if (wordCount >= 500) return BadgeLevel.advanced;
    if (wordCount >= 100) return BadgeLevel.intermediate;
    return BadgeLevel.beginner;
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
