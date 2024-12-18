import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repositories/user_stats_repository.dart';
import '../../domain/models/user_stats.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserStatsRepository _userStatsRepository;
  StreamSubscription<UserStats>? _statsSubscription;

  DashboardBloc({
    required UserStatsRepository userStatsRepository,
  })  : _userStatsRepository = userStatsRepository,
        super(const DashboardState.initial()) {
    on<_LoadDashboardStats>(_onLoadDashboardStats);
  }

  void loadDashboardStats() {
    add(const DashboardEvent.loadDashboardStats());
  }

  Future<void> _onLoadDashboardStats(
    _LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardState.loading());

      // Cancel any existing subscription
      await _statsSubscription?.cancel();

      // Subscribe to real-time updates
      _statsSubscription = _userStatsRepository.streamUserStats().listen(
        (stats) {
          emit(DashboardState.loaded(
            booksRead: stats.booksRead,
            favoriteBooks: stats.favoriteBooks,
            readingStreak: stats.readingStreak,
            savedWords: stats.savedWords,
          ));
        },
        onError: (error) {
          emit(DashboardState.error(error.toString()));
        },
      );
    } catch (e) {
      emit(DashboardState.error(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _statsSubscription?.cancel();
    return super.close();
  }
}
