import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/features/dashboard/domain/models/user_stats.dart';

class MiniStatsDisplay extends StatefulWidget {
  const MiniStatsDisplay({super.key});

  @override
  State<MiniStatsDisplay> createState() => _MiniStatsDisplayState();
}

class _MiniStatsDisplayState extends State<MiniStatsDisplay> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('[MiniStatsDisplay] Initializing and loading stats');
    context.read<DashboardBloc>().loadDashboardStats();
  }

  @override
  void dispose() {
    print('[MiniStatsDisplay] Disposing');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('[MiniStatsDisplay] AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.resumed) {
      print('[MiniStatsDisplay] App resumed, reloading stats');
      context.read<DashboardBloc>().loadDashboardStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        print('[MiniStatsDisplay] Building with state: $state');
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (error) {
            print('[MiniStatsDisplay] Error state: $error');
            return const SizedBox.shrink();
          },
          loaded: (booksRead, favoriteBooks, readingStreak, savedWords) {
            print('[MiniStatsDisplay] Loaded state - Books: $booksRead, Streak: $readingStreak');
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatItem(
                    context,
                    Icons.book,
                    booksRead.toString(),
                    'Books Read',
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    context,
                    Icons.local_fire_department,
                    readingStreak.toString(),
                    'Day Streak',
                    Colors.orange,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
