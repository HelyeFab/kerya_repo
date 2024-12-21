import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/menu_button.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../badges/presentation/widgets/badge_display.dart';
import '../../../badges/domain/models/badge_level.dart';
import '../../../badges/domain/models/badge_progress.dart';
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
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(UiTranslationService.translate(context, 'nav_create')),
          actions: [
            BlocBuilder<BadgeBloc, BadgeState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) => const SizedBox.shrink(),
                  loaded: (loaded) => BadgeDisplay(
                    level: loaded.progress.currentLevel,
                    onTap: () => _showBadgeProgressDialog(context, loaded.progress),
                  ),
                  levelingUp: (levelingUp) => BadgeDisplay(
                    level: levelingUp.progress.currentLevel,
                    onTap: () => _showBadgeProgressDialog(context, levelingUp.progress),
                  ),
                );
              },
            ),
            const MenuButton(),
            const SizedBox(width: 16),
          ],
        ),
        body: const Center(
          child: Text('Create Page - Coming Soon!'),
        ),
      ),
    );
  }

  void _showBadgeProgressDialog(BuildContext context, BadgeProgress progress) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(UiTranslationService.translate(context, 'badge_progress_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BadgeDisplay(
              level: progress.currentLevel,
              showName: true,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              UiTranslationService.translate(context, 'badge_progress_subtitle'),
            ),
            const SizedBox(height: 8),
            Text(
              '${progress.booksRead} books read',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(UiTranslationService.translate(context, 'common_close')),
          ),
        ],
      ),
    );
  }
}
