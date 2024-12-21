import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/badge_level.dart';
import '../bloc/badge_bloc.dart';
import '../bloc/badge_state.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';

class BadgeDisplay extends StatelessWidget {
  final BadgeLevel level;
  final bool showName;
  final double size;
  final VoidCallback? onTap;

  const BadgeDisplay({
    super.key,
    required this.level,
    this.showName = false,
    this.size = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BadgeBloc, BadgeState>(
      listenWhen: (previous, current) => current.map(
        initial: (_) => false,
        loaded: (_) => false,
        levelingUp: (_) => true,
      ),
      listener: (context, state) {
        state.map(
          initial: (_) {},
          loaded: (_) {},
          levelingUp: (_) => _showLevelUpDialog(context),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              level.assetPath,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
            if (showName) ...[
              const SizedBox(width: 8),
              Text(
                level.displayName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLevelUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(UiTranslationService.translate(context, 'badge_unlocked')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              level.assetPath,
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 16),
            Text(
              UiTranslationService.translate(
                context,
                'badge_level_up_message',
              ),
              textAlign: TextAlign.center,
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
