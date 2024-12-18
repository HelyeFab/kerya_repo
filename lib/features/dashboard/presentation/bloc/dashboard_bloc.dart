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

      emit(const DashboardState.loading());

      // Cancel any existing subscription
      await _statsSubscription?.cancel();

      // Subscribe to real-time updates with proper error handling
      await for (final stats in _userStatsRepository.streamUserStats()) {
        emit(DashboardState.loaded(
          booksRead: stats.booksRead,
          favoriteBooks: stats.favoriteBooks,
          readingStreak: stats.readingStreak,
          savedWords: stats.savedWords,
        ));
      }
    } catch (e) {
      print('Error loading dashboard stats: $e');
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
