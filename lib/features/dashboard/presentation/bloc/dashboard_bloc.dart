import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/user_stats_repository.dart';
import '../../domain/models/user_stats.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserStatsRepository _userStatsRepository;
  StreamSubscription<UserStats>? _statsSubscription;
  StreamSubscription<User?>? _authSubscription;

  DashboardBloc({
    required UserStatsRepository userStatsRepository,
  })  : _userStatsRepository = userStatsRepository,
        super(const DashboardState.initial()) {
    on<_LoadDashboardStats>(_onLoadDashboardStats);

    // Listen to auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          // Only load stats when we have a confirmed authenticated user
          add(const DashboardEvent.loadDashboardStats());
        } else {
          emit(const DashboardState.error('Not authenticated'));
        }
      },
      onError: (error) {
        print('Auth state error: $error');
        emit(DashboardState.error(error.toString()));
      },
    );
  }

  void loadDashboardStats() {
    add(const DashboardEvent.loadDashboardStats());
  }

  Future<void> _onLoadDashboardStats(
    _LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      // Check if we're authenticated before proceeding
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const DashboardState.error('Not authenticated'));
        return;
      }

      print('Loading dashboard stats for user: ${user.uid}');
      emit(const DashboardState.loading());

      // Cancel any existing subscription
      await _statsSubscription?.cancel();

      try {
        // Always get fresh stats from Firestore first
        final freshStats = await _userStatsRepository.getUserStats();
        emit(DashboardState.loaded(
          booksRead: freshStats.booksRead,
          favoriteBooks: freshStats.favoriteBooks,
          readingStreak: freshStats.readingStreak,
          savedWords: freshStats.savedWords,
        ));

        // Then set up subscription for future updates
        _statsSubscription = _userStatsRepository.streamUserStats().listen(
          (stats) {
            print('Received stats update: $stats');
            // Verify the stats are different before emitting
            if (state is _Loaded) {
              final currentState = state as _Loaded;
              if (currentState.booksRead != stats.booksRead ||
                  currentState.favoriteBooks != stats.favoriteBooks ||
                  currentState.readingStreak != stats.readingStreak ||
                  currentState.savedWords != stats.savedWords) {
                emit(DashboardState.loaded(
                  booksRead: stats.booksRead,
                  favoriteBooks: stats.favoriteBooks,
                  readingStreak: stats.readingStreak,
                  savedWords: stats.savedWords,
                ));
              }
            } else {
              emit(DashboardState.loaded(
                booksRead: stats.booksRead,
                favoriteBooks: stats.favoriteBooks,
                readingStreak: stats.readingStreak,
                savedWords: stats.savedWords,
              ));
            }
          },
          onError: (error) {
            print('Error in stats stream: $error');
            emit(DashboardState.error(error.toString()));
          },
        );
      } catch (e) {
        print('Error getting user stats: $e');
        emit(DashboardState.error('Failed to load stats: $e'));
        // Try to reinitialize after error
        Future.delayed(const Duration(seconds: 5), () {
          loadDashboardStats();
        });
      }
    } catch (e) {
      print('Error in _onLoadDashboardStats: $e');
      emit(DashboardState.error(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _statsSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }
}
