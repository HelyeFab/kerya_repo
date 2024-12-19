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

      try {
        // Only set up the stream subscription if it doesn't exist
        _statsSubscription ??= _userStatsRepository.streamUserStats().listen(
          (stats) {
            print('Received stats update: $stats');
            if (!isClosed && !emit.isDone) {
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
            if (!isClosed && !emit.isDone) {
              emit(DashboardState.error(error.toString()));
            }
          },
        );

        // Get initial stats
        final freshStats = await _userStatsRepository.getUserStats();
        if (!emit.isDone) {
          emit(DashboardState.loaded(
            booksRead: freshStats.booksRead,
            favoriteBooks: freshStats.favoriteBooks,
            readingStreak: freshStats.readingStreak,
            savedWords: freshStats.savedWords,
          ));
        }
      } catch (e) {
        print('Error getting user stats: $e');
        if (!emit.isDone) {
          emit(DashboardState.error('Failed to load stats: $e'));
        }
        // Try to reinitialize after error
        Future.delayed(const Duration(seconds: 5), () {
          if (!isClosed) {
            loadDashboardStats();
          }
        });
      }
    } catch (e) {
      print('Error in _onLoadDashboardStats: $e');
      if (!emit.isDone) {
        emit(DashboardState.error(e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _statsSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }
}
