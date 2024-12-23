import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/menu_button.dart';
import '../../../badges/presentation/widgets/badge_display.dart';
import '../../../badges/domain/repositories/badge_repository.dart';
import '../../../badges/presentation/bloc/badge_bloc.dart';
import '../../../badges/presentation/bloc/badge_state.dart';
import '../../../badges/presentation/bloc/badge_event.dart';
import '../../../dictionary/data/repositories/saved_words_repository.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BadgeBloc(
        badgeRepository: context.read<BadgeRepository>(),
        savedWordsRepository: context.read<SavedWordsRepository>(),
      )..add(const BadgeEvent.started()),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: BlocBuilder<BadgeBloc, BadgeState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => const SizedBox.shrink(),
                    loaded: (loaded) => BadgeDisplay(
                      level: loaded.progress.currentLevel,
                    ),
                    levelingUp: (levelingUp) => BadgeDisplay(
                      level: levelingUp.progress.currentLevel,
                    ),
                  );
                },
              ),
            ),
            actions: const [
              MenuButton(),
              SizedBox(width: 16),
            ],
          ),
          body: const Center(
            child: Text('Create Page - Coming Soon!'),
          ),
        ),
      ),
    );
  }
}
