import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../ui_language/service/ui_translation_service.dart';
import '../theme/color_schemes.dart';

class KeyraBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KeyraBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
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
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: Colors.transparent,
          indicatorColor: isDark
              ? AppColors.controlPurple.withOpacity(0.7)
              : AppColors.readerControl.withOpacity(0.7),
          destinations: [
            NavigationDestination(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedHome13,
                size: 24.0,
                color: iconColor,
              ),
              label: UiTranslationService.translate(context, 'nav_home'),
            ),
            NavigationDestination(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedBook02,
                size: 24.0,
                color: iconColor,
              ),
              label: UiTranslationService.translate(context, 'nav_library'),
            ),
            NavigationDestination(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedIdea01,
                size: 24.0,
                color: iconColor,
              ),
              label: UiTranslationService.translate(context, 'nav_create'),
            ),
            NavigationDestination(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedDashboardBrowsing,
                size: 24.0,
                color: iconColor,
              ),
              label: UiTranslationService.translate(context, 'nav_dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
